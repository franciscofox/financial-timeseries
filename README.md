# Financial Time Series Project
This repository contains the code and documentation for the problem on optimizing and scaling a financial time-series database.

## Contents

1. **Database Schema and Setup Documentation:**
   - `schema/`: Contains SQL scripts for setting up the database schema.
   - `Setup.pdf`: Documentation on setting up PostgreSQL and TimescaleDB, crucial for running the provided scripts.
   - `Requirements.txt`: File containing required Python packages for running the scripts.

2. **Data Ingestion and Querying:**
   - `ingestion.py`: Python script for ingesting data into the database.
   - `queries/`: SQL scripts with queries for extracting insights from the financial time-series data.
     - `crypto_queries.sql`: Queries specific to cryptocurrency data (`trades` table).
     - `tradfi_futures_queries.sql`: Queries specific to traditional financial futures data(`es` and `bz` tables).

3. **Data Analysis and Visualization:**
   - `data_analysis/`: Jupyter notebooks for data analysis and visualization.
     - `crypto_analysis.ipynb`: Notebook for analyzing cryptocurrency data.
     - `tradfi_futures_analysis.ipynb`: Notebook for analyzing traditional financial futures data.

4. **Optimization and Scaling:**
   - `Scaling Strategy.pdf`: A short report detailing optimization strategies and scaling considerations.

5. **Data Files:**
   - `data/data.zip`: Compressed file containing CSVs with the financial time-series data.
     - `bz.csv`: Data related to "bz."
     - `es.csv`: Data related to "es."
     - `trades.csv`: General trading data.

6. **Additional Files:**
   - `__pycache__/`: Cache directory generated by Python.
   - `README.md`: You are here!

## Getting Started

1. **Database Setup:**
   - Refer to `Setup.pdf` for instructions on setting up PostgreSQL and TimescaleDB.
   - Execute SQL scripts in `schema/` to create the necessary tables.

2. **Data Ingestion:**
   - Run `ingestion.py` to populate the database with data from the CSV files in `data/`.

3. **Run Queries:**
   - Utilize the SQL scripts in `queries/` to extract insights from the data.

4. **Data Analysis:**
   - Explore the provided Jupyter notebooks in `data_analysis/` for in-depth data analysis and visualization.

5. **Scaling Strategy Report:**
   - Read `Scaling Strategy.pdf` for insights into optimization and scaling strategies.

