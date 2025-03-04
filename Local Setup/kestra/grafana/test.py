import os
import psycopg2

# Database connection parameters
db_host = "postgres_db"
db_port = "5432"  # usually 5432 for PostgreSQL
db_name = "coincap_dwh"
db_user = "coincap_user"
db_password = "coincap_password"

# Define the path inside the Docker container where you want to save the text file
docker_path = '/app/geojson/filename.txt'

# SQL query
query = """
WITH ranked_data AS (
    SELECT 
        dcr.*,
        fcr.*,
        ROW_NUMBER() OVER (
            PARTITION BY dcr.currency_sr_key 
            ORDER BY fcr.event_timestamp DESC
        ) AS rn
    FROM coincap_prod.dim_currency_rate dcr   
    INNER JOIN coincap_prod.fact_currency_rate fcr 
        ON dcr.currency_sr_key = fcr.currency_sr_key 
    WHERE dcr.currency_type = 'fiat'
)
SELECT UPPER(ranked_data.currency_id ) as "Currency ID",
        case 
            when ranked_data.currenncy_rate_in_usd = 0 then NULL
            else 1/ranked_data.currenncy_rate_in_usd
        end  "Currency Rate"
FROM ranked_data 
WHERE rn = 1
order by ranked_data.currenncy_rate_in_usd NULLS FIRST;
"""

# Connect to the database
try:
    conn = psycopg2.connect(
        host=db_host,
        port=db_port,
        dbname=db_name,
        user=db_user,
        password=db_password
    )
    cursor = conn.cursor()

    # Execute the SQL query
    cursor.execute(query)

    # Fetch all rows
    rows = cursor.fetchall()

    # Ensure the directory exists
    os.makedirs(os.path.dirname(docker_path), exist_ok=True)

    # Write the results to the text file
    with open(docker_path, 'w') as f:
        # Write the headers (column names) to the file
        f.write("Currency ID, Currency Rate\n")
        
        # Write each row of the results to the file
        for row in rows:
            f.write(f"{row[0]}, {row[1]}\n")

    print(f"Text file created at {docker_path}")

except Exception as e:
    print(f"Error: {e}")

finally:
    # Close the database connection
    if conn:
        cursor.close()
        conn.close()
