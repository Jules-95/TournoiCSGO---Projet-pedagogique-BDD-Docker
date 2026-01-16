import os
import psycopg2
from fastapi import FastAPI

app = FastAPI()

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
