USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Customers';

INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Customers AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

-- Insert
INSERT INTO dbo.DimCustomers (
    customer_id_nk,
    customer_name,
    contact_name,
    address,
    city,
    region,
    postal_code,
    country,
    start_date,
    end_date,
    is_current,
    sor_key
)
SELECT 
    ST.CustomerID,
    ST.CompanyName,
    ST.ContactName,
    ST.Address,
    ST.City,
    ST.Region,
    ST.PostalCode,
    ST.Country,
    GETDATE(), -- Start date
    NULL, -- End date for current record
    1, -- is_current
    DS.sor_key
FROM dbo.Staging_Customers AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
LEFT JOIN dbo.DimCustomers AS DT
    ON DT.customer_id_nk = ST.CustomerID
WHERE DT.customer_id_nk IS NULL;

--Update
UPDATE DT
SET 
    DT.end_date = GETDATE(),
    DT.is_current = 0
FROM dbo.DimCustomers AS DT
INNER JOIN dbo.Staging_Customers AS ST
    ON DT.customer_id_nk = ST.CustomerID
WHERE 
    DT.is_current = 1 AND (
        DT.customer_name <> ST.CompanyName OR
        DT.contact_name <> ST.ContactName OR
        DT.address <> ST.Address OR
        DT.city <> ST.City OR
        DT.region <> ST.Region OR
        DT.postal_code <> ST.PostalCode OR
        DT.country <> ST.Country
    );
