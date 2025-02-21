\getenv KESTRA_DB_USER KESTRA_DB_USER
\getenv KESTRA_DB_PASSWORD KESTRA_DB_PASSWORD

\echo KESTRA_DB_USER is :KESTRA_DB_USER
\echo KESTRA_DB_PASSWORD is :KESTRA_DB_PASSWORD


CREATE DATABASE kestra_db;

\c kestra_db
-- Create a user for Airflow
CREATE USER kestra_user WITH PASSWORD 'kestra_password';


GRANT ALL PRIVILEGES ON DATABASE kestra_db TO kestra_user;

-- Grant usage and privileges on the schema
GRANT ALL PRIVILEGES ON SCHEMA public TO kestra_user;