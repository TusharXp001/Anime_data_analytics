{{ config(materialized='table') }}

SELECT
    response:id::string                                     AS anime_id,
    response:episodes::int                                  AS episodes,
    COALESCE(response:ranking::int, response:rank::int)     AS ranking,
    response:status::string                                 AS status,
    response:type::string                                   AS type,
    response:synopsis::string                               AS synopsis,

    ingest_id,
    fetched_at

FROM {{ source('raw', 'raw_anime') }}
