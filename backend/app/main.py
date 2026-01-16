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

@app.get("/compo_equipe/{id_equipe}")
def get_compo_equipe(id_equipe: int):
    conn = get_conn()
    cur = conn.cursor()
    query = """
        SELECT p.pseudo, p.pays
        FROM membre_equipe AS me
        INNER JOIN participant AS p
        	ON me.id_participant = p.id_participant
        WHERE me.id_equipe = %s
    """
    cur.execute(query, (id_equipe,))
    rows = cur.fetchall()
    cur.close()
    conn.close()
    
    return [{"pseudo": r[0], "pays": r[1]} for r in rows]



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
    joueurs: List[int] = Form(default=[])
):
    """
    Crée une équipe et lie des participants existants par leur ID.
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
        
        # 2. Liaison dans membre_equipe pour chaque ID reçu
        for id_p in joueurs:
            # Vérification de l'existence du joueur
            cur.execute("SELECT id_participant FROM participant WHERE id_participant = %s", (id_p,))
            if not cur.fetchone():
                raise Exception(f"Le joueur ID {id_p} n'existe pas.")

            # Insertion du lien
            cur.execute(
                "INSERT INTO membre_equipe (id_participant, id_equipe, id_saison) VALUES (%s, %s, %s)",
                (id_p, id_equipe, id_saison)
            )
            
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cur.close()
        conn.close()
    
    return {"message": "Equipe et participants liés avec succès", "id_equipe": id_equipe}
