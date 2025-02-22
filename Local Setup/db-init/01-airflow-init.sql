\getenv AIRFLOW_DB_USER AIRFLOW_DB_USER
\getenv AIRFLOW_DB_PASSWORD AIRFLOW_DB_PASSWORD

\echo AIRFLOW_DB_USER is :AIRFLOW_DB_USER
\echo AIRFLOW_DB_PASSWORD is :AIRFLOW_DB_PASSWORD


-- Create a database for Airflow
CREATE DATABASE airflow_db;

-- Create a user for Airflow
CREATE USER :AIRFLOW_DB_USER WITH PASSWORD :'AIRFLOW_DB_PASSWORD';

-- Grant privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE airflow_db TO airflow_user;

-- Optional: Create a schema in the database for Airflow
\c airflow_db
CREATE SCHEMA IF NOT EXISTS airflow AUTHORIZATION :AIRFLOW_DB_USER;

-- Grant usage and privileges on the schema
GRANT ALL PRIVILEGES ON SCHEMA public TO :AIRFLOW_DB_USER;