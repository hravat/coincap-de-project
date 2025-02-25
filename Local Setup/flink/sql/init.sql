--SET 'session.execution.timeout' = '0';  -- Disable session timeout
--SET 'session.idle-timeout' = '0'; 
--
--CREATE CATALOG coincap_catalog WITH (
--    'type' = 'jdbc',
--    'default-database' = 'flink',  -- Name of the database you created in PostgreSQL
--    'username' = 'flinkuser',  -- The user you created
--    'password' = 'flinkpassword',  -- The password for your user
--    'base-url' = 'jdbc:postgresql://postgres_db:5432'  -- Connection URL (container name: `postgres-db`, port: 5432)
--);

-- Set it as the default catalog
--USE CATALOG default_catalog;


CREATE TABLE rates_api_raw (
    id STRING,
    symbol STRING,
    rateUsd STRING,  
    source STRING,
    event_timestamp TIMESTAMP(3)
) WITH (
    'connector' = 'kafka',
    'topic' = 'test-topic',
    'properties.bootstrap.servers' = 'broker:29092',
    'properties.group.id' = 'flink-consumer',
    'scan.startup.mode' = 'latest-offset',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);


CREATE TABLE rates_api_raw_postgres_sink (
        id STRING,
        symbol STRING,
        rateUsd STRING,
        source STRING,
        event_timestamp TIMESTAMP(3)
    ) WITH (
        'connector' = 'jdbc',                                      -- Specifies the connector type as JDBC
        'url' = 'jdbc:postgresql://postgres_db:5432/flink',   -- PostgreSQL connection URL
        'table-name' = 'public.rates_api_raw',                            -- Target table in PostgreSQL
        'username' = 'flinkuser',                                    -- PostgreSQL username
        'password' = 'flinkpassword',                                -- PostgreSQL password
        'sink.buffer-flush.max-rows' = '1000',                        -- Number of rows to buffer before flushing to PostgreSQL
        'sink.buffer-flush.interval' = '2s'   
    -- Interval for flushing the buffered data (2 seconds in this case)
    );
