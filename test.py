import pyodbc

connection_string = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=DESKTOP-ON2ELO7;"
    "DATABASE=master;"  # Initially, connect to master DB to create ORDER_DDS
    "Trusted_Connection=yes;"
)

# Test the connection
try:
    conn = pyodbc.connect(connection_string)
    print("Connection successful!")
    conn.close()
except Exception as e:
    print(f"Connection failed: {e}")
