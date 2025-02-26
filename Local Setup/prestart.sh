#!/bin/bash
# prestart.sh

echo "Starting pre-start script..."

# Move files from ./kestra/python to /home/hussain/kestra-data/dev
cp -r ./kestra/python/* /home/hussain/kestra-data/api_flows/_files
cp -r ./dbt_project/* /home/hussain/kestra-data/dbt_project/_files
cp -r ./dbt/* /home/hussain/kestra-data/dbt_project/_files

echo "Pre-start script completed. Files have been moved successfully."S