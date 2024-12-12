import pyodbc
import os
from pipeline_dimensional_data.config import CONNECTION_STRING

def get_db_connection():
    """
    Establish a connection to the SQL Server database using pyodbc.
    Returns a connection object if successful, else None.
    """
    try:
        connection_str = (
            f"DRIVER={CONNECTION_STRING['driver']};"
            f"SERVER={CONNECTION_STRING['server']};"
            f"DATABASE={CONNECTION_STRING['database']};"
            f"Trusted_Connection={CONNECTION_STRING['trusted_connection']};"
        )
        connection = pyodbc.connect(connection_str)
        return connection
    except Exception as e:
        print(f"Error connecting to database: {str(e)}")
        return None

def test_connection():
    """
    Test the database connection to ensure it works.
    Returns True if connection is successful, False otherwise.
    """
    connection = get_db_connection()
    if connection:
        print("Database connection successful!")
        return True
    else:
        print("Database connection failed.")
        return False

def execute_sql_file(sql_file_path, database_name):
    """
    Execute an SQL script from a file.
    Args:
        sql_file_path: Path to the SQL file.
        database_name: The target database where the SQL script will be executed.
    Returns:
        A dictionary with 'success' status and an 'error' message if any.
    """
    connection = get_db_connection()
    if not connection:
        return {"success": False, "error": "Failed to connect to the database."}

    cursor = connection.cursor()

    try:
        with open(sql_file_path, "r") as sql_file:
            sql_script = sql_file.read()

        cursor.execute(f"USE {database_name};")
        cursor.execute(sql_script)
        connection.commit()

        return {"success": True}

    except Exception as e:
        connection.rollback()
        return {"success": False, "error": str(e)}

    finally:
        cursor.close()
        connection.close()
