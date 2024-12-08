USE ORDER_DDS;

INSERT INTO DimCustomers (
    customer_id_nk, -- Natural Key
    customer_name,
    contact_name,
    address,
    city,
    region,
    postal_code,
    country,
    is_current -- Updated column name
)
SELECT
    STG.CustomerID,
    STG.CompanyName, -- Corrected column name
    STG.ContactName,
    STG.Address,
    STG.City,
    STG.Region,
    STG.PostalCode,
    STG.Country,
    1 AS is_current -- Updated column name
FROM dbo.Staging_Customers STG
LEFT JOIN DimCustomers DIM
    ON STG.CustomerID = DIM.customer_id_nk
WHERE DIM.customer_id_nk IS NULL;



SELECT
    STG.CustomerID,
    STG.CompanyName
FROM dbo.Staging_Customers STG
LEFT JOIN DimCustomers DIM
    ON STG.CustomerID = DIM.customer_id_nk
WHERE DIM.customer_id_nk IS NULL;
