<<<<<<< HEAD
from logging_config import logger
from datetime import datetime


from logging_config import logger

class DataFlow:
    def init(self, start_date, end_date):
       
        self.start_date = start_date
        self.end_date = end_date

    def exec(self):
        """ Execute the data flow from start_date to end_date """
        logger.info(f"Execution started from {self.start_date} to {self.end_date}")
        
        try:
           
            self.process_data()

            
            logger.info(f"Execution from {self.start_date} to {self.end_date} completed successfully.")
        except Exception as e:
            logger.error(f"Error during execution: {str(e)}")
            raise

    def process_data(self):
        """ Simulate database interaction like insert or update data in SQL Server """
        try:
            
            logger.debug(f"Processing data from {self.start_date} to {self.end_date}...")
            
           
            logger.info(f"Data processed successfully for the given period.")
        except Exception as e:
            logger.error(f"Error in processing data: {str(e)}")
            raise
=======
import uuid
from pipeline_dimensional_data.tasks import (
    create_staging_tables,
    create_dimensional_tables,
    ingest_dimensional_tables,
    ingest_fact_table,
)

class DimensionalDataFlow:
    def __init__(self):
        self.execution_id = str(uuid.uuid4())

    def exec(self):
        print(f"Execution ID: {self.execution_id}")

        # 1. Create staging tables
        result = create_staging_tables()
        if not result["success"]:
            print(f"Failed to create staging tables: {result['error']}")
            return result

        # 2. Create dimensional tables
        result = create_dimensional_tables()
        if not result["success"]:
            print(f"Failed to create dimensional tables: {result['error']}")
            return result

        # 3. Ingest dimensional tables
        result = ingest_dimensional_tables()
        if not result["success"]:
            print(f"Failed to ingest dimensional tables: {result['error']}")
            return result

        # 4. Ingest fact table
        result = ingest_fact_table()
        if not result["success"]:
            print(f"Failed to ingest fact table: {result['error']}")
            return result

        print("Pipeline executed successfully!")
        return {"success": True}
>>>>>>> 51af066439ccf47b051a4d13b03d189371052e91
