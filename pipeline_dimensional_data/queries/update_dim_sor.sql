DECLARE @SORName NVARCHAR(100);
DECLARE @SORModule NVARCHAR(100);
DECLARE @SORTable NVARCHAR(100);
DECLARE @StagingRawTableName NVARCHAR(100);

-- Insert for DimCategories
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimCategories';
SET @StagingRawTableName = 'Categories_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimCustomers
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimCustomers';
SET @StagingRawTableName = 'Customers_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimEmployees
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimEmployees';
SET @StagingRawTableName = 'Employees_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimRegion
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimRegion';
SET @StagingRawTableName = 'Region_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimShippers
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimShippers';
SET @StagingRawTableName = 'Shippers_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimSuppliers
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimSuppliers';
SET @StagingRawTableName = 'Suppliers_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimTerritories
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimTerritories';
SET @StagingRawTableName = 'Territories_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimProducts
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'DimProducts';
SET @StagingRawTableName = 'Products_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for Dim_SOR (for fact tables)

-- Insert for DimFactOrders
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'FactOrders';
SET @StagingRawTableName = 'Orders_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);

-- Insert for DimFactOrderDetails
SET @SORName = 'SourceSystem1';
SET @SORModule = 'Module1';
SET @SORTable = 'FactOrderDetails';
SET @StagingRawTableName = 'OrderDetails_Staging';
INSERT INTO Dim_SOR (SORName, SORModule, SORTable, StagingRawTableName)
VALUES (@SORName, @SORModule, @SORTable, @StagingRawTableName);
