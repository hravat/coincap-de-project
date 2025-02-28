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
    rateUsd VARCHAR(255),
    source VARCHAR(255),
    event_timestamp TIMESTAMP
);


CREATE TABLE COINCAP_STG.rates_api_raw_archive (
    id VARCHAR(255),
    symbol VARCHAR(255),
    rateUsd VARCHAR(255),
    source VARCHAR(255),
    event_timestamp TIMESTAMP
);

CREATE TABLE coincap_prod.dim_rates (
	rate_sr_key int8 NULL,
	id varchar(255) NULL,
	symbol varchar(255) NULL,
	insert_time timestamptz NULL,
	update_time timestamptz NULL,
	active_flag text NULL,
	event_timestamp timestamp NULL
);

CREATE TABLE coincap_prod.fact_rates (
	rate_sr_key int8 NULL,
	event_timestamp timestamp NULL,
	rateusd varchar(255) NULL,
	insert_time timestamptz NULL,
	update_time timestamptz NULL,
	active_flag text NULL
);

CREATE SEQUENCE coincap_stg.rate_sr_key_sequence
START 1
INCREMENT BY 1;


