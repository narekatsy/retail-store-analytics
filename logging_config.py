import logging
import os
import uuid
from datetime import datetime


execution_id = str(uuid.uuid4())


log_dir = 'logs'
log_file = os.path.join(log_dir, 'logs_dimensional_data_pipeline.txt')


os.makedirs(log_dir, exist_ok=True)

def setup_logger():
   
    logger = logging.getLogger('DimensionalDataPipeline')
    logger.setLevel(logging.DEBUG)  

    if not logger.hasHandlers():
       
        file_handler = logging.FileHandler(log_file)
        file_handler.setLevel(logging.DEBUG)

       
        log_formatter = logging.Formatter(
            '%(asctime)s - %(execution_id)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )

     
        file_handler.setFormatter(log_formatter)

        
        logger.addHandler(file_handler)

    return logger


class ExecutionLoggerAdapter(logging.LoggerAdapter):
    def process(self, msg, kwargs):
       
        return msg, {**kwargs, 'extra': {'execution_id': execution_id}}

base_logger = setup_logger()


logger = ExecutionLoggerAdapter(base_logger, {})
