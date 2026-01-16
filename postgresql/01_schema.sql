-- =========================================
-- Sakila (MySQL) -> PostgreSQL
-- =========================================
-- Script de création des tables pour un tournoi de jeux vidéo
-- =========================================

-- -----------------------------------------
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
    pays varchar(50)
);

CREATE INDEX idx_participant_pseudo ON participant(pseudo);

-- -----------------------------------------
-- Table saison
-- -----------------------------------------
CREATE TABLE saison (
    id_saison smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom_saison varchar(20) NOT NULL,
    date_debut date,
    date_fin date
);

-- -----------------------------------------
-- Table membre_equipe (relation Historique Joueur <-> Équipe <-> Saison)
-- -----------------------------------------
CREATE TABLE membre_equipe (
    id_participant smallint NOT NULL,
    id_equipe smallint NOT NULL,
    id_saison smallint NOT NULL,
    PRIMARY KEY (id_participant, id_equipe, id_saison),
    CONSTRAINT fk_membre_participant FOREIGN KEY (id_participant) REFERENCES participant(id_participant)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_membre_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_membre_saison FOREIGN KEY (id_saison) REFERENCES saison(id_saison)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- -----------------------------------------
-- Table matchs
-- -----------------------------------------
CREATE TABLE matchs (
    numero_match smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_heure timestamp NOT NULL,
    etat varchar(20) NOT NULL, -- Exemple : 'prévu', 'en cours', 'terminé'
    id_saison smallint,
    CONSTRAINT fk_match_saison FOREIGN KEY (id_saison) REFERENCES saison(id_saison)
        ON DELETE SET NULL ON UPDATE CASCADE
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
