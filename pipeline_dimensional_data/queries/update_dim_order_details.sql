USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_OrderDetails';


INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_OrderDetails AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL; 

--  Insert 
INSERT INTO dbo.OrderDetails (
    OrderID,
    ProductID,
    UnitPrice,
    Quantity,
    Discount,
    sor_key
)
SELECT 
    ST.OrderID,
    ST.ProductID,
    ST.UnitPrice,
    ST.Quantity,
    ST.Discount,
    DS.sor_key
FROM dbo.Staging_OrderDetails AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.OrderDetails AS OD
    ON OD.OrderID = ST.OrderID AND OD.ProductID = ST.ProductID 
WHERE OD.OrderID IS NULL; 

UPDATE OD
SET 
    OD.UnitPrice = ST.UnitPrice,
    OD.Quantity = ST.Quantity,
    OD.Discount = ST.Discount,
    OD.sor_key = DS.sor_key
FROM dbo.OrderDetails AS OD
INNER JOIN dbo.Staging_OrderDetails AS ST
    ON OD.OrderID = ST.OrderID AND OD.ProductID = ST.ProductID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    OD.UnitPrice <> ST.UnitPrice OR
    OD.Quantity <> ST.Quantity OR
    OD.Discount <> ST.Discount;
