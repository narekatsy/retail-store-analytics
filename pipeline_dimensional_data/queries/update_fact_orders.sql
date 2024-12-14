DECLARE @DatabaseName NVARCHAR(100);
DECLARE @SchemaName NVARCHAR(50);
DECLARE @TableName NVARCHAR(100);
DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @DatabaseName = 'ORDER_DDS';
SET @SchemaName = 'dbo';
SET @TableName = 'FactOrders';
SET @StartDate = '2024-01-01';
SET @EndDate = '2024-12-31';
SET @SourceSystemKey = 1;
SET @SourceTableName = 'Orders_Staging';

MERGE INTO FactOrders AS Target
USING (
    SELECT 
        O.staging_raw_id,
        O.OrderID,
        C.CustomerKey,
        E.EmployeeKey,
        T.TerritoryKey,
        S.ShipperKey,
        O.OrderDate,
        O.RequiredDate,
        O.ShippedDate,
        O.ShipVia,
        O.Freight,
        O.ShipName,
        O.ShipAddress,
        O.ShipCity,
        O.ShipRegion,
        O.ShipPostalCode,
        O.ShipCountry
    FROM 
        Orders_Staging O
    LEFT JOIN DimCustomers C ON O.CustomerID = C.CustomerID
    LEFT JOIN DimEmployees E ON O.EmployeeID = E.EmployeeID
    LEFT JOIN DimTerritories T ON O.TerritoryID = T.TerritoryID
    LEFT JOIN DimShippers S ON O.ShipVia = S.ShipperID
    WHERE 
        EXISTS (SELECT 1 FROM Dim_SOR D WHERE D.StagingRawTableName = @SourceTableName AND D.SORKey = @SourceSystemKey)
        AND O.OrderDate BETWEEN @StartDate AND @EndDate
) AS Source
ON Target.OrderID = Source.OrderID
WHEN MATCHED THEN
    UPDATE SET
        Target.CustomerKey = Source.CustomerKey,
        Target.EmployeeKey = Source.EmployeeKey,
        Target.TerritoryKey = Source.TerritoryKey,
        Target.ShipperKey = Source.ShipperKey,
        Target.OrderDate = Source.OrderDate,
        Target.RequiredDate = Source.RequiredDate,
        Target.ShippedDate = Source.ShippedDate,
        Target.ShipVia = Source.ShipVia,
        Target.Freight = Source.Freight,
        Target.ShipName = Source.ShipName,
        Target.ShipAddress = Source.ShipAddress,
        Target.ShipCity = Source.ShipCity,
        Target.ShipRegion = Source.ShipRegion,
        Target.ShipPostalCode = Source.ShipPostalCode,
        Target.ShipCountry = Source.ShipCountry
WHEN NOT MATCHED THEN
    INSERT (
        OrderID, CustomerKey, EmployeeKey, TerritoryKey, ShipperKey, OrderDate, 
        RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, 
        ShipCity, ShipRegion, ShipPostalCode, ShipCountry
    )
    VALUES (
        Source.OrderID, Source.CustomerKey, Source.EmployeeKey, Source.TerritoryKey, 
        Source.ShipperKey, Source.OrderDate, Source.RequiredDate, Source.ShippedDate, 
        Source.ShipVia, Source.Freight, Source.ShipName, Source.ShipAddress, 
        Source.ShipCity, Source.ShipRegion, Source.ShipPostalCode, Source.ShipCountry
    );
