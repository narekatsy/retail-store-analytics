USE ORDER_DDS;

INSERT INTO DimCategories (
    category_id_nk,
    category_name,
    cat_description,
    is_active
)
SELECT
    STG.CategoryID,
    STG.CategoryName,
    STG.Description,
    1 AS is_active
FROM dbo.Staging_Categories STG
LEFT JOIN DimCategories DIM
    ON STG.CategoryID = DIM.category_id_nk
WHERE DIM.category_id_nk IS NULL;
