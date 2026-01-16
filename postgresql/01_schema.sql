-- =========================================
-- Sakila (MySQL) -> PostgreSQL
-- Version "requêtes uniquement" : NO TRIGGERS
-- =========================================



-- -----------------------------------------
-- country / city / address
-- -----------------------------------------

CREATE TABLE country (
  country_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  country varchar(50) NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE city (
  city_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  city varchar(50) NOT NULL,
  country_id smallint NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_city_country
    FOREIGN KEY (country_id) REFERENCES country(country_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_country_id ON city(country_id);

CREATE TABLE address (
  address_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  address varchar(50) NOT NULL,
  address2 varchar(50),
  district varchar(20) NOT NULL,
  city_id smallint NOT NULL,
  postal_code varchar(10),
  phone varchar(20) NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_address_city
    FOREIGN KEY (city_id) REFERENCES city(city_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_city_id ON address(city_id);

-- -----------------------------------------
-- language / actor / category
-- -----------------------------------------

CREATE TABLE language (
  language_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name char(20) NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE actor (
  actor_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  first_name varchar(45) NOT NULL,
  last_name varchar(45) NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_actor_last_name ON actor(last_name);

CREATE TABLE category (
  category_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(25) NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------
-- film
-- -----------------------------------------

CREATE TABLE film (
  film_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title varchar(128) NOT NULL,
  description text,
  release_year smallint, -- YEAR -> smallint
  language_id smallint NOT NULL,
  original_language_id smallint,
  rental_duration smallint NOT NULL DEFAULT 3,
  rental_rate numeric(4,2) NOT NULL DEFAULT 4.99,
  length smallint,
  replacement_cost numeric(5,2) NOT NULL DEFAULT 19.99,

  rating text DEFAULT 'G',
  special_features text[], -- MySQL SET -> text[]

  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT chk_film_rating
    CHECK (rating IN ('G','PG','PG-13','R','NC-17')),

  CONSTRAINT fk_film_language
    FOREIGN KEY (language_id) REFERENCES language(language_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_film_language_original
    FOREIGN KEY (original_language_id) REFERENCES language(language_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_title ON film(title);
CREATE INDEX idx_fk_language_id ON film(language_id);
CREATE INDEX idx_fk_original_language_id ON film(original_language_id);

-- -----------------------------------------
-- film_actor / film_category
-- -----------------------------------------

CREATE TABLE film_actor (
  actor_id smallint NOT NULL,
  film_id smallint NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id, film_id),
  CONSTRAINT fk_film_actor_actor
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film
    FOREIGN KEY (film_id) REFERENCES film(film_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_film_id ON film_actor(film_id);

CREATE TABLE film_category (
  film_id smallint NOT NULL,
  category_id smallint NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film
    FOREIGN KEY (film_id) REFERENCES film(film_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category
    FOREIGN KEY (category_id) REFERENCES category(category_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -----------------------------------------
-- store / staff (cycle FK => FK added after)
-- -----------------------------------------

CREATE TABLE store (
  store_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  manager_staff_id smallint NOT NULL,
  address_id smallint NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_fk_address_id_store ON store(address_id);

ALTER TABLE store
  ADD CONSTRAINT fk_store_address
  FOREIGN KEY (address_id) REFERENCES address(address_id)
  ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE TABLE staff (
  staff_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  first_name varchar(45) NOT NULL,
  last_name varchar(45) NOT NULL,
  address_id smallint NOT NULL,
  picture bytea,
  email varchar(50),
  store_id smallint NOT NULL,
  active boolean NOT NULL DEFAULT true,
  username varchar(16) NOT NULL,
  password varchar(40),
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_staff_store
    FOREIGN KEY (store_id) REFERENCES store(store_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_staff_address
    FOREIGN KEY (address_id) REFERENCES address(address_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_store_id_staff ON staff(store_id);
CREATE INDEX idx_fk_address_id_staff ON staff(address_id);

ALTER TABLE store
  ADD CONSTRAINT fk_store_staff
  FOREIGN KEY (manager_staff_id) REFERENCES staff(staff_id)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE store
  ADD CONSTRAINT idx_unique_manager UNIQUE (manager_staff_id);

-- -----------------------------------------
-- customer
-- -----------------------------------------

CREATE TABLE customer (
  customer_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  store_id smallint NOT NULL,
  first_name varchar(45) NOT NULL,
  last_name varchar(45) NOT NULL,
  email varchar(50),
  address_id smallint NOT NULL,
  active boolean NOT NULL DEFAULT true,
  create_date timestamp NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_customer_address
    FOREIGN KEY (address_id) REFERENCES address(address_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_customer_store
    FOREIGN KEY (store_id) REFERENCES store(store_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_store_id_customer ON customer(store_id);
CREATE INDEX idx_fk_address_id_customer ON customer(address_id);
CREATE INDEX idx_last_name ON customer(last_name);

-- -----------------------------------------
-- inventory
-- -----------------------------------------

CREATE TABLE inventory (
  inventory_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  film_id smallint NOT NULL,
  store_id smallint NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_inventory_store
    FOREIGN KEY (store_id) REFERENCES store(store_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_inventory_film
    FOREIGN KEY (film_id) REFERENCES film(film_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_film_id_inventory ON inventory(film_id);
CREATE INDEX idx_store_id_film_id ON inventory(store_id, film_id);

-- -----------------------------------------
-- rental
-- -----------------------------------------

CREATE TABLE rental (
  rental_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  rental_date timestamp NOT NULL,
  inventory_id integer NOT NULL,
  customer_id smallint NOT NULL,
  return_date timestamp,
  staff_id smallint NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT uq_rental UNIQUE (rental_date, inventory_id, customer_id),

  CONSTRAINT fk_rental_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_rental_inventory
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_rental_customer
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_inventory_id ON rental(inventory_id);
CREATE INDEX idx_fk_customer_id ON rental(customer_id);
CREATE INDEX idx_fk_staff_id ON rental(staff_id);

-- -----------------------------------------
-- payment
-- -----------------------------------------

CREATE TABLE payment (
  payment_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id smallint NOT NULL,
  staff_id smallint NOT NULL,
  rental_id integer,
  amount numeric(5,2) NOT NULL,
  payment_date timestamp NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_payment_rental
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
    ON DELETE SET NULL ON UPDATE CASCADE,

  CONSTRAINT fk_payment_customer
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT fk_payment_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_fk_staff_id_payment ON payment(staff_id);
CREATE INDEX idx_fk_customer_id_payment ON payment(customer_id);

-- -----------------------------------------
-- film_text (optionnel)
-- Pas de trigger de synchro : tu peux le remplir après import.
-- -----------------------------------------

CREATE TABLE film_text (
  film_id smallint PRIMARY KEY,
  title varchar(255) NOT NULL,
  description text
);

-- Index full-text optionnel (si tu veux rechercher dans film_text)
-- (fonctionne même sans triggers, une fois film_text rempli)
ALTER TABLE film_text
  ADD COLUMN document tsvector GENERATED ALWAYS AS (
    to_tsvector('simple', coalesce(title,'') || ' ' || coalesce(description,''))
  ) STORED;

CREATE INDEX idx_film_text_document ON film_text USING GIN(document);
