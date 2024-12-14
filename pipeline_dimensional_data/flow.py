import uuid
import os
from pipeline_dimensional_data.tasks import (
    create_staging_raw_tables,
    create_dimensional_db_tables,
    update_dim_sor,
    ingest_data_into_dimensional_tables,
    ingest_data_into_fact_tables,
    ingest_data_into_fact_error_table,
    ingest_data_from_csv_to_table
)

class DimensionalDataFlow:
    def __init__(self):
        """
        Initializes the DimensionalDataFlow object with a unique execution ID
        for tracking and monitoring purposes.
        """
        self.execution_id = uuid.uuid4()
        print(f"Execution ID: {self.execution_id}")
        
    def exec(self, start_date, end_date):
        """
        Executes the tasks sequentially.
        
        Args:
            start_date (str): The start date for data ingestion.
            end_date (str): The end date for data ingestion.
            
        Returns:
            dict: {'success': True} if all tasks are successful, 
                  {'success': False, 'error': <message>} if any task fails.
        """
        
        # Task 1: Create Staging Raw Tables
        result = create_staging_raw_tables()
        if not result['success']:
            return {'success': False, 'error': 'Failed to create staging raw tables'}
        
        # Task 2: Create Dimensional DB Tables
        result = create_dimensional_db_tables()
        if not result['success']:
            return {'success': False, 'error': 'Failed to create dimensional database tables'}

        # Task 3: Update Dim_SOR Table (source system metadata)
        result = update_dim_sor()
        if not result['success']:
            return {'success': False, 'error': 'Failed to update Dim_SOR table'}
        
        # Task 4: Ingest CSV Files into Staging Tables (in `raw_data` folder)
        result = ingest_data_into_dimensional_tables()
        if not result['success']:
            return {'success': False, 'error': 'Failed to ingest CSV data into staging tables'}
        
        # Task 5: Ingest Data into Dimensional Tables
        result = ingest_data_into_dimensional_tables()
        if not result['success']:
            return {'success': False, 'error': 'Failed to ingest data into dimensional tables'}
        
        # Task 6: Ingest Data into Fact Tables
        result = ingest_data_into_fact_tables()
        if not result['success']:
            return {'success': False, 'error': 'Failed to ingest data into fact tables'}
        
        # Task 7: Ingest Faulty Rows into Fact Error Table (for missing or invalid keys)
        result = ingest_data_into_fact_error_table()
        if not result['success']:
            return {'success': False, 'error': 'Failed to ingest data into fact error table'}

        # Task 8: Ingest Data from CSV to Specific Tables (optional)
        result = self.ingest_csv_data_into_fact_and_dimensional_tables()
        if not result['success']:
            return {'success': False, 'error': 'Failed to ingest data from CSV files into fact/dimensional tables'}

        return {'success': True}

    def ingest_csv_data_into_staging_tables(self):
        """
        Ingest CSV files from the raw_data folder into the staging tables.
        Assumes each CSV file corresponds to a specific staging table.
        """
        raw_data_folder = 'raw_data'

        csv_to_staging_mapping = {
            'categories.csv': 'Categories_Staging',
            'customers.csv': 'Customers_Staging',
            'employees.csv': 'Employees_Staging',
            'region.csv': 'Region_Staging',
            'suppliers.csv': 'Suppliers_Staging',
            'shippers.csv': 'Shippers_Staging',
            'territories.csv': 'Territories_Staging',
            'products.csv': 'Products_Staging',
            'orders.csv': 'Orders_Staging',
            'order_details.csv': 'OrderDetails_Staging'
            }

        for csv_file, staging_table in csv_to_staging_mapping.items():
            csv_file_path = os.path.join(raw_data_folder, csv_file)
            if os.path.exists(csv_file_path):
                result = ingest_data_from_csv_to_table(csv_file_path, staging_table)
                if not result['success']:
                    return {'success': False, 'error': f'Failed to ingest CSV data into {staging_table}'}
            else:
                return {'success': False, 'error': f'CSV file {csv_file} does not exist in raw_data folder'}
        
        return {'success': True}

    def ingest_csv_data_into_fact_and_dimensional_tables(self):
        """
        Ingest CSV data into the dimensional and fact tables, as needed.
        """
        raw_data_folder = 'raw_data'

        csv_to_table_mapping = {
            'categories.csv': 'Categories_Staging',
            'customers.csv': 'Customers_Staging',
            'employees.csv': 'Employees_Staging',
            'region.csv': 'Region_Staging',
            'suppliers.csv': 'Suppliers_Staging',
            'shippers.csv': 'Shippers_Staging',
            'territories.csv': 'Territories_Staging',
            'products.csv': 'Products_Staging',
            'orders.csv': 'Orders_Staging',
            'order_details.csv': 'OrderDetails_Staging'
        }

        for csv_file, table in csv_to_table_mapping.items():
            csv_file_path = os.path.join(raw_data_folder, csv_file)
            if os.path.exists(csv_file_path):
                result = ingest_data_from_csv_to_table(csv_file_path, table)
                if not result['success']:
                    return {'success': False, 'error': f'Failed to ingest CSV data into {table}'}
            else:
                return {'success': False, 'error': f'CSV file {csv_file} does not exist in raw_data folder'}

        return {'success': True}
