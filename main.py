from pipeline_dimensional_data.queries.flow import DataFlow
from datetime import datetime
from logging_config import logger  

if name == "main":
   
    start_date = datetime(2024, 1, 1)  
    end_date = datetime(2024, 12, 31)  

   
    data_flow = DataFlow(start_date, end_date)

    data_flow.exec()