# CoinCap Data Engineering Project  

## Overview  
This project is a data engineering pipeline for ingesting, processing, and analyzing cryptocurrency market data from the CoinCap API. The goal is to extract real-time data on different crypto currencies store it in a relational database in Fact and Dimension tables and view the data in a dashboard in real time. Apart from this another Dashboard is also presented to view data on exchange rates of different currncies.   

The data is obtained from the CoinCap API.

The documentation is available at :- https://docs.coincap.io/#d8fd6001-e127-448d-aadd-bfbfe2c89dbe


## Technology Stack 

A conscious choice has been made to avoid deploying anything on the cloud simply to save costs.
Also the volume of data involved is less as it is real time streaming data and can be handled locally 
without any signup hassles for a cloud account.  

The tech stack used for this project is as follows 

### 1) Docker 

This is the backbone of the Technology Stack and everything is containerized to ensure reproducibilty

### 2) Kafka 

Kafka is used to store data received from the CoinCap API using a pub-sub model, where downstream applications can subscribe to and consume these messages in real-time 

### 3) Apache Flink

Apache Flink, an open-source stream processing framework, consumes real-time messages from Kafka to enable efficient stream processing and analytics on cryptocurrency data, providing low-latency insights and supporting complex event-driven applications

Apache Flink has a source table that stores messages from Kafka and sink table connected to Postgres.
A Flink job inserts data from source to sink effectively pushing data to Postgres DB

### 4) Postgres DB

The Database of choice to finally store the data is POstgres DB 

### 5) DBT 

DBT is then used to model the raw into fact and dimension tables 

### 6) Grafana

Grafana is the tool of choice to visualize the data. It gives a Web UI to biuld visulizations nd add them to Dashbaords.
These dashboards can be saved in JSON format. Dashboards developed have been added below . 

### 7) Kestra

Kestra is used as the entire orcestartion software.  It orchesstrates python scripts to fetch data from the API and push it 
to Kafka, as well as DBT , Grafana and archiving scripts. 







## Project Structure  




This project uses docker file from the following open-source repository:

--https://dev.to/ftisiot/build-a-streaming-sql-pipeline-with-apache-flink-and-apache-kafka-53jg 
--https://github.com/aiven/sql-cli-for-apache-flink-docker.git


Thanks to the authors of this repository for their work, which has been incorporated into this project.
