import pandas as pd
from sqlalchemy import create_engine
import os

# PostgreSQL connection details
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASS = os.getenv('DB_PASS')
DB_HOST = os.getenv('DB_HOST')

# CSV file details
DATASET_FILE = 'shortjokes.csv'

# SQLAlchemy engine for pandas
engine = create_engine(f'postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}')

# Load dataset into DataFrame and insert into PostgreSQL
df = pd.read_csv(DATASET_FILE)
df.to_sql('jokes', engine, if_exists='replace', index_label='id', method='multi')

print("Data imported successfully.")