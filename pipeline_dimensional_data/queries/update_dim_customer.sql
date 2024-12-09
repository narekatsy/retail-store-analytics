USE ORDER_DDS;

INSERT INTO DimCustomers (
    customer_id_nk,
    customer_name,
    contact_name,
    address,
    city,
    region,
    postal_code,
    country,
    is_current 
)
SELECT
    STG.CustomerID,
    STG.CompanyName, 
    STG.ContactName,
    STG.Address,
    STG.City,
    STG.Region,
    STG.PostalCode,
    STG.Country,
    1 AS is_current 
FROM dbo.Staging_Customers STG
LEFT JOIN DimCustomers DIM
    ON STG.CustomerID = DIM.customer_id_nk
WHERE DIM.customer_id_nk IS NULL;


