-- =========================================
-- Sakila (MySQL) -> PostgreSQL
-- =========================================
-- Script de création des tables pour un tournoi de jeux vidéo
-- =========================================
-- Table équipe
-- -----------------------------------------
CREATE TABLE equipe (
    id_equipe smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom_equipe varchar(50) NOT NULL
);

-- -----------------------------------------
-- Table participant
-- -----------------------------------------
CREATE TABLE participant (
    id_participant smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pseudo varchar(50) NOT NULL,
    date_naissance date NOT NULL,
    email varchar(100),
    pays varchar(50),
    id_equipe smallint NOT NULL,
    CONSTRAINT fk_participant_equipe
        FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_participant_pseudo ON participant(pseudo);

-- -----------------------------------------
-- Table matchs
-- -----------------------------------------
CREATE TABLE matchs (
    numero_match smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_heure timestamp NOT NULL,
    etat varchar(20) NOT NULL -- Exemple : 'prévu', 'en cours', 'terminé'
);

-- -----------------------------------------
-- Table match_equipe (relation match <-> équipe)
-- -----------------------------------------
CREATE TABLE match_equipe (
    numero_match smallint NOT NULL,
    id_equipe smallint NOT NULL,
    score integer DEFAULT 0,
    PRIMARY KEY (numero_match, id_equipe),
    CONSTRAINT fk_match FOREIGN KEY (numero_match) REFERENCES matchs(numero_match)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_match_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- -----------------------------------------
-- Exemple d'insertions (facultatif)
-- -----------------------------------------
-- Équipes
INSERT INTO equipe (nom_equipe) VALUES 
('Les Tigres'), 
('Les Aigles'), 
('Les Dragons');

-- Participants
INSERT INTO participant (pseudo, date_naissance, email, pays, id_equipe) VALUES
('Alice', '2000-05-12', 'alice@mail.com', 'France', 1),
('Bob', '1998-11-23', 'bob@mail.com', 'Allemagne', 1),
('Charlie', '2001-03-05', 'charlie@mail.com', 'Espagne', 2),
('David', '1999-07-19', 'david@mail.com', 'Italie', 2),
('Eve', '2000-12-01', 'eve@mail.com', 'France', 3);

-- Matchs
INSERT INTO matchs (date_heure, etat) VALUES
('2026-01-20 15:00', 'prévu'),
('2026-01-21 18:30', 'prévu');

-- Match <-> Équipes
INSERT INTO match_equipe (numero_match, id_equipe, score) VALUES
(1, 1, 0),
(1, 2, 0),
(2, 2, 0),
(2, 3, 0);