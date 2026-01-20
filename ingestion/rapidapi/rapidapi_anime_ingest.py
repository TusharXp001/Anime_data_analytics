from pathlib import Path
from dotenv import load_dotenv
import os
import requests
import snowflake.connector
import uuid
import time
from datetime import datetime, timezone
import json

# =========================
# Load environment variables
# =========================

BASE_DIR = Path(__file__).resolve().parents[2]
ENV_PATH = BASE_DIR / "config" / ".env"

load_dotenv(ENV_PATH)

print("DEBUG -> SNOWFLAKE_ACCOUNT =", os.getenv("SNOWFLAKE_ACCOUNT"))

# =========================
# Config
# =========================

RAPIDAPI_KEY = os.getenv("RAPIDAPI_KEY")

API_URL = "https://anime-db.p.rapidapi.com/anime"

HEADERS = {
    "X-RapidAPI-Key": RAPIDAPI_KEY,
    "X-RapidAPI-Host": "anime-db.p.rapidapi.com"
}

PAGE_SIZE = 50
MAX_PAGES = 5   # increase later

# =========================
# Snowflake connection
# =========================

def get_snowflake_conn():
    return snowflake.connector.connect(
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        warehouse="ANIME_WH",
        database="ANIME_DB",
        schema="RAW",
        role="ACCOUNTADMIN"
    )

# =========================
# API fetch
# =========================

def fetch_page(page: int):
    params = {
        "page": page,
        "size": PAGE_SIZE
    }
    response = requests.get(API_URL, headers=HEADERS, params=params, timeout=30)
    response.raise_for_status()
    return response.json()

# =========================
# Main ingestion logic
# =========================

def main():
    ingest_id = str(uuid.uuid4())
    fetched_at = datetime.now(timezone.utc)

    print(f"Starting ingestion batch: {ingest_id}")

    conn = get_snowflake_conn()
    cur = conn.cursor()

    total_rows = 0

    try:
        for page in range(1, MAX_PAGES + 1):
            print(f"Fetching page {page}")

            payload = fetch_page(page)
            anime_list = payload.get("data", [])

            if not anime_list:
                print("No more data returned from API.")
                break

            for anime in anime_list:
                cur.execute(
                    """
                    INSERT INTO RAW_ANIME
                    (INGEST_ID, FETCHED_AT, PAGE, SIZE, RESPONSE)
                    SELECT %s, %s, %s, %s, PARSE_JSON(%s)
                    """,
                    (
                        ingest_id,
                        fetched_at,
                        page,
                        PAGE_SIZE,
                        json.dumps(anime, ensure_ascii=False)
                    )
                )
                total_rows += 1

            conn.commit()
            time.sleep(1)  # rate-limit safety

    finally:
        cur.close()
        conn.close()

    print(f"Ingestion completed. Rows inserted: {total_rows}")

# =========================
# Entry point
# =========================

if __name__ == "__main__":
    main()
