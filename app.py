import pandas as pd
import psycopg2
import os

# CSV file details
DATASET_FILE = 'shortjokes.csv'  # Path to your downloaded CSV file

# PostgreSQL connection details
DB_NAME = os.getenv('DB_NAME')  # Use a default value if not set
DB_USER = os.getenv('DB_USER')
DB_PASS = os.getenv('DB_PASS')
DB_HOST = os.getenv('DB_HOST')


# Load dataset into DataFrame
df = pd.read_csv(DATASET_FILE)

# Assuming your CSV has the appropriate columns, adjust as necessary.
# For example, if your CSV has different column names or additional preprocessing is needed.

# Connect to PostgreSQL Database
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASS,
    host=DB_HOST
)
conn.autocommit = True
cursor = conn.cursor()

# Create table (adjust according to your dataset structure)
try:
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS jokes (
            id SERIAL PRIMARY KEY,
            joke TEXT NOT NULL
        );
    """)
except psycopg2.Error as e:
    print(f"Error creating table: {e}")
    conn.rollback()

# Insert data into the table
# Ensure your CSV columns match. Adjust 'ID' and 'Joke' if your column names differ.
for _, row in df.iterrows():
    try:
        cursor.execute("INSERT INTO jokes (joke) VALUES (%s)", (row['Joke'],))
    except psycopg2.Error as e:
        print(f"Error inserting row: {e}")
        conn.rollback()

# Close connection
cursor.close()
conn.close()

print("Data imported successfully.")

try:
    # Connect to the PostgreSQL database
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST
    )
    cursor = conn.cursor()

    # Query to select all jokes
    cursor.execute("SELECT id, joke FROM jokes;")

    # Fetch all rows from the database
    jokes = cursor.fetchall()

    for joke in jokes:
        print(f"ID: {joke[0]}, Joke: {joke[1]}")

    # Close the cursor and the connection
    cursor.close()
    conn.close()

except psycopg2.Error as e:
    print(f"Error: {e}")

try:
    # Connect to the PostgreSQL database
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST
    )
    cursor = conn.cursor()

    # Query to select all jokes
    cursor.execute("SELECT id, joke FROM jokes;")

    # Fetch all rows from the database
    jokes = cursor.fetchall()

    for joke in jokes:
        print(f"ID: {joke[0]}, Joke: {joke[1]}")

    # Close the cursor and the connection
    cursor.close()
    conn.close()

except psycopg2.Error as e:
    print(f"Error: {e}")