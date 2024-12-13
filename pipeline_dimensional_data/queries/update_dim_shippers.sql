USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Shippers';

INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Shippers AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

--  Insert 
INSERT INTO dbo.DimShippers (
    shipper_id_nk,
    company_name,
    phone,
    sor_key
)
SELECT 
    ST.ShipperID,
    ST.CompanyName,
    ST.Phone,
    DS.sor_key
FROM dbo.Staging_Shippers AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimShippers AS DT
    ON DT.shipper_id_nk = ST.ShipperID
WHERE DT.shipper_id_nk IS NULL;

-- Update 
UPDATE DT
SET 
    DT.company_name = ST.CompanyName,
    DT.phone = ST.Phone,
    DT.sor_key = DS.sor_key
FROM dbo.DimShippers AS DT
INNER JOIN dbo.Staging_Shippers AS ST
    ON DT.shipper_id_nk = ST.ShipperID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    DT.company_name <> ST.CompanyName OR
    DT.phone <> ST.Phone;
