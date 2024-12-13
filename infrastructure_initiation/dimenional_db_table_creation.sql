USE ORDER_DDS;


-- DimCategories
CREATE TABLE dbo.DimCategories (
    category_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    category_id_nk INT NOT NULL,
    category_name NVARCHAR(100),
    cat_description NVARCHAR(255),
    is_active BIT DEFAULT 1,
    sor_key NVARCHAR(255) 
);

-- DimCustomers
CREATE TABLE dbo.DimCustomers (
    customer_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    customer_id_nk INT NOT NULL,
    customer_name NVARCHAR(100),
    contact_name NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(50),
    region NVARCHAR(50),
    postal_code NVARCHAR(20),
    country NVARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT DEFAULT 1,
    sor_key NVARCHAR(255) 
);

-- DimEmployees
CREATE TABLE dbo.DimEmployees (
    employee_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    employee_id_nk INT NOT NULL,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    title NVARCHAR(100),
    reports_to INT NULL,
    active_status NVARCHAR(20),
    is_active BIT DEFAULT 1,
    sor_key NVARCHAR(255) 
);

CREATE TABLE dbo.OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    Quantity SMALLINT NOT NULL,
    Discount FLOAT NOT NULL,
    sor_key NVARCHAR(255), 
    PRIMARY KEY (OrderID, ProductID), 
    FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);

-- DimProducts
CREATE TABLE dbo.DimProducts (
    product_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    product_id_nk INT NOT NULL,
    product_name NVARCHAR(100),
    supplier_id INT,
    category_id INT,
    quantity_per_unit NVARCHAR(50),
    unit_price DECIMAL(10, 2),
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued BIT,
    sor_key NVARCHAR(255) 
);

-- DimRegion
CREATE TABLE dbo.DimRegion (
    region_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    region_id_nk INT NOT NULL,
    region_description NVARCHAR(255),
    sor_key NVARCHAR(255) 
);

-- DimShippers
CREATE TABLE dbo.DimShippers (
    shipper_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    shipper_id_nk INT NOT NULL,
    company_name NVARCHAR(255),
    phone NVARCHAR(50),
    sor_key NVARCHAR(255) 
);

-- DimSuppliers
CREATE TABLE dbo.DimSuppliers (
    supplier_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id_nk INT NOT NULL,
    company_name NVARCHAR(255),
    contact_name NVARCHAR(100),
    contact_title NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(50),
    region NVARCHAR(50),
    postal_code NVARCHAR(20),
    country NVARCHAR(50),
    phone NVARCHAR(50),
    fax NVARCHAR(50),
    sor_key NVARCHAR(255) 
);

-- DimTerritories
CREATE TABLE dbo.DimTerritories (
    territory_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    territory_id_nk NVARCHAR(20) NOT NULL,
    territory_description NVARCHAR(255),
    region_id_nk INT,
    sor_key NVARCHAR(255), 
    FOREIGN KEY (region_id_nk) REFERENCES dbo.DimRegion(region_id_sk)
);


-- FactOrders 
CREATE TABLE FactOrders (
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
    FOREIGN KEY (customer_id_sk) REFERENCES DimCustomers(customer_id_sk),
    FOREIGN KEY (employee_id_sk) REFERENCES DimEmployees(employee_id_sk),
    FOREIGN KEY (shipper_id_sk) REFERENCES DimShippers(shipper_id_sk),
    FOREIGN KEY (product_id_sk) REFERENCES DimProducts(product_id_sk)
);

ALTER TABLE FactOrders ADD CONSTRAINT UQ_FactOrders_order_id_nk UNIQUE (order_id_nk);



CREATE TABLE dbo.FactOrders_Error (
    fact_error_id INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_id INT NOT NULL,
    source_table_name NVARCHAR(255) NOT NULL,
    error_reason NVARCHAR(255) NOT NULL,
    order_id INT,
    product_id INT,
    customer_id NVARCHAR(5),
    employee_id INT,
    ship_via INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    freight MONEY,
    ship_name NVARCHAR(255),
    ship_address NVARCHAR(255),
    ship_city NVARCHAR(50),
    ship_region NVARCHAR(50),
    ship_postal_code NVARCHAR(20),
    ship_country NVARCHAR(50),
    sor_key NVARCHAR(255),
    error_timestamp DATETIME DEFAULT GETDATE()
);
