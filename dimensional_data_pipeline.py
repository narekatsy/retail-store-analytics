from logging import logger 

def start_dimensional_data_pipeline():
    try:
        logger.info(f"Dimensional data pipeline started.")
        
        
        logger.info(f"Step 1: Loading data into the staging area...")
       
        logger.info(f"Step 2: Transforming data into dimensional format...")
      
        logger.info(f"Step 3: Inserting transformed data into Dimensional Tables...")
        
        
        logger.info(f"Dimensional data pipeline completed successfully.")
        
    except Exception as e:
        logger.error(f"Error occurred in Dimensional Data Flow: {str(e)}")
        raise


def start_relational_data_pipeline():
    try:
        logger.info(f"Relational data pipeline started.")
        
       
        logger.info(f"Step 1: Extracting relational data from source database...")
        
        logger.info(f"Step 2: Transforming relational data into staging area...")
        
        logger.info(f"Step 3: Inserting relational data into Data Warehouse...")
      
        logger.info(f"Relational data pipeline completed successfully.")
        
    except Exception as e:
        logger.error(f"Error occurred in Relational Data Flow: {str(e)}")
        raise


def run_data_flows():
    start_dimensional_data_pipeline()
    start_relational_data_pipeline()


if __name__ == "__main__":
    run_data_flows()
