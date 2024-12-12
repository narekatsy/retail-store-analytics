import configparser
import os

config = configparser.ConfigParser()
config.read('sql_server_config.cfg')

CONNECTION_STRING = {
    "driver": config.get('SQL_SERVER', 'driver'),
    "server": config.get('SQL_SERVER', 'server'),
    "database": config.get('SQL_SERVER', 'database'),
    "trusted_connection": config.get('SQL_SERVER', 'trusted_connection', fallback='yes')
}

DATABASE_NAME = "ORDER_DDS"
SCHEMA_NAME = "dbo"
