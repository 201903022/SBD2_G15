
CREATE TABLE types (
    type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE directors (
    director_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE actors (
    actor_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    rating_code VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE shows (
    show_id TEXT PRIMARY KEY,
    type_id INTEGER NOT NULL REFERENCES types(type_id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    director_id INTEGER REFERENCES directors(director_id) ON DELETE SET NULL,
    date_added DATE,
    release_year INT NOT NULL,
    rating_id INTEGER REFERENCES ratings(rating_id) ON DELETE SET NULL,
    duration TEXT,
    description TEXT
);

CREATE TABLE show_actors (
    show_actor_id SERIAL PRIMARY KEY,
    show_id TEXT REFERENCES shows(show_id) ON DELETE SET NULL,
    actor_id INTEGER REFERENCES actors(actor_id) ON DELETE SET NULL
);

CREATE TABLE show_categories (
    show_category_id SERIAL PRIMARY KEY,
    show_id TEXT REFERENCES shows(show_id) ON DELETE SET NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE TABLE show_countries (
    show_country_id SERIAL PRIMARY KEY,
    show_id TEXT REFERENCES shows(show_id) ON DELETE SET NULL,
    country_id INTEGER REFERENCES countries(country_id) ON DELETE SET NULL
);
--145757