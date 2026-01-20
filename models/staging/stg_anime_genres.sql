{{ config(materialized='table') }}

SELECT
    r.response:id::string       AS anime_id,
    g.value::string             AS genre,

    r.ingest_id,
    r.fetched_at

FROM {{ source('raw', 'raw_anime') }} r,
     LATERAL FLATTEN(input => r.response:genres) g
