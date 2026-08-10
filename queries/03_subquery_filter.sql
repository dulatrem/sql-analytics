-- Query 3: Pickup zones with above-average fares
-- Business question: Which zones have a higher average fare than the citywide average?
-- Concept: Subquery filtering by an aggregated value

SELECT
    z."Borough" AS borough,
    z."Zone" AS zone,
    ROUND(AVG(t.fare_amount)::numeric, 2) AS avg_fare
FROM trips t
JOIN taxi_zones z ON t."PULocationID" = z."LocationID"
GROUP BY z."Borough", z."Zone"
HAVING AVG(t.fare_amount) > (
    SELECT AVG(fare_amount) FROM trips
)
ORDER BY avg_fare DESC;