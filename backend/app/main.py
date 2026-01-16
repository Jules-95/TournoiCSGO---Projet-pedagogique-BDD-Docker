import os
import psycopg2
from typing import Optional, List
from fastapi import FastAPI, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="CSGO Tournament API")

# --- Connexion BDD ---

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En production, spécifiez les origines autorisées
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_conn():
    return psycopg2.connect(
        host="pg-sandbox",
        port=5432,
        dbname="appdb",
        user="appuser",
        password="apppass"
    )

# --- Endpoints ---

@app.get("/ping")
def ping():
    return {"ok": True}

@app.get("/equipes")
def get_equipes():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT id_equipe, nom_equipe FROM equipe ORDER BY nom_equipe")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [{"id_equipe": r[0], "nom_equipe": r[1]} for r in rows]

@app.get("/participants")
def get_participants():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT id_participant, pseudo, date_naissance, email, pays FROM participant")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [
        {
            "id_participant": r[0], 
            "pseudo": r[1], 
            "date_naissance": r[2], 
            "email": r[3], 
            "pays": r[4]
        } for r in rows
    ]

@app.get("/matchs")
def get_matchs():
    conn = get_conn()
    cur = conn.cursor()
    query = """
        SELECT m.numero_match, m.date_heure, m.etat, e.nom_equipe, me.score
        FROM matchs m
        JOIN match_equipe me ON m.numero_match = me.numero_match
        JOIN equipe e ON me.id_equipe = e.id_equipe
        ORDER BY m.date_heure
    """
    cur.execute(query)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    
    matchs_dict = {}
    for r in rows:
        num = r[0]
        if num not in matchs_dict:
            matchs_dict[num] = {
                "numero_match": num,
                "date_heure": r[1],
                "etat": r[2],
                "equipes": []
            }
        matchs_dict[num]["equipes"].append({"nom": r[3], "score": r[4]})
    
    return list(matchs_dict.values())

# --- Gestion des Participants par Formulaire ---

@app.post("/participants")
def add_participant(
    pseudo: str = Form(...),
    date_naissance: str = Form(...),
    email: Optional[str] = Form(None),
    pays: Optional[str] = Form(None)
):
    """
    Enregistre un participant en utilisant des paramètres Form.
    """
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO participant (pseudo, date_naissance, email, pays) VALUES (%s, %s, %s, %s) RETURNING id_participant",
            (pseudo, date_naissance, email, pays)
        )
        new_id = cur.fetchone()[0]
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cur.close()
        conn.close()
        
    return {"message": "Participant ajouté", "id": new_id}

@app.post("/equipes")
def add_equipe(
    nom_equipe: str = Form(...),
    participants: List[str] = Form(default=[])
):
    """
    Crée une équipe et lie éventuellement des participants (créés à la volée si besoin).
    """
    conn = get_conn()
    cur = conn.cursor()
    try:
        # 1. Insertion de l'équipe
        cur.execute(
            "INSERT INTO equipe (nom_equipe) VALUES (%s) RETURNING id_equipe",
            (nom_equipe,)
        )
        id_equipe = cur.fetchone()[0]
        
        # Saison 2026 par défaut (ID 3 dans notre seed)
        id_saison = 3
        
        # 2. Traitement des participants
        for pseudo in participants:
            if not pseudo.strip():
                continue
                
            # Vérifier si le participant existe
            cur.execute("SELECT id_participant FROM participant WHERE pseudo = %s", (pseudo,))
            row = cur.fetchone()
            
            if row:
                id_participant = row[0]
            else:
                # Création simplifiée si inexistant
                cur.execute(
                    "INSERT INTO participant (pseudo, date_naissance) VALUES (%s, '2000-01-01') RETURNING id_participant",
                    (pseudo,)
                )
                id_participant = cur.fetchone()[0]
            
            # 3. Liaison dans membre_equipe
            cur.execute(
                "INSERT INTO membre_equipe (id_participant, id_equipe, id_saison) VALUES (%s, %s, %s)",
                (id_participant, id_equipe, id_saison)
            )
            
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cur.close()
        conn.close()
    
    return {"message": "Equipe et participants créés/liés avec succès", "id_equipe": id_equipe}
