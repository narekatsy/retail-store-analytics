DECLARE @DatabaseName NVARCHAR(255) = 'ORDER_DDS';
DECLARE @SchemaName NVARCHAR(255) = 'dbo';
DECLARE @FactTableName NVARCHAR(255) = 'FactOrders';
DECLARE @SourceTableName NVARCHAR(255) = 'Staging_FactOrders';
DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2024-12-31';



INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM [ORDER_DDS].[dbo].[Staging_FactOrders] AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

-- Update 
UPDATE FO
SET 
    FO.customer_id_sk = DCT.customer_id_sk,
    FO.employee_id_sk = DEM.employee_id_sk,
    FO.shipper_id_sk = DSP.shipper_id_sk,
    FO.quantity = ST.Quantity,
    FO.unit_price = ST.UnitPrice,
    FO.discount = ST.Discount,
    FO.sor_key = CAST(ST.StagingID AS NVARCHAR)
FROM [ORDER_DDS].[dbo].[FactOrders] AS FO
INNER JOIN [ORDER_DDS].[dbo].[Staging_FactOrders] AS ST
    ON FO.order_id_nk = ST.OrderID
INNER JOIN dbo.DimProducts AS DPC
    ON FO.product_id_sk = DPC.product_id_sk AND DPC.product_id_nk = ST.ProductID
LEFT JOIN dbo.DimCustomers AS DCT
    ON DCT.customer_id_nk = ST.CustomerID
LEFT JOIN dbo.DimEmployees AS DEM
    ON DEM.employee_id_nk = ST.EmployeeID
LEFT JOIN dbo.DimShippers AS DSP
    ON DSP.shipper_id_nk = ST.ShipVia
WHERE ST.OrderDate BETWEEN @StartDate AND @EndDate;

-- Insert 
INSERT INTO [ORDER_DDS].[dbo].[FactOrders] (
    order_id_nk,
    product_id_sk,
    customer_id_sk,
    employee_id_sk,
    shipper_id_sk,
    order_date,
    quantity,
    unit_price,
    discount,
    sor_key
)
SELECT 
    ST.OrderID,
    DPC.product_id_sk,
    DCT.customer_id_sk,
    DEM.employee_id_sk,
    DSP.shipper_id_sk,
    ST.OrderDate,
    ST.Quantity,
    ST.UnitPrice,
    ST.Discount,
    CAST(ST.StagingID AS NVARCHAR)
FROM [ORDER_DDS].[dbo].[Staging_FactOrders] AS ST
LEFT JOIN dbo.DimProducts AS DPC
    ON DPC.product_id_nk = ST.ProductID
LEFT JOIN dbo.DimCustomers AS DCT
    ON DCT.customer_id_nk = ST.CustomerID
LEFT JOIN dbo.DimEmployees AS DEM
    ON DEM.employee_id_nk = ST.EmployeeID
LEFT JOIN dbo.DimShippers AS DSP
    ON DSP.shipper_id_nk = ST.ShipVia
LEFT JOIN [ORDER_DDS].[dbo].[FactOrders] AS FO
    ON FO.order_id_nk = ST.OrderID AND FO.product_id_sk = DPC.product_id_sk
WHERE FO.order_id_nk IS NULL AND ST.OrderDate BETWEEN @StartDate AND @EndDate;
