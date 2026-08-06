-- Query 2: Top 3 pickup zones per borough by trip count
-- Business question: Within each borough, which pickup zones see the most trips?
-- Concept: Window function (RANK) with PARTITION BY, plus a JOIN

WITH zone_counts AS (
    SELECT
        z."Borough" AS borough,
        z."Zone" AS zone,
        COUNT(*) AS trip_count
    FROM trips t
    JOIN taxi_zones z ON t."PULocationID" = z."LocationID"
    GROUP BY z."Borough", z."Zone"
),
ranked AS (
    SELECT
        borough,
        zone,
        trip_count,
        RANK() OVER (PARTITION BY borough ORDER BY trip_count DESC) AS zone_rank
    FROM zone_counts
)
SELECT borough, zone, trip_count, zone_rank
FROM ranked
WHERE zone_rank <= 3
ORDER BY borough, zone_rank;