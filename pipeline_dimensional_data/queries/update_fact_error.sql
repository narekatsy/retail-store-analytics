DECLARE @DatabaseName NVARCHAR(100);
DECLARE @SchemaName NVARCHAR(50);
DECLARE @TableName NVARCHAR(100);
DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @DatabaseName = 'ORDER_DDS';
SET @SchemaName = 'dbo';
SET @TableName = 'fact_error';
SET @StartDate = '2024-01-01';
SET @EndDate = '2024-12-31';
SET @SourceSystemKey = 1;
SET @SourceTableName = 'Orders_Staging';

INSERT INTO fact_error (
    OrderID, ProductID, CustomerID, EmployeeID, ShipVia, TerritoryID,
    OrderDate, RequiredDate, ShippedDate, Freight, ShipName, ShipAddress,
    ShipCity, ShipRegion, ShipPostalCode, ShipCountry, ErrorType, StagingRawID, SORKey
)
SELECT 
    O.OrderID,
    OD.ProductID,
    O.CustomerID,
    O.EmployeeID,
    O.ShipVia,
    O.TerritoryID,
    O.OrderDate,
    O.RequiredDate,
    O.ShippedDate,
    O.Freight,
    O.ShipName,
    O.ShipAddress,
    O.ShipCity,
    O.ShipRegion,
    O.ShipPostalCode,
    O.ShipCountry,
    'Missing or Invalid Key' AS ErrorType,
    O.staging_raw_id,
    D.SORKey
FROM 
    Orders_Staging O
LEFT JOIN DimCustomers C ON O.CustomerID = C.CustomerID
LEFT JOIN DimEmployees E ON O.EmployeeID = E.EmployeeID
LEFT JOIN DimShippers S ON O.ShipVia = S.ShipperID
LEFT JOIN DimTerritories T ON O.TerritoryID = T.TerritoryID
LEFT JOIN Dim_SOR D ON D.StagingRawTableName = @SourceTableName AND D.SORKey = @SourceSystemKey
WHERE 
    (
        C.CustomerKey IS NULL OR
        E.EmployeeKey IS NULL OR
        S.ShipperKey IS NULL OR
        T.TerritoryKey IS NULL
    )
    AND O.OrderDate BETWEEN @StartDate AND @EndDate
    AND EXISTS (SELECT 1 FROM Dim_SOR D WHERE D.StagingRawTableName = @SourceTableName AND D.SORKey = @SourceSystemKey);
