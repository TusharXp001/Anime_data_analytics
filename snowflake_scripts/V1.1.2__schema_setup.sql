USE DATABASE ANIME_DWH;

CREATE SCHEMA IF NOT EXISTS RAW
COMMENT = 'Raw ingested data from APIs and CSV files';

CREATE SCHEMA IF NOT EXISTS STAGING
COMMENT = 'Cleaned and standardized data (dbt staging layer)';

CREATE SCHEMA IF NOT EXISTS MART
COMMENT = 'Analytics layer (facts and dimensions)';
