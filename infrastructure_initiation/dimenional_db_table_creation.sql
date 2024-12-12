-- Create Dim_SOR table
CREATE TABLE Dim_SOR (
    sor_key INT IDENTITY(1,1) PRIMARY KEY,
    source_table_name NVARCHAR(255),
    source_key NVARCHAR(255)
);

-- Create DimCategories table (SCD1 with delete)
CREATE TABLE DimCategories (
    category_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    category_id_nk INT NOT NULL,
    category_name NVARCHAR(100),
    cat_description NVARCHAR(255),
    is_active BIT DEFAULT 1 -- Active status for SCD1
);

-- Create DimCustomers table (SCD2)
CREATE TABLE DimCustomers (
    customer_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    customer_id_nk INT NOT NULL,
    customer_name NVARCHAR(100),
    contact_name NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(50),
    region NVARCHAR(50),
    postal_code NVARCHAR(20),
    country NVARCHAR(50),
    start_date DATE NOT NULL, -- SCD2 start date
    end_date DATE NULL, -- SCD2 end date (NULL for current records)
    is_current BIT DEFAULT 1 -- Flag for current record
);

-- Create DimEmployees table (SCD4 with delete)
CREATE TABLE DimEmployees (
    employee_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    employee_id_nk INT NOT NULL,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    title NVARCHAR(100),
    reports_to INT NULL,
    active_status NVARCHAR(20), -- For SCD4 (historical snapshots)
    is_active BIT DEFAULT 1 -- Active status
);

-- Create DimProducts table (SCD4)
CREATE TABLE DimProducts (
    product_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    product_id_nk INT NOT NULL,
    product_name NVARCHAR(100),
    supplier_id INT,
    category_id INT,
    quantity_per_unit NVARCHAR(50),
    unit_price DECIMAL(10, 2),
    is_active BIT DEFAULT 1,
    CONSTRAINT UQ_DimProducts_product_id_nk UNIQUE (product_id_nk) -- Unique constraint on natural key
);

-- Create DimRegion table (SCD3)
CREATE TABLE DimRegion (
    region_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    region_id_nk INT NOT NULL,
    region_description NVARCHAR(255),
    current_region_description NVARCHAR(255), -- Current value for SCD3
    prior_region_description NVARCHAR(255), -- Prior value for SCD3
    change_date DATE
);

-- Create DimShippers table (SCD1)
CREATE TABLE DimShippers (
    shipper_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    shipper_id_nk INT NOT NULL,
    company_name NVARCHAR(255),
    phone NVARCHAR(50),
    is_active BIT DEFAULT 1
);

-- Create DimSuppliers table (SCD4)
CREATE TABLE DimSuppliers (
    supplier_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id_nk INT NOT NULL,
    company_name NVARCHAR(255),
    contact_name NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(50),
    region NVARCHAR(50),
    postal_code NVARCHAR(20),
    country NVARCHAR(50),
    is_active BIT DEFAULT 1
);

-- Create DimTerritories table (SCD3)
CREATE TABLE DimTerritories (
    territory_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    territory_id_nk INT NOT NULL, 
    territory_description NVARCHAR(255),
    current_territory_description NVARCHAR(255), -- Current value for SCD3
    prior_territory_description NVARCHAR(255), -- Prior value for SCD3
    region_id_sk INT,
    change_date DATE,
    FOREIGN KEY (region_id_sk) REFERENCES DimRegion(region_id_sk) -- Reference surrogate key in DimRegion
);


-- Create FactOrders table (SNAPSHOT)
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
    FOREIGN KEY (customer_id_sk) REFERENCES DimCustomers(customer_id_sk),
    FOREIGN KEY (employee_id_sk) REFERENCES DimEmployees(employee_id_sk),
    FOREIGN KEY (shipper_id_sk) REFERENCES DimShippers(shipper_id_sk),
    FOREIGN KEY (product_id_sk) REFERENCES DimProducts(product_id_sk)
);

ALTER TABLE FactOrders ADD CONSTRAINT UQ_FactOrders_order_id_nk UNIQUE (order_id_nk);
