DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Shippers_Staging';

INSERT INTO DimShippers (
    ShipperID, CompanyName, Phone
)
SELECT 
    S.ShipperID,
    S.CompanyName,
    S.Phone
FROM 
    Shippers_Staging S
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR D WHERE D.StagingRawTableName = @SourceTableName AND D.SORKey = @SourceSystemKey);
