USE ORDER_DDS;

INSERT INTO DimRegion (
    region_id_nk, -- Natural Key
    region_description,
    current_region_description,
    prior_region_description,
    change_date
)
SELECT
    STG.RegionID,
    STG.RegionDescription,
    STG.RegionDescription AS current_region_description, -- Assuming same value for new records
    NULL AS prior_region_description, -- No prior value for new records
    GETDATE() AS change_date
FROM dbo.Staging_Region STG
LEFT JOIN DimRegion DIM
    ON STG.RegionID = DIM.region_id_nk
WHERE DIM.region_id_nk IS NULL;
