# Tipos de Datos en PostgreSQL

## Numéricos

| Tipo                            | Descripción                                              | Ejemplo                     |
| ------------------------------- | -------------------------------------------------------- | --------------------------- |
| `SMALLINT`                      | Entero de 2 bytes (rango -32,768 a 32,767)               | `edad SMALLINT`             |
| `INTEGER` o `INT`               | Entero de 4 bytes (rango -2,147,483,648 a 2,147,483,647) | `cantidad INT`              |
| `BIGINT`                        | Entero de 8 bytes (rangos muy grandes)                   | `saldo BIGINT`              |
| `DECIMAL(p,s)` / `NUMERIC(p,s)` | Precisión fija (ej. `DECIMAL(10,2)`)                     | `precio DECIMAL(10,2)`      |
| `REAL`                          | Número de coma flotante de 4 bytes                       | `temperatura REAL`          |
| `DOUBLE PRECISION`              | Flotante de 8 bytes                                      | `medicion DOUBLE PRECISION` |
| `SERIAL` / `BIGSERIAL`          | Entero autoincremental (4 / 8 bytes)                     | `id SERIAL PRIMARY KEY`     |

---

##  Texto y Cadenas

| Tipo         | Descripción                           | Ejemplo               |
| ------------ | ------------------------------------- | --------------------- |
| `CHAR(n)`    | Cadena de longitud fija               | `codigo CHAR(5)`      |
| `VARCHAR(n)` | Cadena de longitud variable hasta `n` | `nombre VARCHAR(100)` |
| `TEXT`       | Cadena de longitud ilimitada          | `descripcion TEXT`    |

---

## Fechas y Tiempos

| Tipo                                       | Descripción                   | Ejemplo                    |
| ------------------------------------------ | ----------------------------- | -------------------------- |
| `DATE`                                     | Fecha (AAAA-MM-DD)            | `fecha_nacimiento DATE`    |
| `TIME`                                     | Hora (hh\:mm\:ss)             | `hora TIME`                |
| `TIMESTAMP`                                | Fecha y hora                  | `fecha_registro TIMESTAMP` |
| `TIMESTAMP WITH TIME ZONE` (`TIMESTAMPTZ`) | Fecha y hora con zona horaria | `creado TIMESTAMPTZ`       |
| `INTERVAL`                                 | Periodo de tiempo             | `duracion INTERVAL`        |

---

##  Booleanos y Lógicos

| Tipo      | Descripción                                 | Ejemplo          |
| --------- | ------------------------------------------- | ---------------- |
| `BOOLEAN` | Verdadero o falso (`TRUE`, `FALSE`, `NULL`) | `activo BOOLEAN` |

---

## UUID (Identificadores Únicos Universales)

| Tipo   | Descripción                                      | Ejemplo      |
| ------ | ------------------------------------------------ | ------------ |
| `UUID` | Cadena única global (ideal para identificadores) | `token UUID` |

---

##  Arreglos (Arrays)

| Tipo     | Descripción                                       | Ejemplo            |
| -------- | ------------------------------------------------- | ------------------ |
| `tipo[]` | Arreglo de cualquier tipo (números, textos, etc.) | `etiquetas TEXT[]` |

---

## JSON / JSONB

| Tipo    | Descripción                       | Ejemplo          |
| ------- | --------------------------------- | ---------------- |
| `JSON`  | Almacena texto JSON sin optimizar | `info JSON`      |
| `JSONB` | JSON binario, más eficiente       | `detalles JSONB` |

---

##  Tipos Geométricos

| Tipo                             | Descripción                      |
| -------------------------------- | -------------------------------- |
| `POINT`, `LINE`, `CIRCLE`, `BOX` | Coordenadas y formas geométricas |

---

##  Enumerados (ENUM)

```sql
CREATE TYPE estado_enum AS ENUM ('activo', 'inactivo', 'pendiente');
```

Luego se usa en una tabla:

```sql
estado estado_enum
```

---

##  Ejemplo de Tabla Completa

```sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    correo TEXT UNIQUE NOT NULL,
    edad INTEGER,
    fecha_nacimiento DATE,
    creado TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    preferencias JSONB,
    roles TEXT[],
    estado estado_enum
);
```
