CONNECTION_STRING = {
    "driver": "{ODBC Driver 17 for SQL Server}",
    "server": "DESKTOP-ON2ELO7",
    "database": "ORDER_DDS",
    "trusted_connection": "yes",
}

SQL_PATHS = {
    "create_staging_tables": "infrastructure_initiation/staging_raw_table_creation.sql",
    "create_dimensional_tables": "infrastructure_initiation/dimensional_db_table_creation.sql",
    "update_fact": "pipeline_dimensional_data/queries/update_fact.sql",
    "update_dim_categories": "pipeline_dimensional_data/queries/update_dim_categories.sql",
    "update_dim_customers": "pipeline_dimensional_data/queries/update_dim_customers.sql",
    "update_dim_employees": "pipeline_dimensional_data/queries/update_dim_employees.sql",
    "update_dim_products": "pipeline_dimensional_data/queries/update_dim_products.sql",
    "update_dim_region": "pipeline_dimensional_data/queries/update_dim_region.sql",
    "update_dim_suppliers": "pipeline_dimensional_data/queries/update_dim_suppliers.sql",
    "update_dim_shippers": "pipeline_dimensional_data/queries/update_dim_shippers.sql",
    "update_dim_territories": "pipeline_dimensional_data/queries/update_dim_territories.sql",
}

DATABASE_NAME = "ORDER_DDS"
SCHEMA_NAME = "dbo"

