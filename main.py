<<<<<<< HEAD
from pipeline_dimensional_data.queries.flow import DataFlow
from datetime import datetime
from logging_config import logger  

if name == "main":
   
    start_date = datetime(2024, 1, 1)  
    end_date = datetime(2024, 12, 31)  

   
    data_flow = DataFlow(start_date, end_date)

    data_flow.exec()
=======
from pipeline_dimensional_data.flow import DimensionalDataFlow

if __name__ == "__main__":
    pipeline = DimensionalDataFlow()
    result = pipeline.exec()
    if not result["success"]:
        print(f"Pipeline execution failed: {result['error']}")
    else:
        print("Pipeline completed successfully!")
>>>>>>> 51af066439ccf47b051a4d13b03d189371052e91
