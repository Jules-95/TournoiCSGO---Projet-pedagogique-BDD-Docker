-- 1. On vide les tables pour repartir à zéro (optionnel mais propre)
TRUNCATE match_equipe, participant, matchs, equipe RESTART IDENTITY CASCADE;

-- 2. Insertion des équipes
INSERT INTO equipe (nom_equipe) VALUES 
('Team Vitality'), 
('Natus Vincere'), 
('G2 Esports'), 
('FaZe Clan');

-- 3. Insertion des participants (en supposant que Vitality a l'ID 1, NaVi le 2, etc.)
INSERT INTO participant (pseudo, date_naissance, email, pays, id_equipe) VALUES
('ZywOo', '2000-11-09', 'zywoo@vitality.gg', 'France', 1),
('apEX', '1993-02-22', 'apex@vitality.gg', 'France', 1),
('s1mple', '1997-10-02', 's1mple@navi.gg', 'Ukraine', 2);

-- 4. Insertion des matchs
INSERT INTO matchs (date_heure, etat) VALUES
('2026-02-15 20:00:00', 'prévu'),
('2026-02-15 22:30:00', 'prévu');

-- 5. Liaison matchs <-> équipes
INSERT INTO match_equipe (numero_match, id_equipe, score) VALUES
(1, 1, 0), -- Match 1 : Vitality
(1, 2, 0), -- Match 1 : NaVi
(2, 3, 0), -- Match 2 : G2
(2, 4, 0); -- Match 2 : FaZe