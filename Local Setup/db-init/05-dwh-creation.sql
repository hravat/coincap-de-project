\getenv DWH_DB_USER DWH_DB_USER
\getenv DWH_DB_PASSWORD DWH_DB_PASSWORD

\echo DWH_DB_USER is :DWH_DB_USER
\echo DWH_DB_PASSWORD is :DWH_DB_PASSWORD


-- Create database
CREATE DATABASE coincap_dwh;


\c coincap_dwh
-- Create user with a password
CREATE USER coincap_user WITH PASSWORD 'coincap_password';

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE coincap_dwh TO coincap_user;


-- Optionally, if you want to allow this user to create new databases (needed for certain operations)
ALTER USER coincap_user CREATEDB;


GRANT USAGE, CREATE ON SCHEMA public TO coincap_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO coincap_user;


CREATE SCHEMA COINCAP_STG;
GRANT USAGE, CREATE ON SCHEMA COINCAP_STG TO coincap_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA COINCAP_STG TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA COINCAP_STG GRANT ALL PRIVILEGES ON TABLES TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA coincap_stg GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO coincap_user;

CREATE SCHEMA COINCAP_PROD;
GRANT USAGE, CREATE ON SCHEMA COINCAP_PROD TO coincap_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA COINCAP_PROD TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA COINCAP_PROD GRANT ALL PRIVILEGES ON TABLES TO coincap_user;

\c coincap_dwh coincap_user


CREATE TABLE COINCAP_STG.rates_api_raw (
    id VARCHAR(255),
    symbol VARCHAR(255),
    rateUsd NUMERIC(10,3),
    type varchar(255) NULL,
    source VARCHAR(255),
    event_timestamp TIMESTAMP
);


CREATE TABLE COINCAP_STG.rates_api_raw_archive (
    id VARCHAR(255),
    symbol VARCHAR(255),
    rateUsd NUMERIC(10,3),
    type varchar(255) NULL,
    source VARCHAR(255),
    event_timestamp TIMESTAMP
);

CREATE TABLE coincap_prod.dim_rates (
	rate_sr_key int8 NULL,
	id varchar(255) NULL,
	symbol varchar(255) NULL,
    type varchar(255) NULL,
	insert_time timestamptz NULL,
	update_time timestamptz NULL,
	active_flag text NULL,
	event_timestamp timestamp NULL
);

CREATE TABLE coincap_prod.fact_rates (
	rate_sr_key int8 NULL,
    date_sr_key int8 NULL,
    time_sr_key varchar(8) NULL,
	event_timestamp timestamp NULL,
	rateusd NUMERIC(10,3) NULL,
	insert_time timestamptz NULL,
	update_time timestamptz NULL,
	active_flag text NULL
);

CREATE SEQUENCE coincap_stg.rate_sr_key_sequence
START 1
INCREMENT BY 1;


CREATE TABLE coincap_prod.dim_date AS 
SELECT 
    CAST(to_char(dd  , 'YYYYMMDD') AS INTEGER) AS date_sr_key,
    dd AS full_date,
    TO_CHAR(dd, 'Day') AS day_of_week,
    EXTRACT(ISODOW FROM dd) AS day_of_week_num,
    EXTRACT(DAY FROM dd) AS day_of_month,
    EXTRACT(DOY FROM dd) AS day_of_year,
    EXTRACT(WEEK FROM dd) AS week_of_year,
    TO_CHAR(dd, 'Month') AS month_name,
    EXTRACT(MONTH FROM dd) AS month_num,
    EXTRACT(QUARTER FROM dd) AS quarter,
    EXTRACT(YEAR FROM dd) AS year
FROM generate_series(
    date_trunc('year', CURRENT_DATE),  -- Start of current year
    CURRENT_DATE,                      -- End as today
    INTERVAL '1 day'                   -- Step by 1 day
) AS dd;

create table  coincap_prod.dim_time as 
SELECT to_char(t  , 'HH24MISS') AS time_sr_key,
    t AS full_time,
    EXTRACT(HOUR FROM t) AS hour,
    EXTRACT(MINUTE FROM t) AS minute,
    EXTRACT(SECOND FROM t) AS second,
    TO_CHAR(t, 'AM') AS am_pm,
    EXTRACT(HOUR FROM t) % 12 AS hour_12,
    (EXTRACT(HOUR FROM t) < 12) AS is_morning,
    (EXTRACT(HOUR FROM t) >= 12) AS is_afternoon,
    (EXTRACT(HOUR FROM t) = 12 AND EXTRACT(MINUTE FROM t) = 0 AND EXTRACT(SECOND FROM t) = 0) AS is_noon,
    (EXTRACT(HOUR FROM t) = 0 AND EXTRACT(MINUTE FROM t) = 0 AND EXTRACT(SECOND FROM t) = 0) AS is_midnight
FROM generate_series(
    CURRENT_DATE::TIMESTAMP, 
    CURRENT_DATE::TIMESTAMP + INTERVAL '1 day' - INTERVAL '1 second',  
    INTERVAL '1 second'
) AS t;
