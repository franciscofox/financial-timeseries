CREATE TABLE bz (
    timestamp TIMESTAMPTZ PRIMARY KEY,
    close NUMERIC,
    volume NUMERIC
);

-- Create hypertable to enhance query performance of time-series data
SELECT create_hypertable('bz', 'timestamp', migrate_data => true);