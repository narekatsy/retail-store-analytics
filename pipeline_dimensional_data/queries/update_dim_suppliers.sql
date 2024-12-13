USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Suppliers';


INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Suppliers AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

-- Insert 
INSERT INTO dbo.DimSuppliers (
    supplier_id_nk,
    company_name,
    contact_name,
    contact_title,
    address,
    city,
    region,
    postal_code,
    country,
    phone,
    fax,
    sor_key
)
SELECT 
    ST.SupplierID,
    ST.CompanyName,
    ST.ContactName,
    ST.ContactTitle,
    ST.Address,
    ST.City,
    ST.Region,
    ST.PostalCode,
    ST.Country,
    ST.Phone,
    ST.Fax,
    DS.sor_key
FROM dbo.Staging_Suppliers AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimSuppliers AS DT
    ON DT.supplier_id_nk = ST.SupplierID
WHERE DT.supplier_id_nk IS NULL;

--  Update 
UPDATE DT
SET 
    DT.company_name = ST.CompanyName,
    DT.contact_name = ST.ContactName,
    DT.contact_title = ST.ContactTitle,
    DT.address = ST.Address,
    DT.city = ST.City,
    DT.region = ST.Region,
    DT.postal_code = ST.PostalCode,
    DT.country = ST.Country,
    DT.phone = ST.Phone,
    DT.fax = ST.Fax,
    DT.sor_key = DS.sor_key
FROM dbo.DimSuppliers AS DT
INNER JOIN dbo.Staging_Suppliers AS ST
    ON DT.supplier_id_nk = ST.SupplierID
INNER JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE 
    DT.company_name <> ST.CompanyName OR
    DT.contact_name <> ST.ContactName OR
    DT.address <> ST.Address OR
    DT.city <> ST.City OR
    DT.region <> ST.Region OR
    DT.postal_code <> ST.PostalCode OR
    DT.country <> ST.Country OR
    DT.phone <> ST.Phone OR
    DT.fax <> ST.Fax;
