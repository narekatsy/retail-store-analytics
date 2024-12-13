USE ORDER_DDS;

-- Categories
CREATE TABLE dbo.Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
    Picture VARBINARY(MAX)
);

CREATE TABLE dbo.Staging_Categories (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(50),
    Description NVARCHAR(MAX),
    Picture VARBINARY(MAX)
);

-- Customers
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

-- Employees
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

-- Prder Details
CREATE TABLE dbo.OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY NOT NULL,
    Quantity SMALLINT NOT NULL,
    Discount REAL NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);

CREATE TABLE dbo.Staging_OrderDetails (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity SMALLINT,
    Discount REAL
);

-- Orders
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

-- Products
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

-- Region
CREATE TABLE dbo.Region (
    RegionID INT PRIMARY KEY,
    RegionDescription NVARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Staging_Region (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(50)
);

-- Shippers
CREATE TABLE dbo.Shippers (
    ShipperID INT PRIMARY KEY,
    CompanyName NVARCHAR(40) NOT NULL,
    Phone NVARCHAR(24)
);

CREATE TABLE dbo.Staging_Shippers (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(40),
    Phone NVARCHAR(24)
);

-- Suppliers
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

-- Territories
CREATE TABLE dbo.Territories (
    TerritoryID NVARCHAR(20) PRIMARY KEY,
    TerritoryDescription NVARCHAR(50) NOT NULL,
    RegionID INT NOT NULL
);

CREATE TABLE dbo.Staging_Territories (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(50),
    RegionID INT
);

-- FactOrders


-- Create FactOrders table
CREATE TABLE dbo.FactOrders (
    fact_order_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    order_id_nk INT NOT NULL,
    product_id_sk INT NOT NULL,
    order_date DATE NOT NULL,
    customer_id_sk INT NOT NULL,
    employee_id_sk INT,
    shipper_id_sk INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    discount FLOAT,
    total_price AS (quantity * unit_price * (1 - discount)) PERSISTED,
    sor_key NVARCHAR(255),
    FOREIGN KEY (customer_id_sk) REFERENCES dbo.DimCustomers(customer_id_sk),
    FOREIGN KEY (employee_id_sk) REFERENCES dbo.DimEmployees(employee_id_sk),
    FOREIGN KEY (shipper_id_sk) REFERENCES dbo.DimShippers(shipper_id_sk),
    FOREIGN KEY (product_id_sk) REFERENCES dbo.DimProducts(product_id_sk)
);

ALTER TABLE dbo.FactOrders ADD CONSTRAINT UQ_FactOrders_order_id_nk UNIQUE (order_id_nk);

--Staging FactOrders
CREATE TABLE dbo.Staging_FactOrders (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    EmployeeID INT,
    ShipVia INT,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Discount FLOAT NOT NULL,
    LoadTimestamp DATETIME DEFAULT GETDATE()
);


-- Fact_error

CREATE TABLE dbo.DimFactOrders_Error (
    OrderID INT,
    ProductID INT,
    CustomerID NVARCHAR(5),
    EmployeeID INT,
    ShipVia INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    Freight MONEY,
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(50),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    LoadTimestamp DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.Staging_FactOrders_Error (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    CustomerID NVARCHAR(5),
    EmployeeID INT,
    ShipVia INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    Freight MONEY,
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(50),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    LoadTimestamp DATETIME DEFAULT GETDATE()
);