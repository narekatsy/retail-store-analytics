# Retail Store Data Pipeline

This repository implements an ETL pipeline for processing grocery store data. 
The pipeline supports dimensional modeling, handles Slowly Changing Dimensions (SCDs), and prepares data for dashboarding in Power BI. 

## Features
- **SQL scripts** for database setup and table creation.
- **Python ETL pipeline** for running SQL tasks and managing data flow.
- Logging for pipeline monitoring and debugging.
- Parameterized queries for updating dimension and fact tables.

## How to Use

1. Clone the repository

```bash
git clone https://github.com/narekatsy/retail-store-analytics.git
cd retail-store-analytics
```

2. Install the requirements

```bash
pip install -r requirements.txt
```
3. Run the project

```bash
python main.py
```

## Set up the database

Run the dimensional_db_creation.sql SQL script in the infrastructure_initiation.

## Configure the SQL Server connection
Add sql_server_config.cfg file in the main directory with the following format:
```bash
[SQL_SERVER]
driver = {Driver anem}
server = YOUR_SERVER_NAME
database = ORDER_DDS
trusted_connection = yes
```

## Run the project

```bash
python main.py
```
