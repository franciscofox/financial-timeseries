import psycopg2
import csv
import os
from dotenv import load_dotenv

load_dotenv()

def ingest_from_csv(csv_file_path, table_name, conn):
    """
    Read a CSV file and populate a PostgreSQL database table.

    Parameters:
    - csv_file_path: Path to the CSV file.
    - table_name: Name of the PostgreSQL table to populate.
    - conn: psycopg2 database connection.

    Assumes the CSV file has a header row with column names.
    """
    try:
        cursor = conn.cursor()

        # Open the CSV file and create a CSV reader
        with open(csv_file_path, 'r') as csv_file:
            csv_reader = csv.DictReader(csv_file)

            # Get column names from the CSV header
            columns = csv_reader.fieldnames

            # Create the COPY command to copy data from CSV to the database table
            copy_command = f"COPY {table_name} ({', '.join(columns)}) FROM STDIN WITH CSV HEADER"

            # Execute the COPY command
            cursor.copy_expert(sql=copy_command, file=csv_file)

        # Commit the changes to the database
        conn.commit()
        print(f"Data from {csv_file_path} successfully imported into {table_name} table.")

    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")

    finally:
        cursor.close()


connection = psycopg2.connect(host=os.getenv('DB_HOST'), port=os.getenv('DB_PORT'), database=os.getenv('DB_NAME'), user=os.getenv('DB_USER'), password=os.getenv('DB_PASS'))
ingest_from_csv('data/bz.csv', 'bz', connection)
ingest_from_csv('data/es.csv', 'es', connection)
ingest_from_csv('data/trades.csv', 'trades', connection)
connection.close()

