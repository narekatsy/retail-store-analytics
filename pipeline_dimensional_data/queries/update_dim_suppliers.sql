USE ORDER_DDS;

INSERT INTO DimSuppliers (
    supplier_id_nk, 
    company_name,
    contact_name,
    address,
    city,
    region,
    postal_code,
    country,
    is_active
)
SELECT
    STG.SupplierID,
    STG.CompanyName,
    STG.ContactName,
    STG.Address,
    STG.City,
    STG.Region,
    STG.PostalCode,
    STG.Country,
    1 AS is_active
FROM dbo.Staging_Suppliers STG
LEFT JOIN DimSuppliers DIM
    ON STG.SupplierID = DIM.supplier_id_nk
WHERE DIM.supplier_id_nk IS NULL;
