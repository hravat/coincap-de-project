import requests
import time
import json
from uuid import uuid4
from confluent_kafka import Producer


API_URL = "https://api.coincap.io/v2/rates"

def fetch_and_print_rates():
    try:
        response = requests.get(API_URL)
        response.raise_for_status()  # Raise an error for bad responses (4xx, 5xx)
        data = response.json()
        
        if "data" in data:
            for rate in data["data"]:
                print(f"{rate['id']} ({rate['symbol']}): {rate['rateUsd']} USD")
                break
        else:
            print("No data found.")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

#### KAFKA ###################
    jsonString1 = """ {"name":"Gal", "email":"Gadot84@gmail.com", "salary": "8345.55"} """
    jsonString2 = """ {"name":"Dwayne", "email":"Johnson52@gmail.com", "salary": "7345.75"} """
    jsonString3 = """ {"name":"Momoa", "email":"Jason91@gmail.com", "salary": "3345.25"} """
    
    jsonv1 = jsonString1.encode()
    jsonv2 = jsonString2.encode()
    jsonv3 = jsonString3.encode()

    kafka_topic_name = 'test-topic' 
    
    conf = {
    'bootstrap.servers': 'localhost:9092',  # Change this if needed
    }
    
    producer = Producer(conf)
    topic='test-topic'
    
    producer.produce(topic, key="key1", value="Hello, Kafka with KRaft!")
    producer.flush()
    
    print('Message succesfully sent to kafka')


if __name__ == "__main__":
    fetch_and_print_rates()