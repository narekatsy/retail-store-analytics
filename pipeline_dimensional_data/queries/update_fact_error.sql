USE ORDER_DDS;

-- Declare the variables for the date range
DECLARE @start_date DATE = '2004-01-01'; -- Replace with your desired start date
DECLARE @end_date DATE = '2024-12-31';   -- Replace with your desired end date

-- Insert rows with missing foreign keys into FactOrders_Error
INSERT INTO FactOrders_Error (
    order_id,
    customer_id,
    employee_id,
    product_id,
    error_reason
)
SELECT
    ORD.OrderID,
    ORD.CustomerID,
    ORD.EmployeeID,
    ODT.ProductID,
    CASE
        WHEN DIMC.customer_id_sk IS NULL THEN 'Missing Customer FK'
        WHEN DIME.employee_id_sk IS NULL THEN 'Missing Employee FK'
        WHEN DIMP.product_id_sk IS NULL THEN 'Missing Product FK'
        ELSE 'Unknown Error'
    END AS error_reason
FROM dbo.Staging_Orders ORD
JOIN dbo.Staging_OrderDetails ODT
    ON ORD.OrderID = ODT.OrderID
LEFT JOIN DimCustomers DIMC
    ON DIMC.customer_id_nk = ORD.CustomerID
LEFT JOIN DimEmployees DIME
    ON DIME.employee_id_nk = ORD.EmployeeID
LEFT JOIN DimProducts DIMP
    ON DIMP.product_id_nk = ODT.ProductID
WHERE ORD.OrderDate BETWEEN @start_date AND @end_date
  AND (DIMC.customer_id_sk IS NULL
       OR DIME.employee_id_sk IS NULL
       OR DIMP.product_id_sk IS NULL);

