-- Query 4: Day-over-day revenue change
-- Business question: How does each day's revenue compare to the day before?
-- Concept: Self-join (a table joined to itself)

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
    today.trip_date,
    today.daily_total,
    yesterday.daily_total AS previous_day_total,
    ROUND(today.daily_total - yesterday.daily_total, 2) AS change
FROM daily_revenue today
JOIN daily_revenue yesterday
    ON today.trip_date = yesterday.trip_date + INTERVAL '1 day'
ORDER BY today.trip_date;