USE ORDER_DDS;

INSERT INTO DimOrderDetails (
    order_id_nk,
    product_id_nk,
    current_order_quantity,
    prior_order_quantity,
    change_date
)
SELECT
    STG.OrderID,
    STG.ProductID,
    STG.Quantity AS current_order_quantity, 
    NULL AS prior_order_quantity,
    GETDATE() AS change_date
FROM dbo.Staging_OrderDetails STG
LEFT JOIN DimOrderDetails DIM
    ON STG.OrderID = DIM.order_id_nk
    AND STG.ProductID = DIM.product_id_nk
WHERE DIM.order_id_nk IS NULL;
