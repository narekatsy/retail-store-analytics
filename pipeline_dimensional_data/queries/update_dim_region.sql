DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Region_Staging';

INSERT INTO DimRegion (
    RegionID, RegionDescription, RegionCategory, RegionImportance, 
    CurrentRegionDescription, PriorRegionDescription
)
SELECT
    R.RegionID,
    R.RegionDescription,
    R.RegionCategory,
    R.RegionImportance,
    R.RegionDescription AS CurrentRegionDescription,
    NULL AS PriorRegionDescription
FROM 
    Region_Staging R
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);
