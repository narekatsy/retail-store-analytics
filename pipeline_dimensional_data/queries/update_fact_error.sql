
DECLARE @start_date DATE = '2024-01-01'; 
DECLARE @end_date DATE = '2024-12-31';   

-- Insert faulty rows into FactOrders_Error
INSERT INTO ORDER_DDS.dbo.FactOrders_Error (
    order_id, 
    product_id, 
    customer_id, 
    employee_id, 
    error_reason
)
SELECT
    ORD.OrderID,
    ODT.ProductID,
    ORD.CustomerID,
    ORD.EmployeeID,
    CASE
        WHEN DIMC.customer_id_sk IS NULL THEN 'Missing Customer FK'
        WHEN DIME.employee_id_sk IS NULL THEN 'Missing Employee FK'
        WHEN DIMP.product_id_sk IS NULL THEN 'Missing Product FK'
        ELSE 'Unknown Error'
    END AS error_reason
FROM ORDER_DDS.dbo.Staging_Orders ORD
JOIN ORDER_DDS.dbo.Staging_OrderDetails ODT
    ON ORD.OrderID = ODT.OrderID
LEFT JOIN ORDER_DDS.dbo.DimCustomers DIMC
    ON DIMC.customer_id_nk = ORD.CustomerID
LEFT JOIN ORDER_DDS.dbo.DimEmployees DIME
    ON DIME.employee_id_nk = ORD.EmployeeID
LEFT JOIN ORDER_DDS.dbo.DimProducts DIMP
    ON ODT.ProductID = DIMP.product_id_nk
WHERE ORD.OrderDate BETWEEN @start_date AND @end_date
  AND (DIMC.customer_id_sk IS NULL
       OR DIME.employee_id_sk IS NULL
       OR DIMP.product_id_sk IS NULL);
