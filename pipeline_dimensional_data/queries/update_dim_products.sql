DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Products_Staging';

INSERT INTO DimProducts (
    ProductID, ProductName, SupplierKey, CategoryKey, ReorderLevel, Discontinued
)
SELECT 
    P.ProductID,
    P.ProductName,
    P.SupplierID,
    P.CategoryID,
    P.ReorderLevel,
    P.Discontinued
FROM 
    Products_Staging P
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);

INSERT INTO DimProducts_MiniDimension (
    ProductKey, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder
)
SELECT 
    DP.ProductKey,
    P.QuantityPerUnit,
    P.UnitPrice,
    P.UnitsInStock,
    P.UnitsOnOrder
FROM 
    Products_Staging P
JOIN 
    DimProducts DP ON P.ProductID = DP.ProductID  -- Join on ProductID to get the generated ProductKey
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);
