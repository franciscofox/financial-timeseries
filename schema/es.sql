CREATE TABLE es (
    timestamp TIMESTAMPTZ PRIMARY KEY,
    close NUMERIC,
    volume NUMERIC
);

-- Create hypertable to enhance query performance of time-series data
SELECT create_hypertable('es', 'timestamp', migrate_data => true);