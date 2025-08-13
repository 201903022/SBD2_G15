# Problemas comunes al usar pgAdmin4 con Docker Compose en Fedora 41

## Descripción del entorno

Se utilizó el siguiente `docker-compose.yml` para levantar contenedores de PostgreSQL y pgAdmin:

```yaml
services:
  myDB:
    image: postgres:15.3
    container_name: my-database
    restart: always
    ports:
      - 5432:5432
    environment:
      - POSTGRES_USER=grupo15
      - POSTGRES_PASSWORD=grupo15
      - POSTGRES_DB=bases2-db-t1
    volumes:
      - ./postgres:/var/lib/postgresql/data

  pdAdmin:
    image: dpage/pgadmin4
    container_name: pgadmin4
    restart: always
    depends_on:
      - myDB
    ports:
      - 8080:80
    environment:
      - PGADMIN_DEFAULT_EMAIL=grupo15@google.com
      - PGADMIN_DEFAULT_PASSWORD=123456
    volumes:
      - ./pgadmin:/var/lib/pgadmin
```

## Problema principal

Al iniciar el contenedor `pgadmin4`, se presentaban errores como los siguientes:

```
ERROR  : Failed to create the directory /var/lib/pgadmin/sessions:
         [Errno 13] Permission denied: '/var/lib/pgadmin/sessions'
```

Esto impedía que pgAdmin se ejecutara correctamente.

## Causa

El problema se debe a que la carpeta `./pgadmin` en el host no tiene los permisos correctos para que el usuario interno `pgadmin` (UID 5050) dentro del contenedor pueda escribir.

## Solución

1. Eliminar el volumen y la carpeta con permisos incorrectos:

```bash
sudo rm -rf ./pgadmin
```

2. Crear nuevamente la carpeta:

```bash
mkdir ./pgadmin
```

3. Asignar los permisos correctos al UID 5050 (usuario `pgadmin` dentro del contenedor):

```bash
sudo chown -R 5050:5050 ./pgadmin
```

4. Levantar de nuevo los contenedores:

```bash
docker-compose up -d
```

## Resultado

pgAdmin inicia correctamente y puede ser accedido desde el navegador en:

```
http://localhost:8080
```

