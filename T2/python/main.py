import pandas as pd
import psycopg2
from dotenv import load_dotenv
import os

# Cargar variables de entorno desde .env
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

# Conectar a la base de datos PostgreSQL
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD
)
cursor = conn.cursor()

# Cargar y limpiar el CSV
df = pd.read_csv("netflix_titles.csv").fillna("")

# Insertar valores únicos en una tabla
def insert_unique(table, column, values):
    unique = set()
    for val in values:
        for v in val.split(","):
            v = v.strip()
            if v:
                unique.add(v)
    for v in unique:
        cursor.execute(
            f"INSERT INTO {table} ({column}) VALUES (%s) ON CONFLICT DO NOTHING", (v,)
        )

# Insertar en tablas maestras
insert_unique("directors", "name", df["director"])
insert_unique("actors", "name", df["cast"])
insert_unique("countries", "name", df["country"])
insert_unique("categories", "name", df["listed_in"])
insert_unique("ratings", "rating_code", df["rating"])
insert_unique("types", "name", df["type"])
conn.commit()

# Obtener ID real usando mapeo
def get_id(table, column, value):
    id_columns = {
        "types": "type_id",
        "directors": "director_id",
        "actors": "actor_id",
        "countries": "country_id",
        "ratings": "rating_id",
        "categories": "category_id"
    }
    if not value:
        return None
    id_column = id_columns.get(table)
    if not id_column:
        raise Exception(f"No ID column defined for table '{table}'")
    cursor.execute(f"SELECT {id_column} FROM {table} WHERE {column} = %s", (value,))
    result = cursor.fetchone()
    return result[0] if result else None

# Insertar shows y relaciones N:M
for _, row in df.iterrows():
    type_id = get_id("types", "name", row["type"])
    rating_id = get_id("ratings", "rating_code", row["rating"])
    director_id = get_id("directors", "name", row["director"].split(",")[0].strip()) if row["director"] else None

    # Insertar show
    cursor.execute("""
        INSERT INTO shows (show_id, type_id, title, director_id, date_added, release_year, rating_id, duration, description)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT DO NOTHING
    """, (
        row["show_id"], type_id, row["title"], director_id,
        pd.to_datetime(row["date_added"], errors="coerce") if row["date_added"] else None,
        int(row["release_year"]) if row["release_year"] else None,
        rating_id, row["duration"], row["description"]
    ))

    # Relacionar actores
    for actor in row["cast"].split(","):
        actor = actor.strip()
        if actor:
            actor_id = get_id("actors", "name", actor)
            if actor_id:
                cursor.execute(
                    "INSERT INTO show_actors (show_id, actor_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                    (row["show_id"], actor_id)
                )

    # Relacionar países
    for country in row["country"].split(","):
        country = country.strip()
        if country:
            country_id = get_id("countries", "name", country)
            if country_id:
                cursor.execute(
                    "INSERT INTO show_countries (show_id, country_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                    (row["show_id"], country_id)
                )

    # Relacionar categorías
    for cat in row["listed_in"].split(","):
        cat = cat.strip()
        if cat:
            category_id = get_id("categories", "name", cat)
            if category_id:
                cursor.execute(
                    "INSERT INTO show_categories (show_id, category_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                    (row["show_id"], category_id)
                )

# Confirmar cambios y cerrar conexión
conn.commit()
cursor.close()
conn.close()
