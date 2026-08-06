-- Query 1: Running daily revenue total for January 2024
-- Business question: How does cumulative taxi revenue build up over the month?
-- Concept: CTE + window function (running total)

WITH daily_revenue AS (
    SELECT
        DATE(tpep_pickup_datetime) AS trip_date,
        ROUND(SUM(total_amount)::numeric, 2) AS daily_total
    FROM trips
    WHERE tpep_pickup_datetime >= '2024-01-01'
      AND tpep_pickup_datetime <  '2024-02-01'
    GROUP BY DATE(tpep_pickup_datetime)
)
SELECT
    trip_date,
    daily_total,
    ROUND(SUM(daily_total) OVER (ORDER BY trip_date), 2) AS running_total
FROM daily_revenue
ORDER BY trip_date;