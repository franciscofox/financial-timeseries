-- Row count
SELECT approximate_row_count('trades');

-- Time range for each trading pair
SELECT  symbol, 
        MIN(timestamp), 
        MAX(timestamp) 
FROM trades
GROUP BY symbol;

-- Top average trading volumes of the last quarter
WITH volume_averages AS (
    SELECT
        symbol,
        AVG(volume) AS average_trading_volume
    FROM
        trades
    WHERE
        timestamp >= NOW() - INTERVAL '3 months'
    GROUP BY
        symbol
)

SELECT 
    symbol,
    average_trading_volume
FROM
    volume_averages
ORDER BY
    average_trading_volume DESC
LIMIT 10;

-- Total trading volume per year for BTC_USD trading pair
SELECT
    time_bucket('1 year', timestamp) AS bucket_time,
    SUM(volume) AS total_trading_volume
FROM trades
WHERE symbol = 'BTC_USD'
GROUP BY bucket_time
ORDER BY bucket_time;

-- Average volume change per hour for each one-month time bucket within the specified trading pair (BTC_USD)
WITH lagged_close AS (
    SELECT
        timestamp,
        close,
        LAG(close) OVER w AS lagged_close
    FROM trades
    WHERE symbol = 'BTC_USD'
    WINDOW w AS (ORDER BY timestamp)
)

SELECT
    time_bucket('1 month', timestamp) AS bucket_time,
    AVG(
        CASE
            WHEN lagged_close IS NULL THEN NULL
            ELSE close - lagged_close
        END
    ) / (extract(epoch from max(timestamp) - min(timestamp)) /3600) AS "average_hourly_close_change"
FROM lagged_close
GROUP BY bucket_time
ORDER BY bucket_time;


-----------------------------------------
--------- CONTINUOUS AGGREGATES ---------
-----------------------------------------

-- Continuous aggregate for daily HLCV
CREATE MATERIALIZED VIEW trades_hlcv_daily
WITH (timescaledb.continuous) AS
SELECT  symbol, 
        time_bucket('1 day', timestamp) AS bucket, 
        MAX(high) AS high, 
        MIN(low) AS low, 
        LAST(close, timestamp) AS close, 
        SUM(volume) AS volume
FROM trades
GROUP BY bucket, symbol
WITH NO DATA;

-- Query continuous aggregate
SELECT * FROM trades_hlcv_daily;

-- Refresh materialized view
CALL refresh_continuous_aggregate('trades_hlcv_daily', INTERVAL '2 years', INTERVAL '15 min');

-- View information about continuous aggregate
SELECT * FROM timescaledb_information.continuous_aggregates
WHERE view_name = 'trades_hlcv_daily';

-- Analyse optimization
EXPLAIN (ANALYSE, BUFFERS) SELECT * FROM trades_hlcv_daily;

EXPLAIN (ANALYSE, BUFFERS) 
SELECT  symbol, 
        time_bucket('1 day', timestamp) AS bucket, 
        MAX(high) AS high, 
        MIN(low) AS low, 
        LAST(close, timestamp) AS close,
        SUM(volume) AS volume
FROM trades
GROUP BY bucket, symbol;

-- Add automatic refresh policy
SELECT add_continuous_aggregate_policy( 'trades_hlcv_daily', 
                                        start_offset => INTERVAL '1 day',
                                        end_offset => INTERVAL '1 minute',
                                        schedule_interval => INTERVAL '1 day'
                                        );