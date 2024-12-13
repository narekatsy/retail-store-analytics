USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Categories';

INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Categories AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

-- Insert
INSERT INTO dbo.DimCategories (
    category_id_nk,
    category_name,
    cat_description,
    is_active,
    sor_key
)
SELECT 
    ST.CategoryID,
    ST.CategoryName,
    ST.Description,
    1,
    DS.sor_key
FROM dbo.Staging_Categories AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimCategories AS DT
    ON DT.category_id_nk = ST.CategoryID
WHERE DT.category_id_nk IS NULL;

-- Update
UPDATE DT
SET 
    DT.category_name = ST.CategoryName,
    DT.cat_description = ST.Description,
    DT.sor_key = DS.sor_key
FROM dbo.DimCategories AS DT
INNER JOIN dbo.Staging_Categories AS ST
    ON DT.category_id_nk = ST.CategoryID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    DT.category_name <> ST.CategoryName OR
    DT.cat_description <> ST.Description;

-- Delete
DELETE FROM dbo.DimCategories
WHERE category_id_nk NOT IN (
    SELECT ST.CategoryID
    FROM dbo.Staging_Categories AS ST
);
