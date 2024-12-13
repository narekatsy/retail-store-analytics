USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Region';


INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Region AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

--  Insert 
INSERT INTO dbo.DimRegion (
    region_id_nk,
    region_description,
    sor_key
)
SELECT 
    ST.RegionID,
    ST.RegionDescription,
    DS.sor_key
FROM dbo.Staging_Region AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimRegion AS DT
    ON DT.region_id_nk = ST.RegionID
WHERE DT.region_id_nk IS NULL;

--  Update
UPDATE DT
SET 
    DT.region_description = ST.RegionDescription,
    DT.sor_key = DS.sor_key
FROM dbo.DimRegion AS DT
INNER JOIN dbo.Staging_Region AS ST
    ON DT.region_id_nk = ST.RegionID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    DT.region_description <> ST.RegionDescription;
