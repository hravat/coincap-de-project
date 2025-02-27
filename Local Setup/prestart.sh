#!/bin/bash
# prestart.sh

echo "Starting pre-start script..."

mkdir -p /home/hussain/kestra-data/coincap/api_flows/_files
mkdir -p /home/hussain/kestra-data/coincap/dbt_project/_files
mkdir -p /home/hussain/kestra-data/coincap/archive/_files

# Move files from ./kestra/python to /home/hussain/kestra-data/dev
cp -r ./kestra/python/* /home/hussain/kestra-data/coincap/api_flows/_files
cp -r ./dbt_project/ /home/hussain/kestra-data/coincap/dbt_project/_files
cp -r ./dbt/ /home/hussain/kestra-data/coincap/dbt_project/_files
cp -r ./kestra/sql/* /home/hussain/kestra-data/coincap/archive/_files

echo "Pre-start script completed. Files have been moved successfully."