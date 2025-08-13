/*
Procedimientos a realizar:

* 4 procedimientos de inserción
! 4 procedimientos de actualización
* 4 procedimientos de eliminación
*/
----------------------------------------Metodo de inserción----------------------------------------
-- * 1)  Tabla actors
CREATE OR REPLACE PROCEDURE insert_actor(
    p_actor_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _actor_exists BOOLEAN;
BEGIN
    -- Verificar si el actor ya existe
    SELECT EXISTS(SELECT 1 FROM actors WHERE name = p_actor_name) INTO _actor_exists;
    IF _actor_exists THEN
        RAISE NOTICE 'Actor % already exists', p_actor_name;
        RETURN; -- Salir si el actor ya existe
    END IF;

    -- Insertar el nuevo actor
    INSERT INTO actors (name)
    VALUES (p_actor_name);

    RAISE NOTICE 'Inserted actor: %', p_actor_name;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error inserting actor %: %', p_actor_name, SQLERRM;
END;
$$;

--* 2)  Tabla categories
CREATE OR REPLACE PROCEDURE insert_category(
    p_category_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _category_exists BOOLEAN;
BEGIN
    -- verificar si la categoría ya existe
    SELECT EXISTS(SELECT 1 FROM categories WHERE name = p_category_name) INTO _category_exists;
    IF _category_exists THEN
        RAISE NOTICE 'Category % already exists', p_category_name;
        RETURN;
    END IF;

    INSERT INTO categories (name)
    VALUES (p_category_name);

    RAISE NOTICE 'Inserted category: %', p_category_name;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error inserting category %: %', p_category_name, SQLERRM;
END;
$$;

-- * 3) Tabla show_actors
CREATE OR REPLACE PROCEDURE insert_show_actor(
    p_show_id TEXT,
    p_actor_id INTEGER
)
LANGUAGE plpgsql
AS $$ 
DECLARE 
    _show_id_exists BOOLEAN;
    _actor_id_exists BOOLEAN;
    _duplicate_exists BOOLEAN;
BEGIN
    -- Verificar si el show_id existe
    SELECT EXISTS(SELECT 1 FROM shows WHERE show_id = p_show_id) INTO _show_id_exists;
    IF NOT _show_id_exists THEN
        RAISE NOTICE 'Show ID % does not exist', p_show_id;
        --ROLLBACK TO SAVEPOINT sp_insert_show_actor;
        RETURN;
    END IF;

    -- Verificar si el actor_id existe
    SELECT EXISTS(SELECT 1 FROM actors WHERE actor_id = p_actor_id) INTO _actor_id_exists;
    IF NOT _actor_id_exists THEN
        RAISE NOTICE 'Actor ID % does not exist', p_actor_id;
        ---ROLLBACK TO SAVEPOINT sp_insert_show_actor;
        RETURN;
    END IF;

    --verifcacion de duplicados
    SELECT EXISTS(
        SELECT 1 
        FROM show_actors 
        WHERE show_id = p_show_id AND actor_id = p_actor_id
    ) INTO _duplicate_exists;
    IF _duplicate_exists THEN
        RAISE NOTICE 'Duplicate entry for Show ID % and Actor ID %', p_show_id, p_actor_id;
        --ROLLBACK TO SAVEPOINT sp_insert_show_actor;
        RETURN;
    END IF;

    --ahora si, la inserción
    INSERT INTO show_actors (show_id, actor_id)
    VALUES (p_show_id, p_actor_id);

    RAISE NOTICE 'Inserted Show ID % and Actor ID % successfully', p_show_id, p_actor_id;
EXCEPTION
    WHEN OTHERS THEN
        --ROLLBACK TO SAVEPOINT sp_insert_show_actor;
        RAISE NOTICE 'Error inserting Show ID % and Actor ID %: %', p_show_id, p_actor_id, SQLERRM;
END;
$$;

-- * 4) Tabla countries
CREATE OR REPLACE PROCEDURE insert_country(
    p_country_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _country_exists BOOLEAN;
BEGIN

    -- Verificar si el país ya existe
    SELECT EXISTS(SELECT 1 FROM countries WHERE name = p_country_name) INTO _country_exists;
    IF _country_exists THEN
        RAISE NOTICE 'Country % already exists', p_country_name;
        RETURN; -- Salir si el país ya existe
    END IF;
    -- Insertar el nuevo país
    INSERT INTO countries (name)
    VALUES (p_country_name);
    RAISE NOTICE 'Inserted country: %', p_country_name;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error inserting country %: %', p_country_name, SQLERRM;   

END;
$$;

-- * llamadas a los procedimientos de inserción
call insert_actor('Grupo15Actor1');
select *  from actors where name like '%rupo15%';

call insert_category('Grupo15Category2');
select * from categories where name like '%rupo15%';

call insert_show_actor('s2', 1);
select * from show_actors where show_id = 's2';

call insert_country('Grupo15Country');
select * from countries where name like '%rupo15%';

---------------------------------- Metodos de eliminacion----------------------------------------
-- * 1)  Tabla actors
CREATE OR REPLACE PROCEDURE delete_actor(
    p_actor_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    _exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM actors WHERE actor_id = p_actor_id) INTO _exists;
    IF NOT _exists THEN
        RAISE NOTICE 'Actor ID % does not exist', p_actor_id;
        RETURN;
    END IF;

    DELETE FROM actors WHERE actor_id = p_actor_id;
    RAISE NOTICE 'Deleted actor with ID %', p_actor_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error deleting actor with ID %: %', p_actor_id, SQLERRM;
END;
$$;
-- * 2)  Tabla categories
CREATE OR REPLACE PROCEDURE delete_category(
    p_category_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    _exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM categories WHERE category_id = p_category_id) INTO _exists;
    IF NOT _exists THEN
        RAISE NOTICE 'Category ID % does not exist', p_category_id;
        RETURN;
    END IF;

    DELETE FROM categories WHERE category_id = p_category_id;
    RAISE NOTICE 'Deleted category with ID %', p_category_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error deleting category with ID %: %', p_category_id, SQLERRM;
END;
$$;
-- * 3) Tabla show_actors
CREATE OR REPLACE PROCEDURE delete_show_actor(
    p_show_id TEXT,
    p_actor_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    _exists BOOLEAN;
BEGIN
    SELECT EXISTS(
        SELECT 1 FROM show_actors WHERE show_id = p_show_id AND actor_id = p_actor_id
    ) INTO _exists;
    
    IF NOT _exists THEN
        RAISE NOTICE 'Relation between Show % and Actor % does not exist', p_show_id, p_actor_id;
        RETURN;
    END IF;

    DELETE FROM show_actors WHERE show_id = p_show_id AND actor_id = p_actor_id;
    RAISE NOTICE 'Deleted relation: Show ID % and Actor ID %', p_show_id, p_actor_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error deleting relation Show ID % and Actor ID %: %', p_show_id, p_actor_id, SQLERRM;
END;
$$;
-- * 4) Tabla countries
CREATE OR REPLACE PROCEDURE delete_country(
    p_country_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    _exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM countries WHERE country_id = p_country_id) INTO _exists;
    IF NOT _exists THEN
        RAISE NOTICE 'Country ID % does not exist', p_country_id;
        RETURN;
    END IF;

    DELETE FROM countries WHERE country_id = p_country_id;
    RAISE NOTICE 'Deleted country with ID %', p_country_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error deleting country with ID %: %', p_country_id, SQLERRM;
END;
$$;

CALL delete_actor(1);
CALL delete_category(2);
CALL delete_show_actor('s2', 1);
CALL delete_country(3);

---------------------------------- Metodos de actualizacion----------------------
------------------
-- * 1)  Tabla actors: actualiza el nombre del actor
CREATE OR REPLACE PROCEDURE update_actor(
p_actor_id INTEGER,
p_new_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
_actor_exists BOOLEAN;
_name_taken BOOLEAN;
BEGIN
-- Verificar si el actor existe
SELECT EXISTS(SELECT 1 FROM actors WHERE actor_id = p_actor_id) INTO
_actor_exists;
IF NOT _actor_exists THEN
RAISE NOTICE 'Actor with ID % does not exist', p_actor_id;
RETURN;
END IF;
-- Verificar si el nuevo nombre ya está en uso
SELECT EXISTS(SELECT 1 FROM actors WHERE name = p_new_name AND actor_id <>
p_actor_id) INTO _name_taken;
IF _name_taken THEN
RAISE NOTICE 'Actor name % is already in use', p_new_name;
RETURN;
END IF;
-- Actualizar
UPDATE actors
SET name = p_new_name
WHERE actor_id = p_actor_id;
RAISE NOTICE 'Updated actor ID % to new name: %', p_actor_id, p_new_name;
EXCEPTION
WHEN OTHERS THEN
RAISE NOTICE 'Error updating actor %: %', p_actor_id, SQLERRM;
END;
$$;

-- * 2)  Tabla categories: actualiza el nombre de la categoría
CREATE OR REPLACE PROCEDURE update_category(
p_category_id INTEGER,
p_new_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
_category_exists BOOLEAN;
_name_taken BOOLEAN;
BEGIN
-- Verificar si la categoría existe
SELECT EXISTS(SELECT 1 FROM categories WHERE category_id = p_category_id)
INTO _category_exists;
IF NOT _category_exists THEN
RAISE NOTICE 'Category ID % does not exist', p_category_id;
RETURN;
END IF;
-- Verificar si el nuevo nombre ya existe para otra categoría
SELECT EXISTS(SELECT 1 FROM categories WHERE name = p_new_name AND
category_id <> p_category_id) INTO _name_taken;
IF _name_taken THEN
RAISE NOTICE 'Category name % is already in use', p_new_name;
RETURN;
END IF;
-- Actualizar
UPDATE categories
SET name = p_new_name
WHERE category_id = p_category_id;
RAISE NOTICE 'Updated category ID % to new name: %', p_category_id,
p_new_name;
EXCEPTION
WHEN OTHERS THEN
RAISE NOTICE 'Error updating category %: %', p_category_id, SQLERRM;
END;
$$;

-- * 3) Tabla show_actors: actualiza el actor asociado a un show 
CREATE OR REPLACE PROCEDURE update_show_actor(
p_old_show_id TEXT,
p_old_actor_id INTEGER,
p_new_show_id TEXT,
p_new_actor_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
_original_exists BOOLEAN;
_new_duplicate BOOLEAN;
BEGIN
-- Verificar si la relación original existe
SELECT EXISTS(
SELECT 1 FROM show_actors
WHERE show_id = p_old_show_id AND actor_id = p_old_actor_id
) INTO _original_exists;
IF NOT _original_exists THEN
RAISE NOTICE 'Original relation does not exist';
RETURN;
END IF;
-- Verificar que la nueva relación no esté duplicada
SELECT EXISTS(
SELECT 1 FROM show_actors
WHERE show_id = p_new_show_id AND actor_id = p_new_actor_id
) INTO _new_duplicate;
IF _new_duplicate THEN
RAISE NOTICE 'Duplicate relation already exists';
RETURN;
END IF;
-- Actualizar
UPDATE show_actors
SET show_id = p_new_show_id,
actor_id = p_new_actor_id
WHERE show_id = p_old_show_id AND actor_id = p_old_actor_id;
RAISE NOTICE 'Updated show_actor relation to Show ID %, Actor ID %',
p_new_show_id, p_new_actor_id;
EXCEPTION
WHEN OTHERS THEN
RAISE NOTICE 'Error updating show_actor relation: %', SQLERRM;
END;
$$;

-- * 4) Tabla countries: actualiza el nombre del país
CREATE OR REPLACE PROCEDURE update_country(
p_country_id INTEGER,
p_new_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
_country_exists BOOLEAN;
_name_taken BOOLEAN;
BEGIN
-- Verificar si el país existe
SELECT EXISTS(SELECT 1 FROM countries WHERE country_id = p_country_id) INTO
_country_exists;
IF NOT _country_exists THEN
RAISE NOTICE 'Country ID % does not exist', p_country_id;
RETURN;
END IF;
-- Verificar si el nuevo nombre ya existe
SELECT EXISTS(SELECT 1 FROM countries WHERE name = p_new_name AND country_id
<> p_country_id) INTO _name_taken;
IF _name_taken THEN
RAISE NOTICE 'Country name % is already in use', p_new_name;
RETURN;
END IF;
-- Actualizar
UPDATE countries
SET name = p_new_name
WHERE country_id = p_country_id;
RAISE NOTICE 'Updated country ID % to new name: %', p_country_id, p_new_name;
EXCEPTION
WHEN OTHERS THEN
RAISE NOTICE 'Error updating country %: %', p_country_id, SQLERRM;
END;
$$;

-- Actor
CALL update_actor(1, 'ActorActualizado');
-- Categoría
CALL update_category(2, 'CategoryActualizada');
-- Relación show-actor
CALL update_show_actor('s2', 1, 's2', 3); -- cambia actor 1 por actor 3
-- País
CALL update_country(5, 'CountryActualizado');