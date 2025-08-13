# Documentacion

## Iniciar venv

```bash
# crear y activar entorno virtual
python3 -m venv venv
source venv/bin/activate

# instalar dependencias
pip3 install -r requirements.txt
```

## Estructura de archivo ``.env``

```env
DB_HOST = localhost
DB_PORT = 5432
DB_USER = db_user
DB_PASSWORD = db_password
DB_NAME = database_name
```

## Ejecutar el archio main.py

```bash
python3 main.py
```
