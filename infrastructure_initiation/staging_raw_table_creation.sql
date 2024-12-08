
USE ORDER_DDS;
GO

CREATE TABLE dbo.Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
    Picture VARBINARY(MAX)
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Categories (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(50),
    Description NVARCHAR(MAX),
    Picture VARBINARY(MAX)
);

CREATE TABLE dbo.Customers (
    CustomerID NVARCHAR(5) PRIMARY KEY,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30),
    ContactTitle NVARCHAR(30),
    Address NVARCHAR(60),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(15),
    Phone NVARCHAR(24),
    Fax NVARCHAR(24)
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Customers (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(5),
    CompanyName NVARCHAR(40),
    ContactName NVARCHAR(30),
    ContactTitle NVARCHAR(30),
    Address NVARCHAR(60),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(15),
    Phone NVARCHAR(24),
    Fax NVARCHAR(24)
);
CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY,
    LastName NVARCHAR(20) NOT NULL,
    FirstName NVARCHAR(10) NOT NULL,
    Title NVARCHAR(30),
    TitleOfCourtesy NVARCHAR(25),
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(60),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(15),
    HomePhone NVARCHAR(24),
    Extension NVARCHAR(4),
    Photo VARBINARY(MAX),
    Notes NVARCHAR(MAX),
    ReportsTo INT
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Employees (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LastName NVARCHAR(20),
    FirstName NVARCHAR(10),
    Title NVARCHAR(30),
    TitleOfCourtesy NVARCHAR(25),
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(60),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(15),
    HomePhone NVARCHAR(24),
    Extension NVARCHAR(4),
    Photo VARBINARY(MAX),
    Notes NVARCHAR(MAX),
    ReportsTo INT
);
CREATE TABLE dbo.OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY NOT NULL,
    Quantity SMALLINT NOT NULL,
    Discount REAL NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_OrderDetails (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity SMALLINT,
    Discount REAL
);
CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID NVARCHAR(5),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight MONEY,
    ShipName NVARCHAR(40),
    ShipAddress NVARCHAR(60),
    ShipCity NVARCHAR(15),
    ShipRegion NVARCHAR(15),
    ShipPostalCode NVARCHAR(10),
    ShipCountry NVARCHAR(15)
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Orders (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID NVARCHAR(5),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight MONEY,
    ShipName NVARCHAR(40),
    ShipAddress NVARCHAR(60),
    ShipCity NVARCHAR(15),
    ShipRegion NVARCHAR(15),
    ShipPostalCode NVARCHAR(10),
    ShipCountry NVARCHAR(15)
);
CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(40) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(20),
    UnitPrice MONEY,
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Products (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(40),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(20),
    UnitPrice MONEY,
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);
CREATE TABLE dbo.Region (
    RegionID INT PRIMARY KEY,
    RegionDescription NVARCHAR(50) NOT NULL
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Region (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(50)
);
CREATE TABLE dbo.Shippers (
    ShipperID INT PRIMARY KEY,
    CompanyName NVARCHAR(40) NOT NULL,
    Phone NVARCHAR(24)
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Shippers (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(40),
    Phone NVARCHAR(24)
);
CREATE TABLE dbo.Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30),
    ContactTitle NVARCHAR(30),
    Address NVARCHAR(60),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(15),
    Phone NVARCHAR(24),
    Fax NVARCHAR(24),
    HomePage NVARCHAR(MAX)
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Suppliers (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    CompanyName NVARCHAR(40),
    ContactName NVARCHAR(30),
    ContactTitle NVARCHAR(30),
    Address NVARCHAR(60),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(15),
    Phone NVARCHAR(24),
    Fax NVARCHAR(24),
    HomePage NVARCHAR(MAX)
);
CREATE TABLE dbo.Territories (
    TerritoryID NVARCHAR(20) PRIMARY KEY,
    TerritoryDescription NVARCHAR(50) NOT NULL,
    RegionID INT NOT NULL
);

-- Staging table with IDENTITY
CREATE TABLE dbo.Staging_Territories (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(50),
    RegionID INT
);





