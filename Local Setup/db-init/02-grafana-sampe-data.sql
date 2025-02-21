\c postgres 
---SAMPLE TABLE CREATION
CREATE TABLE PUBLIC.sales_data (
    product_name VARCHAR(255),
    sales INT,
    date TIMESTAMP 
);


WITH random_data AS (
    SELECT
        -- Randomly selecting product names from a list
        (ARRAY['Product A', 'Product B', 'Product C', 'Product D', 'Product E'])[floor(random() * 5) + 1] AS product_name,
        
        -- Random sales value between 1 and 500
        floor(random() * 500) + 1 AS sales,
        
        -- Random timestamp within the past year
        CURRENT_TIMESTAMP - (floor(random() * 365) || ' days')::interval + (floor(random() * 86400) || ' seconds')::interval AS sales_timestamp
    FROM generate_series(1, 100)  -- 100 random records (adjustable)
)
-- Insert the generated random data into the sales_data table
INSERT INTO PUBLIC.sales_data (product_name, sales, date)
SELECT product_name, sales, sales_timestamp
FROM random_data;
