USE DATABASE ANIME_DB;
USE SCHEMA MART;

CREATE OR REPLACE PROCEDURE SP_LOAD_FACT_ANIME_RANKINGS()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    INSERT INTO FACT_ANIME_RANKINGS (
        anime_key,
        ranking,
        snapshot_ts,
        ingest_id,
        created_at
    )
    SELECT
        d.anime_key,
        s.ranking,
        s.fetched_at       AS snapshot_ts,
        s.ingest_id,
        CURRENT_TIMESTAMP()
    FROM ANIME_DB.STAGING.STG_ANIME s
    JOIN MART.DIM_ANIME d
        ON s.anime_id = d.anime_id

    -- Avoid duplicate snapshots for same anime + timestamp
    WHERE NOT EXISTS (
        SELECT 1
        FROM MART.FACT_ANIME_RANKINGS f
        WHERE f.anime_key = d.anime_key
          AND f.snapshot_ts = s.fetched_at
    );

    RETURN 'FACT_ANIME_RANKINGS load completed successfully';

END;
$$;
