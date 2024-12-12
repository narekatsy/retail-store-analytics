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
