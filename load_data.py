"""Load NYC taxi trip data and zone lookup data into Postgres."""

import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()
DATABASE_URL = os.environ["DATABASE_URL"]

engine = create_engine(DATABASE_URL)

trips_df = pd.read_parquet("data/yellow_tripdata_2024-01.parquet")
trips_df = trips_df[
    [
        "tpep_pickup_datetime",
        "tpep_dropoff_datetime",
        "PULocationID",
        "DOLocationID",
        "passenger_count",
        "trip_distance",
        "fare_amount",
        "tip_amount",
        "total_amount",
        "payment_type",
    ]
]
trips_df = trips_df.sample(n=100000, random_state=42)
trips_df.to_sql("trips", engine, if_exists="replace", index=False)
print("Loaded trips table")

zones_df = pd.read_csv("data/taxi_zone_lookup.csv")
zones_df.to_sql("taxi_zones", engine, if_exists="replace", index=False)
print("Loaded taxi_zones table")