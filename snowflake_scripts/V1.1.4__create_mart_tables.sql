USE DATABASE ANIME_DWH;
USE SCHEMA MART;

-- =========================
-- DIM_ANIME
-- =========================

CREATE TABLE IF NOT EXISTS DIM_ANIME (
    anime_key   NUMBER AUTOINCREMENT PRIMARY KEY,
    anime_id    STRING NOT NULL,
    episodes    INTEGER,
    status      STRING,
    type        STRING,
    synopsis    STRING,

    created_at  TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at  TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),

    CONSTRAINT uq_dim_anime_anime_id UNIQUE (anime_id)
);

-- =========================
-- DIM_GENRE
-- =========================

CREATE TABLE IF NOT EXISTS DIM_GENRE (
    genre_key   NUMBER AUTOINCREMENT PRIMARY KEY,
    genre_name  STRING NOT NULL,

    created_at  TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),

    CONSTRAINT uq_dim_genre_name UNIQUE (genre_name)
);

-- =========================
-- FACT_ANIME_RANKINGS
-- =========================

CREATE TABLE IF NOT EXISTS FACT_ANIME_RANKINGS (
    anime_key    NUMBER NOT NULL,
    ranking      INTEGER,
    snapshot_ts  TIMESTAMP_LTZ NOT NULL,
    ingest_id    STRING,

    created_at   TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),

    CONSTRAINT fk_fact_anime
        FOREIGN KEY (anime_key) REFERENCES DIM_ANIME(anime_key)
);