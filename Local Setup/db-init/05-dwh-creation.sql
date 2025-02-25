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
GRANT ALL PRIVILEGES ON DATABASE flink TO coincap_user;


-- Optionally, if you want to allow this user to create new databases (needed for certain operations)
ALTER USER coincap_user CREATEDB;


GRANT USAGE, CREATE ON SCHEMA public TO coincap_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO coincap_user;


CREATE SCHEMA COINCAP_STG;
GRANT USAGE, CREATE ON SCHEMA COINCAP_STG TO coincap_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA COINCAP_STG TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA COINCAP_STG GRANT ALL PRIVILEGES ON TABLES TO coincap_user;


CREATE SCHEMA COINCAP_PROD;
GRANT USAGE, CREATE ON SCHEMA COINCAP_PROD TO coincap_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA COINCAP_PROD TO coincap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA COINCAP_PROD GRANT ALL PRIVILEGES ON TABLES TO coincap_user;


CREATE TABLE COINCAP_STG.rates_api_raw (
    id VARCHAR(255),
    symbol VARCHAR(255),
    rateUsd VARCHAR(255),
    source VARCHAR(255),
    event_timestamp TIMESTAMP
);
