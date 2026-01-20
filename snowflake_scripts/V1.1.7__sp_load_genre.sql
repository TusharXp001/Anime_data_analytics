USE DATABASE ANIME_DB;
USE SCHEMA MART;

CREATE OR REPLACE PROCEDURE SP_LOAD_DIM_GENRE()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    MERGE INTO DIM_GENRE d
    USING (
        SELECT DISTINCT
            TRIM(genre) AS genre_name
        FROM ANIME_DB.STAGING.STG_ANIME_GENRES
        WHERE genre IS NOT NULL
    ) s
    ON d.genre_name = s.genre_name

    WHEN NOT MATCHED THEN
        INSERT (
            genre_name,
            created_at
        )
        VALUES (
            s.genre_name,
            CURRENT_TIMESTAMP()
        );

    RETURN 'DIM_GENRE load completed successfully';

END;
$$;
