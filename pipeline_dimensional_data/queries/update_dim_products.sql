USE ORDER_DDS;
DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Products';


INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Products AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

--  Insert
INSERT INTO dbo.DimProducts (
    product_id_nk,
    product_name,
    supplier_id,
    category_id,
    quantity_per_unit,
    unit_price,
    units_in_stock,
    units_on_order,
    reorder_level,
    discontinued,
    sor_key
)
SELECT 
    ST.ProductID,
    ST.ProductName,
    ST.SupplierID,
    ST.CategoryID,
    ST.QuantityPerUnit,
    ST.UnitPrice,
    ST.UnitsInStock,
    ST.UnitsOnOrder,
    ST.ReorderLevel,
    ST.Discontinued,
    DS.sor_key
FROM dbo.Staging_Products AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimProducts AS DT
    ON DT.product_id_nk = ST.ProductID
WHERE DT.product_id_nk IS NULL;

-- Update
UPDATE DT
SET 
    DT.product_name = ST.ProductName,
    DT.unit_price = ST.UnitPrice,
    DT.units_in_stock = ST.UnitsInStock,
    DT.sor_key = DS.sor_key
FROM dbo.DimProducts AS DT
INNER JOIN dbo.Staging_Products AS ST
    ON DT.product_id_nk = ST.ProductID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    DT.product_name <> ST.ProductName OR
    DT.unit_price <> ST.UnitPrice OR
    DT.units_in_stock <> ST.UnitsInStock;
