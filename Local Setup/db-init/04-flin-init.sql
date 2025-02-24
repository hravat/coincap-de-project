-- Create database
CREATE DATABASE flink;

-- Create user with a password
CREATE USER flinkuser WITH PASSWORD 'flinkpassword';

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE flink TO flinkuser;

-- Optionally, if you want to allow this user to create new databases (needed for certain operations)
ALTER USER flinkuser CREATEDB;