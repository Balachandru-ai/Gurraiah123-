from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from database import engine

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def home():
    return {"message": "FastAPI Backend Running"}

@app.get("/api/users")
def get_users():
    connection = engine.connect()

    query = text("SELECT * FROM users")
    result = connection.execute(query)

    users = []

    for row in result:
        users.append({
            "id": row.id,
            "name": row.name,
            "email": row.email,
            "department": row.department,
            "created_at": str(row.created_at)
        })

    connection.close()

    return users
