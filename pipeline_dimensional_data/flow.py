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