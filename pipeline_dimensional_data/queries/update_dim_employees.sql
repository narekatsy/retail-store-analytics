DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Employees_Staging';

INSERT INTO DimEmployees (
    EmployeeID, LastName, FirstName, TitleOfCourtesy, BirthDate, HireDate, Address, City, 
    Region, PostalCode, Country, Notes, ReportsTo, PhotoPath, StartDate, EndDate, IsDeleted
)
SELECT 
    E.EmployeeID,
    E.LastName,
    E.FirstName,
    E.TitleOfCourtesy,
    E.BirthDate,
    E.HireDate,
    E.Address,
    E.City,
    E.Region,
    E.PostalCode,
    E.Country,
    E.Notes,
    E.ReportsTo,
    E.PhotoPath,
    GETDATE(),
    '9999-12-31',
    0
FROM 
    Employees_Staging E
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);

INSERT INTO DimEmployees_MiniDimension (
    EmployeeKey, Title, HomePhone, Extension
)
SELECT 
    DE.EmployeeKey,
    E.Title,
    E.HomePhone,
    E.Extension
FROM 
    Employees_Staging E
JOIN 
    DimEmployees DE ON E.EmployeeID = DE.EmployeeID
WHERE 
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);
