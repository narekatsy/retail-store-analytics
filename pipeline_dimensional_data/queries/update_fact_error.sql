DECLARE @DatabaseName NVARCHAR(255) = 'ORDER_DDS'; 
DECLARE @SchemaName NVARCHAR(255) = 'dbo';
DECLARE @FactErrorTableName NVARCHAR(255) = 'FactOrders_Error'; 
DECLARE @SourceTableName NVARCHAR(255) = 'Staging_FactOrders'; 
DECLARE @StartDate DATE = '2000-01-01'; 
DECLARE @EndDate DATE = '2024-12-31'; 

-- Insert faulty rows into FactOrders_Error due to missing or invalid natural keys
INSERT INTO ORDER_DDS.dbo.FactOrders_Error (
    staging_raw_id,
    source_table_name,
    error_reason,
    order_id,
    product_id,
    customer_id,
    employee_id,
    ship_via,
    order_date,
    sor_key
)
SELECT 
    ST.StagingID AS staging_raw_id,
    @SourceTableName AS source_table_name,
    CASE
        WHEN DPC.product_id_sk IS NULL THEN 'Missing ProductID'
        WHEN DCT.customer_id_sk IS NULL THEN 'Missing CustomerID'
        WHEN DEM.employee_id_sk IS NULL THEN 'Missing EmployeeID'
        WHEN DSP.shipper_id_sk IS NULL THEN 'Missing ShipperID'
        ELSE 'Unknown Error'
    END AS error_reason,
    ST.OrderID,
    ST.ProductID,
    ST.CustomerID,
    ST.EmployeeID,
    ST.ShipVia,
    ST.OrderDate
    CAST(ST.StagingID AS NVARCHAR) AS sor_key
FROM ORDER_DDS.dbo.Staging_FactOrders AS ST
LEFT JOIN dbo.DimProducts AS DPC
    ON DPC.product_id_nk = ST.ProductID
LEFT JOIN dbo.DimCustomers AS DCT
    ON DCT.customer_id_nk = ST.CustomerID
LEFT JOIN dbo.DimEmployees AS DEM
    ON DEM.employee_id_nk = ST.EmployeeID
LEFT JOIN dbo.DimShippers AS DSP
    ON DSP.shipper_id_nk = ST.ShipVia
WHERE ST.OrderDate BETWEEN @StartDate AND @EndDate
  AND (DPC.product_id_sk IS NULL OR DCT.customer_id_sk IS NULL OR DEM.employee_id_sk IS NULL OR DSP.shipper_id_sk IS NULL);
