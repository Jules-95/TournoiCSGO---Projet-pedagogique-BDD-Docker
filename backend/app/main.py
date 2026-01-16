import os
import psycopg2
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

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

@app.get("/ping")
def ping():
    return {"ok": True}

@app.get("/films")
def films():
    # Execution de la requête
    conn = get_conn()
    cur = conn.cursor()
    cur.execute('''
                SELECT title, description, length
                FROM film
                ORDER BY length DESC
                LIMIT 20
                ''')
    rows = cur.fetchall()
    cur.close()
    conn.close()
    
    # Envoi du résultat
    return [{"title": r[0], "description": r[1], "length": r[2]} for r in rows]
