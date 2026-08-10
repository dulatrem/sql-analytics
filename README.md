# NYC Taxi SQL Analytics

A focused SQL showcase built on real NYC taxi trip data, demonstrating intermediate SQL techniques — CTEs, window functions, subqueries, and self-joins. Each query is framed around a concrete business question rather than a syntax exercise.

## Dataset

- **Source:** NYC TLC Yellow Taxi Trip Records, January 2024
- **Trips table:** a random sample of 100,000 trips loaded into PostgreSQL
- **Zone lookup table:** the official TLC taxi zone lookup, mapping location IDs to boroughs and zone names
- Data is loaded into Postgres via [`load_data.py`](load_data.py), which reads the raw parquet/CSV files, samples the trips, and writes both tables to the database.

## Setup

1. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Create a `.env` file in the project root with your database connection string:
   ```
   DATABASE_URL=postgresql://user:password@host/dbname
   ```
4. Populate the database:
   ```bash
   python load_data.py
   ```

## Queries

### 1. Running daily revenue total — [`queries/01_running_total.sql`](queries/01_running_total.sql)
- **Business question:** How does cumulative taxi revenue build up over the month?
- **SQL concept:** CTE + window function (running total via `SUM() OVER`)
- **Sample insight:** Revenue accumulates steadily through January, with visible jumps on weekends when trip volume spikes.

### 2. Top 3 pickup zones per borough — [`queries/02_window_rank.sql`](queries/02_window_rank.sql)
- **Business question:** Within each borough, which pickup zones see the most trips?
- **SQL concept:** `RANK()` window function partitioned by borough, joined against the zone lookup table
- **Sample insight:** Manhattan's top zones are dominated by Midtown and airport-adjacent hubs, while outer boroughs show far more concentrated demand in just one or two zones.

### 3. Zones with above-average fares — [`queries/03_subquery_filter.sql`](queries/03_subquery_filter.sql)
- **Business question:** Which zones have a higher average fare than the citywide average?
- **SQL concept:** Scalar subquery used as a filter in `HAVING`
- **Sample insight:** Airport and outer-borough zones tend to clear the citywide average fare, reflecting longer average trip distances.

### 4. Day-over-day revenue change — [`queries/04_self_join.sql`](queries/04_self_join.sql)
- **Business question:** How does each day's revenue compare to the day before?
- **SQL concept:** Self-join (a table joined to itself on an offset date)
- **Sample insight:** Revenue dips sharply after New Year's Day, then swings noticeably around weekends as ridership patterns shift.

### 5. Zones with the most generous tippers — [`queries/05_highest_percentage_tips.sql`](queries/05_highest_percentage_tips.sql)
- **Business question:** Which pickup zones have the highest average tip percentage?
- **SQL concept:** Aggregation on a computed ratio, filtered for statistical significance (`HAVING COUNT(*) > 1000`)
- **Sample insight:** Higher average tip percentages cluster in a handful of zones with consistently high trip volume, rather than being driven by a few outlier trips.

## Tech stack

- **PostgreSQL** ([Neon](https://neon.tech)) — database
- **Python** (`pandas`, `SQLAlchemy`, `pyarrow`) — data loading
- **psql** — running and exploring queries
