-- Row count
SELECT approximate_row_count('es');
SELECT approximate_row_count('bz');

-- Time range for each trading pair
SELECT 'es' AS table_name, MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp FROM es
UNION
SELECT 'bz' AS table_name, MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp FROM bz;

-- Calculate Daily Average Volumes
SELECT
    time_bucket('1 day', timestamp) AS day,
    AVG(volume) AS avg_volume
FROM es
GROUP BY day
ORDER BY day;

-- Identify Days with Unusual Volume Spikes
SELECT
    time_bucket('1 day', timestamp) AS day,
    MAX(volume) AS max_volume
FROM es
GROUP BY day
HAVING MAX(volume) > (SELECT AVG(volume) * 2 FROM es);

-- Volume Comparison
SELECT
    time_bucket('1 hour', e.timestamp) AS hour,
    AVG(e.volume) AS es_avg_volume,
    AVG(b.volume) AS bz_avg_volume
FROM es e
JOIN bz b ON e.timestamp = b.timestamp
GROUP BY hour
ORDER BY hour;

-- Calculate Daily Average Percentage Change in Volume with Window Function
WITH volume_changes AS (
    SELECT
        timestamp,
        (volume - LAG(volume) OVER (ORDER BY timestamp)) / LAG(volume) OVER (ORDER BY timestamp) * 100 AS percentage_change
    FROM es
)
SELECT
    time_bucket('1 day', timestamp) AS day,
    AVG(percentage_change) AS avg_percentage_change
FROM volume_changes
GROUP BY day
ORDER BY day;
