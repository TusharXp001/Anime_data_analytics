USE DATABASE ANIME_DB ;
USE SCHEMA MART;

CREATE OR REPLACE PROCEDURE SP_LOAD_DIM_ANIME()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    MERGE INTO DIM_ANIME d
    USING (
        SELECT DISTINCT
            anime_id,
            episodes,
            status,
            type,
            synopsis
        FROM ANIME_DWH.STAGING.STG_ANIME
        WHERE anime_id IS NOT NULL
    ) s
    ON d.anime_id = s.anime_id

    WHEN MATCHED THEN
        UPDATE SET
            d.episodes   = s.episodes,
            d.status     = s.status,
            d.type       = s.type,
            d.synopsis   = s.synopsis,
            d.updated_at = CURRENT_TIMESTAMP()

    WHEN NOT MATCHED THEN
        INSERT (
            anime_id,
            episodes,
            status,
            type,
            synopsis,
            created_at,
            updated_at
        )
        VALUES (
            s.anime_id,
            s.episodes,
            s.status,
            s.type,
            s.synopsis,
            CURRENT_TIMESTAMP(),
            CURRENT_TIMESTAMP()
        );

    RETURN 'DIM_ANIME load completed successfully';

END;
$$;
