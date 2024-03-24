from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import psycopg2
import os

# Initialize the FastAPI app
app = FastAPI()

# PostgreSQL connection details
DB_NAME = os.getenv('DB_NAME', 'default_db_name')
DB_USER = os.getenv('DB_USER', 'default_user')
DB_PASS = os.getenv('DB_PASS', 'default_password')
DB_HOST = os.getenv('DB_HOST', 'localhost')

class JokeResponse(BaseModel):
    joke: str

def check_database():
    try:
        conn = psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)
        conn.close()
        print("Database exists!")
    except psycopg2.OperationalError as e:
        raise HTTPException(status_code=500, detail=f"Error connecting to the database: {e}")

def check_jokes_table():
    try:
        conn = psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM jokes;")
        joke_count = cursor.fetchone()[0]
        if joke_count > 0:
            print(f"The 'jokes' table exists and has {joke_count} rows.")
        else:
            print("The 'jokes' table exists but is empty.")
        conn.close()
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Error checking the 'jokes' table: {e}")

def get_random_joke():
    with psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST) as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT joke FROM jokes ORDER BY RANDOM() LIMIT 1;")
            joke = cursor.fetchone()[0]
    return joke

@app.get("/joke", response_model=JokeResponse)
def joke():
    check_database()
    check_jokes_table()
    return {"joke": get_random_joke()}

# No need to specify if __name__ == '__main__': Uvicorn is used to run the app externally