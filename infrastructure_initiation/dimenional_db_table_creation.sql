USE ORDER_DDS;

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Employee_MiniDim')
    ALTER TABLE DimEmployees_MiniDimension DROP CONSTRAINT IF EXISTS FK_Employee_MiniDim;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Supplier_MiniDim')
    ALTER TABLE DimSuppliers_MiniDimension DROP CONSTRAINT IF EXISTS FK_Supplier_MiniDim;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Product_MiniDim')
    ALTER TABLE DimProducts_MiniDimension DROP CONSTRAINT IF EXISTS FK_Product_MiniDim;

DROP TABLE IF EXISTS FactOrderDetails;
DROP TABLE IF EXISTS FactOrders;
DROP TABLE IF EXISTS DimProducts_MiniDimension;
DROP TABLE IF EXISTS DimProducts;
DROP TABLE IF EXISTS DimSuppliers_MiniDimension;
DROP TABLE IF EXISTS DimSuppliers;
DROP TABLE IF EXISTS DimEmployees_MiniDimension;
DROP TABLE IF EXISTS DimEmployees;
DROP TABLE IF EXISTS DimShippers;
DROP TABLE IF EXISTS DimTerritories;
DROP TABLE IF EXISTS DimRegion;
DROP TABLE IF EXISTS DimCustomers;
DROP TABLE IF EXISTS DimCategories;
DROP TABLE IF EXISTS Dim_SOR;

-- Dim_SOR (Source system reference)
CREATE TABLE Dim_SOR (
    SORKey INT IDENTITY(1,1) PRIMARY KEY,
    SORName NVARCHAR(100),
    SORModule NVARCHAR(100),
    SORTable NVARCHAR(100),
    StagingRawTableName NVARCHAR(100)
);

-- DimCategories (SCD1 with delete, logical deletion)
CREATE TABLE DimCategories (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT UNIQUE,
    CategoryName NVARCHAR(50),
    Description NVARCHAR(150),
    IsDeleted BIT DEFAULT 0
);

-- DimCustomers (SCD2, track history)
CREATE TABLE DimCustomers (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(10) UNIQUE,
    CompanyName NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(100),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Region NVARCHAR(20),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30),
    StartDate DATE DEFAULT GETDATE(),
    EndDate DATE DEFAULT '9999-12-31',
    CurrentIndicator BIT DEFAULT 1
);

-- DimEmployees (SCD4, split into base and mini-dimensions)
CREATE TABLE DimEmployees (
	EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT UNIQUE,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    TitleOfCourtesy NVARCHAR(10),
    BirthDate DATE,
    HireDate DATE,
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Region NVARCHAR(20),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
	Notes NVARCHAR(500),
    ReportsTo INT,
	PhotoPath NVARCHAR(150),
    StartDate DATE DEFAULT GETDATE(),
    EndDate DATE DEFAULT '9999-12-31',
    IsDeleted BIT DEFAULT 0
);

-- DimEmployees_MiniDimension (for more rapidly changing attributes)
CREATE TABLE DimEmployees_MiniDimension (
    MiniDimKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeKey INT,
	Title NVARCHAR(100),
	HomePhone NVARCHAR(30),
    Extension NVARCHAR(10)    
);

ALTER TABLE DimEmployees_MiniDimension
    ADD CONSTRAINT FK_Employee_MiniDim FOREIGN KEY (EmployeeKey) REFERENCES DimEmployees(EmployeeKey);

-- DimRegion (SCD3, current and prior values)
CREATE TABLE DimRegion (
    RegionKey INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT UNIQUE,
    RegionDescription NVARCHAR(100),
	RegionCategory NVARCHAR(20),
	RegionImportance NVARCHAR(20),
    CurrentRegionDescription NVARCHAR(100),
    PriorRegionDescription NVARCHAR(100)
);

-- DimSuppliers (SCD4, split into base and mini-dimensions)
CREATE TABLE DimSuppliers (
    SupplierKey INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT UNIQUE,
    CompanyName NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(100),
    Address NVARCHAR(255),
    City NVARCHAR(50),
	Region NVARCHAR(20),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    StartDate DATE DEFAULT GETDATE(),
    EndDate DATE DEFAULT '9999-12-31'
);

-- DimSuppliers_MiniDimension (for more rapidly changing attributes)
CREATE TABLE DimSuppliers_MiniDimension (
    MiniDimKey INT IDENTITY(1,1) PRIMARY KEY,
    SupplierKey INT,
    Phone NVARCHAR(20),
    Fax NVARCHAR(20),
    HomePage NVARCHAR(150)
);

ALTER TABLE DimSuppliers_MiniDimension
    ADD CONSTRAINT FK_Supplier_MiniDim FOREIGN KEY (SupplierKey) REFERENCES DimSuppliers(SupplierKey);

-- DimShippers (SCD1, overwrite with delete)
CREATE TABLE DimShippers (
    ShipperKey INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT UNIQUE,
    CompanyName NVARCHAR(100),
    Phone NVARCHAR(20)
);

-- DimTerritories (SCD3, current and prior values)
CREATE TABLE DimTerritories (
    TerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20) UNIQUE,
    TerritoryDescription NVARCHAR(50),
    CurrentTerritoryDescription NVARCHAR(50),
    PriorTerritoryDescription NVARCHAR(50),
    RegionKey INT,
    FOREIGN KEY (RegionKey) REFERENCES DimRegion(RegionKey)
);

-- DimProducts (SCD4, split into base and mini-dimensions)
CREATE TABLE DimProducts (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT UNIQUE,
    ProductName NVARCHAR(100),
	SupplierKEY INT,
    CategoryKEY INT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- DimProducts_MiniDimension (for more rapidly changing attributes)
CREATE TABLE DimProducts_MiniDimension (
    MiniDimKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductKey INT,
	QuantityPerUnit NVARCHAR(50),
    UnitPrice MONEY,
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT
);

ALTER TABLE DimProducts_MiniDimension
    ADD CONSTRAINT FK_Product_MiniDim FOREIGN KEY (ProductKey) REFERENCES DimProducts(ProductKey);

-- FactOrders (Snapshot, no changes over time)
CREATE TABLE FactOrders (
    OrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT UNIQUE,
    CustomerKey INT,
    EmployeeKey INT,
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
	TerritoryKey INT,
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomers(CustomerKey),
    FOREIGN KEY (EmployeeKey) REFERENCES DimEmployees(EmployeeKey),
    FOREIGN KEY (TerritoryKey) REFERENCES DimTerritories(TerritoryKey),
);

-- FactOrderDetails (links orders and products)
CREATE TABLE FactOrderDetails (
    OrderDetailKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderKey INT,
    ProductKey INT,
    UnitPrice MONEY,
    Quantity SMALLINT,
    Discount REAL,
    FOREIGN KEY (OrderKey) REFERENCES FactOrders(OrderKey),
    FOREIGN KEY (ProductKey) REFERENCES DimProducts(ProductKey)
);
