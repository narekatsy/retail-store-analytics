USE ORDER_DDS;

DECLARE @start_date DATE = '2024-01-01';
DECLARE @end_date DATE = '2024-12-31';  

INSERT INTO FactOrders (
    order_id_nk, 
    product_id_nk, 
    order_date,
    customer_id, 
    employee_id, 
    shipper_id, 
    quantity,
    unit_price,
    discount
)
SELECT
    ORD.OrderID,
    ODT.ProductID,
    ORD.OrderDate,
    DIMC.customer_id_sk,
    DIME.employee_id_sk,
    DIMS.shipper_id_sk,
    ODT.Quantity,
    ODT.UnitPrice,
    ODT.Discount
FROM dbo.Staging_Orders ORD
JOIN dbo.Staging_OrderDetails ODT
    ON ORD.OrderID = ODT.OrderID
LEFT JOIN DimCustomers DIMC
    ON ORD.CustomerID = DIMC.customer_id_nk
LEFT JOIN DimEmployees DIME
    ON ORD.EmployeeID = DIME.employee_id_nk
LEFT JOIN DimShippers DIMS
    ON ORD.ShipVia = DIMS.shipper_id_nk
WHERE ORD.OrderDate BETWEEN @start_date AND @end_date;
