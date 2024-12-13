USE ORDER_DDS;

DECLARE @SourceTableName NVARCHAR(255) = 'Staging_Employees';

INSERT INTO dbo.Dim_SOR (source_table_name, source_key)
SELECT DISTINCT
    @SourceTableName, CAST(ST.StagingID AS NVARCHAR)
FROM dbo.Staging_Employees AS ST
LEFT JOIN dbo.Dim_SOR AS DS
    ON DS.source_table_name = @SourceTableName AND DS.source_key = CAST(ST.StagingID AS NVARCHAR)
WHERE DS.sor_key IS NULL;

-- Insert
INSERT INTO dbo.Employees (
    EmployeeID,
    LastName,
    FirstName,
    Title,
    TitleOfCourtesy,
    BirthDate,
    HireDate,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    HomePhone,
    Extension,
    Photo,
    Notes,
    ReportsTo
)
SELECT 
    ST.EmployeeID,
    ST.LastName,
    ST.FirstName,
    ST.Title,
    ST.TitleOfCourtesy,
    ST.BirthDate,
    ST.HireDate,
    ST.Address,
    ST.City,
    ST.Region,
    ST.PostalCode,
    ST.Country,
    ST.HomePhone,
    ST.Extension,
    ST.Photo,
    ST.Notes,
    ST.ReportsTo
FROM dbo.Staging_Employees AS ST
LEFT JOIN dbo.Employees AS E
    ON E.EmployeeID = ST.EmployeeID 
WHERE E.EmployeeID IS NULL;

-- Update
UPDATE E
SET 
    E.LastName = ST.LastName,
    E.FirstName = ST.FirstName,
    E.Title = ST.Title,
    E.TitleOfCourtesy = ST.TitleOfCourtesy,
    E.BirthDate = ST.BirthDate,
    E.HireDate = ST.HireDate,
    E.Address = ST.Address,
    E.City = ST.City,
    E.Region = ST.Region,
    E.PostalCode = ST.PostalCode,
    E.Country = ST.Country,
    E.HomePhone = ST.HomePhone,
    E.Extension = ST.Extension,
    E.Photo = ST.Photo,
    E.Notes = ST.Notes,
    E.ReportsTo = ST.ReportsTo
FROM dbo.Employees AS E
INNER JOIN dbo.Staging_Employees AS ST
    ON E.EmployeeID = ST.EmployeeID
WHERE 
    E.LastName <> ST.LastName OR
    E.FirstName <> ST.FirstName OR
    E.Title <> ST.Title OR
    E.TitleOfCourtesy <> ST.TitleOfCourtesy OR
    E.BirthDate <> ST.BirthDate OR
    E.HireDate <> ST.HireDate OR
    E.Address <> ST.Address OR
    E.City <> ST.City OR
    E.Region <> ST.Region OR
    E.PostalCode <> ST.PostalCode OR
    E.Country <> ST.Country OR
    E.HomePhone <> ST.HomePhone OR
    E.Extension <> ST.Extension OR
    E.Photo <> ST.Photo OR
    E.Notes <> ST.Notes OR
    E.ReportsTo <> ST.ReportsTo;

-- Delete
DELETE FROM dbo.Employees
WHERE EmployeeID NOT IN (
    SELECT ST.EmployeeID
    FROM dbo.Staging_Employees AS ST
);
