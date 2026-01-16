-- 1. On vide les tables pour repartir à zéro
TRUNCATE match_equipe, membre_equipe, participant, saison, matchs, equipe RESTART IDENTITY CASCADE;

-- 2. Insertion des saisons
INSERT INTO saison (nom_saison, date_debut, date_fin) VALUES
('Saison 2024', '2024-01-01', '2024-12-31'),
('Saison 2025', '2025-01-01', '2025-12-31'),
('Saison 2026', '2026-01-01', '2026-12-31');

-- 3. Insertion des équipes
INSERT INTO equipe (nom_equipe) VALUES 
('Team Vitality'),    -- ID 1
('Natus Vincere'),    -- ID 2
('G2 Esports'),       -- ID 3
('FaZe Clan'),        -- ID 4
('Astralis'),         -- ID 5
('Team Spirit'),      -- ID 6
('MOUZ'),             -- ID 7
('Virtus.pro');      -- ID 8

-- 4. Insertion des participants
INSERT INTO participant (pseudo, date_naissance, email, pays) VALUES
-- Team Vitality
('ZywOo', '2000-11-09', 'zywoo@vitality.gg', 'France'),
('apEX', '1993-02-22', 'apex@vitality.gg', 'France'),
('flameZ', '2003-06-22', 'flamez@vitality.gg', 'Israël'),
('Spinx', '2000-09-13', 'spinx@vitality.gg', 'Israël'),
('mezii', '1998-10-15', 'mezii@vitality.gg', 'Royaume-Uni'),
-- Natus Vincere
('Aleksib', '1997-03-30', 'aleksib@navi.gg', 'Finlande'),
('iM', '1999-07-29', 'im@navi.gg', 'Roumanie'),
('b1t', '2003-01-05', 'b1t@navi.gg', 'Ukraine'),
('jL', '1999-09-29', 'jl@navi.gg', 'Lituanie'),
('wonderful', '2004-12-14', 'wonderful@navi.gg', 'Ukraine'),
-- G2 Esports
('NiKo', '1997-02-16', 'niko@g2.gg', 'Bosnie-Herzégovine'),
('huNter-', '1996-01-03', 'hunter@g2.gg', 'Bosnie-Herzégovine'),
('m0NESY', '2005-05-01', 'm0nesy@g2.gg', 'Russie'),
('Snax', '1993-07-05', 'snax@g2.gg', 'Pologne'),
('malbsMd', '2002-12-14', 'malbs@g2.gg', 'Guatemala'),
-- FaZe Clan
('karrigan', '1990-04-14', 'karrigan@faze.gg', 'Danemark'),
('rain', '1994-08-27', 'rain@faze.gg', 'Norvège'),
('ropz', '1999-12-22', 'ropz@faze.gg', 'Estonie'),
('broky', '2001-02-14', 'broky@faze.gg', 'Lettonie'),
('frozen', '2002-06-18', 'frozen@faze.gg', 'Slovaquie'),
-- Team Spirit
('chopper', '1997-02-03', 'chopper@spirit.gg', 'Russie'),
('shalfey', '2002-08-14', 'shalfey@spirit.gg', 'Russie'),
('donk', '2007-01-25', 'donk@spirit.gg', 'Russie'),
('zont1x', '2005-07-22', 'zont1x@spirit.gg', 'Ukraine'),
('magixx', '2003-03-03', 'magixx@spirit.gg', 'Russie');

-- 5. Insertion des membres d'équipe (Saison 2026 - ID 3)
INSERT INTO membre_equipe (id_participant, id_equipe, id_saison) VALUES
(1, 1, 3), (2, 1, 3), (3, 1, 3), (4, 1, 3), (5, 1, 3), -- Vitality
(6, 2, 3), (7, 2, 3), (8, 2, 3), (9, 2, 3), (10, 2, 3), -- NaVi
(11, 3, 3), (12, 3, 3), (13, 3, 3), (14, 3, 3), (15, 3, 3), -- G2
(16, 4, 3), (17, 4, 3), (18, 4, 3), (19, 4, 3), (20, 4, 3), -- FaZe
(21, 6, 3), (22, 6, 3), (23, 6, 3), (24, 6, 3), (25, 6, 3); -- Spirit

-- 6. Insertion des matchs (liés à la Saison 2026 - ID 3)
INSERT INTO matchs (date_heure, etat, id_saison) VALUES
('2026-02-15 14:00:00', 'prévu', 3), -- Match 1: Vitality vs NaVi
('2026-02-15 17:00:00', 'prévu', 3), -- Match 2: G2 vs FaZe
('2026-02-15 20:00:00', 'prévu', 3), -- Match 3: Spirit vs Astralis
('2026-02-16 14:00:00', 'prévu', 3), -- Match 4: MOUZ vs Virtus.pro
('2026-02-16 17:00:00', 'prévu', 3), -- Match 5: Perdant M1 vs Perdant M2
('2026-02-16 20:00:00', 'prévu', 3); -- Match 6: Gagnant M1 vs Gagnant M2

-- 7. Liaison matchs <-> équipes
INSERT INTO match_equipe (numero_match, id_equipe, score) VALUES
(1, 1, 0), (1, 2, 0), -- Match 1
(2, 3, 0), (2, 4, 0), -- Match 2
(3, 6, 0), (3, 5, 0), -- Match 3
(4, 7, 0), (4, 8, 0); -- Match 4