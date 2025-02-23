#!/bin/bash
# prestart.sh

echo "Starting pre-start script..."

# Move files from ./kestra/python to /home/hussain/kestra-data/dev
cp -r ./kestra/python/* /home/hussain/kestra-data/dev/_files

echo "Pre-start script completed. Files have been moved successfully."