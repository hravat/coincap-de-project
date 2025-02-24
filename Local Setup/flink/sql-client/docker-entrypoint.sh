#!/bin/bash


#!/bin/bash

# Run all SQL scripts before starting the SQL client
#for sql_file in /opt/flink/sql-scripts/*.sql; do
#    echo "Running: $sql_file"
#    ${FLINK_HOME}/bin/sql-client.sh -f "$sql_file"
#done
#
## Start Flink SQL Client
exec ${FLINK_HOME}/bin/sql-client.sh  -i /opt/flink/sql-scripts/rates_api.sql -l ${SQL_CLIENT_HOME}/lib
#
${FLINK_HOME}/bin/sql-client.sh -f "/opt/flink/sql-scripts/rates_api.sql"