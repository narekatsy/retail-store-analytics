DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Territories_Staging';

INSERT INTO DimTerritories (
    TerritoryID, TerritoryDescription, CurrentTerritoryDescription, PriorTerritoryDescription, RegionKey
)
SELECT 
    T.TerritoryID,
    T.TerritoryDescription,
    T.TerritoryDescription AS CurrentTerritoryDescription,
    NULL AS PriorTerritoryDescription,
    R.RegionKey
FROM 
    Territories_Staging T
LEFT JOIN DimRegion R ON T.RegionID = R.RegionID
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR D WHERE D.StagingRawTableName = @SourceTableName AND D.SORKey = @SourceSystemKey);
