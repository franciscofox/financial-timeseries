-- Create trades table 
CREATE TABLE trades (
    timestamp TIMESTAMPTZ,
    symbol VARCHAR(10),
    high NUMERIC,
    low NUMERIC,
    close NUMERIC,
    volume NUMERIC
);

-- Create hypertables to enhance query performance of time-series data
SELECT create_hypertable('trades', 'timestamp', migrate_data => true);

-- Create additional index on specific columns based on your query patterns
CREATE INDEX symbol_idx ON trades (symbol);