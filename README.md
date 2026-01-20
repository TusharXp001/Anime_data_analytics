# Anime Data Warehouse & Analytics Platform

An end-to-end **Data Engineering project** that ingests anime ranking data from RapidAPI, processes semi‑structured JSON in Snowflake, transforms data using dbt, models a dimensional warehouse using Snowflake Stored Procedures, and visualizes insights in Power BI.

This project demonstrates real‑world ELT architecture, CI/CD‑style deployments, and production‑grade warehouse design.

---

## 🚀 Architecture Overview

```
RapidAPI (anime-db)
        |
        v
Python Ingestion (API → JSON)
        |
        v
Snowflake RAW layer (VARIANT)
        |
        v
STAGING layer (dbt transformations)
        |
        v
MART layer (Facts & Dimensions via Snowflake Stored Procedures)
        |
        v
Power BI Dashboards
```

Deployment flow:

```
Local SQL → GitHub → Workflow → Snowflake
```

---

## 🧱 Data Warehouse Layers

### RAW

* Stores full API JSON response in `VARIANT`
* Batch tracking using `ingest_id` and `fetched_at`

### STAGING (dbt)

* Flattens JSON
* Normalizes genre arrays
* Tables:

  * `STG_ANIME`
  * `STG_ANIME_GENRES`

### MART (Analytics Layer)

Dimensional star schema built using Snowflake SQL Stored Procedures:

**Dimensions**

* `DIM_ANIME`
* `DIM_GENRE`

**Fact**

* `FACT_ANIME_RANKINGS`

---

## 🛠 Tech Stack

| Layer           | Technology                          |
| --------------- | ----------------------------------- |
| API Source      | RapidAPI (anime-db)                 |
| Ingestion       | Python, Requests                    |
| Data Warehouse  | Snowflake                           |
| Transformations | dbt Cloud                           |
| Modeling        | Snowflake SQL Stored Procedures     |
| Orchestration   | Stored Procedure Pipeline           |
| BI              | Power BI                            |
| Version Control | GitHub                              |
| CI/CD           | Workflow‑based Snowflake deployment |

---

## 📦 Data Sources

### Primary

* RapidAPI – Anime DB endpoint

Fields used:

* id
* episodes
* ranking
* status
* type
* synopsis
* genres (array)

### Future extensions

* Jikan API (metadata & popularity)
* Static CSV datasets

---

## 📐 Warehouse Schema

### DIM_ANIME

| Column         |
| -------------- |
| anime_key (PK) |
| anime_id       |
| episodes       |
| status         |
| type           |
| synopsis       |
| created_at     |
| updated_at     |

### DIM_GENRE

| Column         |
| -------------- |
| genre_key (PK) |
| genre_name     |
| created_at     |

### FACT_ANIME_RANKINGS

| Column         |
| -------------- |
| anime_key (FK) |
| ranking        |
| snapshot_ts    |
| ingest_id      |
| created_at     |

---

## ⚙️ Stored Procedures

| Procedure                     | Purpose                        |
| ----------------------------- | ------------------------------ |
| `SP_LOAD_DIM_ANIME`           | Loads/updates anime dimension  |
| `SP_LOAD_DIM_GENRE`           | Loads genre dimension          |
| `SP_LOAD_FACT_ANIME_RANKINGS` | Inserts ranking snapshots      |
| `SP_RUN_MART_PIPELINE`        | Orchestrates full MART refresh |

Run full pipeline:

```sql
CALL MART.SP_RUN_MART_PIPELINE();
```

---

## 📊 Power BI Dashboards

Features:

* Total anime count
* Average & best ranking KPIs
* Top 10 anime by ranking
* Ranking trends over time
* Status & type distribution

Star schema modeling used for performance & scalability.

---

## 🗂 Project Structure

```
anime-data-analytics/
│
├── ingestion/
│   └── rapidapi/
│       └── rapidapi_anime_ingest.py
│
├── snowflake/
│   └── scripts/
│       ├── database & schema setup
│       ├── RAW table creation
│       ├── MART table creation
│       ├── stored procedures
│
├── dbt/
│   └── models/
│       ├── sources/
│       ├── staging/
│       └── marts/
│
├── powerbi/
│   └── anime_dashboard.pbix
│
├── config/
│   └── .env (ignored)
│
└── README.md
```

---

## ▶️ How to Run

### 1. Environment variables

Create `config/.env`:

```
RAPIDAPI_KEY=...
SNOWFLAKE_USER=...
SNOWFLAKE_PASSWORD=...
SNOWFLAKE_ACCOUNT=...
```

### 2. Run ingestion

```bash
python ingestion/rapidapi/rapidapi_anime_ingest.py
```

### 3. Run dbt

```bash
dbt run
dbt test
```

### 4. Run warehouse pipeline

```sql
CALL MART.SP_RUN_MART_PIPELINE();
```

### 5. Open Power BI

Load tables from:

```
ANIME_DWH.MART
```

---

## 🧪 Key Engineering Concepts Demonstrated

* API pagination & batching
* Semi‑structured JSON ingestion
* ELT architecture
* dbt transformations
* Dimensional modeling (Star Schema)
* SCD Type‑1 dimensions
* Incremental fact loading
* Warehouse‑side orchestration
* CI/CD for Snowflake SQL
* BI modeling

---

## 📈 Resume Highlights

* Built an API‑driven ELT pipeline using Snowflake, dbt Cloud, Python, and Power BI
* Designed RAW → STAGING → MART architecture with semi‑structured JSON handling
* Implemented dimensional modeling with Snowflake SQL stored procedures
* Developed orchestration procedure to automate warehouse refresh
* Created analytical dashboards for ranking trend analysis

---

## 🔮 Future Enhancements

* Integrate Jikan API for popularity & studio metadata
* Add static datasets for ratings history
* Implement SCD Type‑2 for dimensions
* Add task scheduling in Snowflake
* Deploy dashboards to Power BI Service

---

## 👤 Author

Tushar Negi
Data Engineer (ETL → Data Engineering Transition Project)

---

⭐ If you found this project useful, consider starring the repository!
