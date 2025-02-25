\getenv FLINK_DB_USER FLINK_DB_USER
\getenv FLINK_DB_PASSWORD FLINK_DB_PASSWORD

\echo FLINK_DB_USER is :FLINK_DB_USER
\echo FLINK_DB_PASSWORD is :FLINK_DB_PASSWORD


-- Create database
CREATE DATABASE flink;

\c flink
-- Create user with a password
CREATE USER flinkuser WITH PASSWORD 'flinkpassword';

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE flink TO flinkuser;


-- Optionally, if you want to allow this user to create new databases (needed for certain operations)
ALTER USER flinkuser CREATEDB;

GRANT USAGE, CREATE ON SCHEMA public TO flinkuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO flinkuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO flinkuser;


CREATE TABLE public.rates_api_raw (
    id VARCHAR(255),
    symbol VARCHAR(255),
    rateUsd VARCHAR(255),
    source VARCHAR(255),
    event_timestamp TIMESTAMP
);