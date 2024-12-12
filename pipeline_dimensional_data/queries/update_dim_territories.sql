USE ORDER_DDS;

INSERT INTO DimTerritories(
    territory_id_nk,
    territory_description,
    current_territory_description,
    prior_territory_description,
    change_date
)
SELECT
    STG.TerritoryID,
    STG.TerritoryDescription,
    STG.TerritoryDescription AS current_territory_description, 
    NULL AS prior_territory_description,
    GETDATE() AS change_date
FROM dbo.Staging_Territories STG
LEFT JOIN DimTerritories DIM
    ON STG.TerritoryID = DIM.territory_id_nk
WHERE DIM.territory_id_nk IS NULL;

