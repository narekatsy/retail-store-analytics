from utils import execute_sql_file, read_csv_to_df, insert_data_from_df_to_sql
from pipeline_dimensional_data.config import DATABASE_NAME

def create_staging_raw_tables():
    """
    Task to create staging raw tables in the database.
    This will execute the SQL script for staging raw table creation.
    Returns:
        dict: {'success': True} if successful, otherwise {'success': False, 'error': <message>}
    """
    sql_file_path = r'infrastructure_initiation\staging_raw_table_creation.sql'
    result = execute_sql_file(sql_file_path, DATABASE_NAME)
    return result

def create_dimensional_db_tables():
    """
    Task to create the dimensional database tables in the database.
    This will execute the SQL script for dimensional table creation.
    Returns:
        dict: {'success': True} if successful, otherwise {'success': False, 'error': <message>}
    """
    sql_file_path = r'infrastructure_initiation\dimenional_db_table_creation.sql'
    result = execute_sql_file(sql_file_path, DATABASE_NAME)
    return result

def update_dim_sor():
    """
    Task to update the Dim_SOR table with metadata from the source systems.
    This will execute the update_dim_sor.sql script.
    """
    sql_file_path = r'pipeline_dimensional_data\queries\update_dim_sor.sql'
    result = execute_sql_file(sql_file_path, DATABASE_NAME)
    return result

def ingest_data_into_dimensional_tables():
    """
    Task to ingest data into dimensional tables from the staging data.
    Executes the parametrized SQL queries like update_dim_customers.sql, update_dim_categories.sql, etc.
    """
    sql_files = [
        r'pipeline_dimensional_data\queries\update_dim_categories.sql',
        r'pipeline_dimensional_data\queries\update_dim_categories.sql',
        r'pipeline_dimensional_data\queries\update_dim_employees.sql',
        r'pipeline_dimensional_data\queries\update_dim_region.sql',
        r'pipeline_dimensional_data\queries\update_dim_suppliers.sql',
        r'pipeline_dimensional_data\queries\update_dim_shippers.sql',
        r'pipeline_dimensional_data\queries\update_dim_territories.sql',
        r'pipeline_dimensional_data\queries\update_dim_products.sql'
    ]
    
    for sql_file_path in sql_files:
        result = execute_sql_file(sql_file_path, DATABASE_NAME)
        if not result['success']:
            return result
    
    return {'success': True}

def ingest_data_into_fact_tables():
    """
    Task to ingest data into fact tables like FactOrders, FactOrderDetails from staging and dimensional tables.
    Executes parametrized SQL queries like update_fact_orders.sql, update_fact_order_details.sql.
    """
    sql_files = [
        r'pipeline_dimensional_data\queries\update_fact_orders.sql',
        r'pipeline_dimensional_data\queries\update_fact_order_details.sql'
    ]
    
    for sql_file_path in sql_files:
        result = execute_sql_file(sql_file_path, DATABASE_NAME)
        if not result['success']:
            return result
    
    return {'success': True}

def ingest_data_into_fact_error_table():
    """
    Task to ingest rows that couldn't get into the fact table due to invalid or missing natural keys.
    Executes update_fact_error.sql.
    """
    sql_file_path = r'pipeline_dimensional_data\queries\update_fact_error.sql'
    result = execute_sql_file(sql_file_path, DATABASE_NAME)
    return result

def ingest_data_from_csv_to_table(csv_file_path, table_name):
    """
    Task to read data from a CSV file and insert it into the specified SQL table.
    Args:
        csv_file_path (str): Path to the CSV file.
        table_name (str): SQL table name to insert data into.
    """
    df = read_csv_to_df(csv_file_path)
    if df is None:
        return {'success': False, 'error': 'Failed to read CSV file.'}

    result = insert_data_from_df_to_sql(df, table_name)
    return result