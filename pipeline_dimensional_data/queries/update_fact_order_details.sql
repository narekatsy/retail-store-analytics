DECLARE @DatabaseName NVARCHAR(100);
DECLARE @SchemaName NVARCHAR(50);
DECLARE @TableName NVARCHAR(100);
DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @DatabaseName = 'ORDER_DDS';
SET @SchemaName = 'dbo';
SET @TableName = 'FactOrderDetails';
SET @StartDate = '2024-01-01';
SET @EndDate = '2024-12-31';
SET @SourceSystemKey = 1;
SET @SourceTableName = 'OrderDetails_Staging';

MERGE INTO FactOrderDetails AS Target
USING (
    SELECT 
        OD.staging_raw_id,
        OD.OrderID,
        OD.ProductID,
        F.OrderKey,
        P.ProductKey,
        OD.UnitPrice,
        OD.Quantity,
        OD.Discount
    FROM 
        OrderDetails_Staging OD
    LEFT JOIN FactOrders F ON OD.OrderID = F.OrderID
    LEFT JOIN DimProducts P ON OD.ProductID = P.ProductID
    WHERE 
        EXISTS (SELECT 1 FROM Dim_SOR D WHERE D.StagingRawTableName = @SourceTableName AND D.SORKey = @SourceSystemKey)
        AND F.OrderDate BETWEEN @StartDate AND @EndDate
) AS Source
ON Target.OrderKey = Source.OrderKey AND Target.ProductKey = Source.ProductKey
WHEN MATCHED THEN
    UPDATE SET
        Target.UnitPrice = Source.UnitPrice,
        Target.Quantity = Source.Quantity,
        Target.Discount = Source.Discount
WHEN NOT MATCHED THEN
    INSERT (
        OrderKey, ProductKey, UnitPrice, Quantity, Discount
    )
    VALUES (
        Source.OrderKey, Source.ProductKey, Source.UnitPrice, Source.Quantity, Source.Discount
    );
