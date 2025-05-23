import requests
import json
from datetime import datetime
import os

COINCAP_API_KEY = os.getenv("COINCAP_API_KEY")
print(f"My env value is: {COINCAP_API_KEY}")
API_URL = "https://rest.coincap.io/v3/rates?apiKey="+COINCAP_API_KEY
KAFKA_REST_PROXY_URL = "http://host.docker.internal:8082"  # Replace with the actual REST Proxy URL
KAFKA_TOPIC = "rates-api"


###TEST COMMENT TO SEE IF FILE IS BEING PICKED BY KESTRA  

def fetch_and_send_rates_to_kafka():


    try:
        response = requests.get(API_URL)
        response.raise_for_status()  # Raise an error for bad responses (4xx, 5xx)
        data = response.json()
        
        
        local_tz = datetime.now().astimezone().tzinfo 
        
        
        if "data" in data:
            records = []
            for rate in data["data"]:
                # Construct the message to send to Kafka with the required data
                timestamp = datetime.now(local_tz).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
                message = {
                    "value": {
                        "id": rate['id'],
                        "symbol": rate['symbol'],
                        "rateUsd": rate['rateUsd'],
                        "type": rate['type'],
                        "source": "kestra-doker",
                        "event_timestamp": timestamp
                    },
                    "key": rate['id']  # Using 'id' as the key, but you can choose another field
                }
                records.append(message)

            # Send the batch of records to Kafka
            send_to_kafka(records)
        else:
            print("No data found.")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def send_to_kafka(records):
    try:
        # Send the message via the Kafka REST Proxy with the correct Content-Type
        message = {
            "records": records
        }
        
        response = requests.post(
            f"{KAFKA_REST_PROXY_URL}/topics/{KAFKA_TOPIC}",
            headers={"Content-Type": "application/vnd.kafka.json.v2+json"},
            data=json.dumps(message)
        )

        response.raise_for_status()  # Raise an error for bad responses
        print(f"Message successfully sent to Kafka topic {KAFKA_TOPIC}")
    except requests.exceptions.RequestException as e:
        print(f"Error sending message to Kafka via REST API: {e}")

if __name__ == "__main__":
    fetch_and_send_rates_to_kafka()
