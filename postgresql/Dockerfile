FROM postgres:16-alpine

# Optionnel mais utile: fixer un encodage/locale cohérent
ENV LANG=C.UTF-8

# Les scripts dans ce dossier sont exécutés AU PREMIER démarrage
# (quand le volume de données est vide)
COPY 01_schema.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY 02_seed.sql   /docker-entrypoint-initdb.d/02_seed.sql
