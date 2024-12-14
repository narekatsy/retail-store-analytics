USE ORDER_DDS;

DROP TABLE IF EXISTS OrderDetails_Staging;
DROP TABLE IF EXISTS Orders_Staging;
DROP TABLE IF EXISTS Products_Staging;
DROP TABLE IF EXISTS Territories_Staging;
DROP TABLE IF EXISTS Shippers_Staging;
DROP TABLE IF EXISTS Suppliers_Staging;
DROP TABLE IF EXISTS Region_Staging;
DROP TABLE IF EXISTS Employees_Staging;
DROP TABLE IF EXISTS Customers_Staging;
DROP TABLE IF EXISTS Categories_Staging;

-- Table: Categories
CREATE TABLE Categories_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(50),
    Description NVARCHAR(150)
);

-- Table: Customers
CREATE TABLE Customers_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(10),
    CompanyName NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(100),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Region NVARCHAR(20),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30)
);

-- Table: Employees
CREATE TABLE Employees_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    Title NVARCHAR(100),
    TitleOfCourtesy NVARCHAR(10),
    BirthDate DATE,
    HireDate DATE,
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Region NVARCHAR(20),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    HomePhone NVARCHAR(30),
    Extension NVARCHAR(10),
	Notes NVARCHAR(500),
    ReportsTo INT,
	PhotoPath NVARCHAR(150)
);

-- Table: Region
CREATE TABLE Region_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(100),
	RegionCategory NVARCHAR(20),
	RegionImportance NVARCHAR(20)
);

-- Table: Suppliers
CREATE TABLE Suppliers_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    CompanyName NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(100),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Region NVARCHAR(20),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    Phone NVARCHAR(20),
    Fax NVARCHAR(20),
    HomePage NVARCHAR(150)
);

-- Table: Shippers
CREATE TABLE Shippers_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(100),
    Phone NVARCHAR(20)
);

-- Table: Territories
CREATE TABLE Territories_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(50),
	TerritoryCode NVARCHAR(10),
    RegionID INT
);

-- Table: Products
CREATE TABLE Products_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice MONEY,
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- Table: Orders
CREATE TABLE Orders_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID NVARCHAR(10),
    EmployeeID INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipVia INT,
    Freight MONEY,
    ShipName NVARCHAR(100),
    ShipAddress NVARCHAR(150),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(30),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    TerritoryID INT
);

-- Table: Order Details
CREATE TABLE OrderDetails_Staging (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity SMALLINT,
    Discount REAL
);
