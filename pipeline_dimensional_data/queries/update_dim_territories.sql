USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Territories';


INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Territories AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

-- Insert
INSERT INTO dbo.DimTerritories (
    territory_id_nk,
    territory_description,
    region_id_nk,
    sor_key
)
SELECT 
    ST.TerritoryID,
    ST.TerritoryDescription,
    ST.RegionID,
    DS.sor_key
FROM dbo.Staging_Territories AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimTerritories AS DT
    ON DT.territory_id_nk = ST.TerritoryID
WHERE DT.territory_id_nk IS NULL;

--  Update 
UPDATE DT
SET 
    DT.territory_description = ST.TerritoryDescription,
    DT.region_id_nk = ST.RegionID,
    DT.sor_key = DS.sor_key
FROM dbo.DimTerritories AS DT
INNER JOIN dbo.Staging_Territories AS ST
    ON DT.territory_id_nk = ST.TerritoryID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    DT.territory_description <> ST.TerritoryDescription OR
    DT.region_id_nk <> ST.RegionID;
