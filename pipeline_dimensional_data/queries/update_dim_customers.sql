DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Customers_Staging';

INSERT INTO DimCustomers (
    CustomerID, CompanyName, ContactName, ContactTitle, Address, City, 
    Region, PostalCode, Country, Phone, Fax, StartDate, EndDate, CurrentIndicator
)
SELECT 
    C.CustomerID,
    C.CompanyName,
    C.ContactName,
    C.ContactTitle,
    C.Address,
    C.City,
    C.Region,
    C.PostalCode,
    C.Country,
    C.Phone,
    C.Fax,
    GETDATE(),
    '9999-12-31',
    1
FROM 
    Customers_Staging C
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);
