USE ORDER_DDS;

INSERT INTO DimProducts (
    product_id_nk, -- Natural Key
    product_name,
    category_id,
    supplier_id,
    unit_price,
    quantity_per_unit,
    is_active
)
SELECT
    STG.ProductID,
    STG.ProductName,
    STG.CategoryID,
    STG.SupplierID,
    STG.UnitPrice,
    STG.QuantityPerUnit,
    1 AS is_active
FROM dbo.Staging_Products STG
LEFT JOIN DimProducts DIM
    ON STG.ProductID = DIM.product_id_nk
WHERE DIM.product_id_nk IS NULL;
