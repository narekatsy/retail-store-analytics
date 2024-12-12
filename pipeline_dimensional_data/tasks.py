from utils import execute_sql_file

def create_staging_tables():
    """Creates staging tables."""
    return execute_sql_file("infrastructure_initiation\staging_raw_table_creation.sql", database_name="ORDER_DDS")

def create_dimensional_tables():
    """Creates dimensional tables."""
    return execute_sql_file("infrastructure_initiation\dimenional_db_table_creation.sql", database_name="ORDER_DDS")

def ingest_dimensional_tables():
    """Ingests data into all dimensional tables sequentially."""
    dimensional_queries = [
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_categories.sql", "table": "DimCategories"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_customers.sql", "table": "DimCustomers"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_employees.sql", "table": "DimEmployees"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_products.sql", "table": "DimProducts"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_region.sql", "table": "DimRegion"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_suppliers.sql", "table": "DimSuppliers"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_shippers.sql", "table": "DimShippers"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_territories.sql", "table": "DimTerritories"},
        {"sql_file": "pipeline_dimensional_data/queries/update_dim_order_details.sql", "table": "DimOrderDetails"},
    ]

    for query in dimensional_queries:
        result = execute_sql_file(query["sql_file"], database_name="ORDER_DDS")
        if not result["success"]:
            return {
                "success": False,
                "error": f"Failed to update {query['table']}: {result['error']}",
            }

    return {"success": True}

def ingest_fact_table():
    """Ingests data into the FactOrders table."""
    return execute_sql_file("pipeline_dimensional_data/queries/update_fact.sql", database_name="ORDER_DDS")
