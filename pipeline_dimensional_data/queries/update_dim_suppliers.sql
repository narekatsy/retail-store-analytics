DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Suppliers_Staging';

INSERT INTO DimSuppliers (
    SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, 
    PostalCode, Country, StartDate, EndDate
)
SELECT 
    S.SupplierID,
    S.CompanyName,
    S.ContactName,
    S.ContactTitle,
    S.Address,
    S.City,
    S.Region,
    S.PostalCode,
    S.Country,
    GETDATE(),
    '9999-12-31'
FROM 
    Suppliers_Staging S
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);

INSERT INTO DimSuppliers_MiniDimension (
    SupplierKey, Phone, Fax, HomePage
)
SELECT 
    DS.SupplierKey,
    S.Phone,
    S.Fax,
    S.HomePage
FROM 
    Suppliers_Staging S
JOIN 
    DimSuppliers DS ON S.SupplierID = DS.SupplierID
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);
