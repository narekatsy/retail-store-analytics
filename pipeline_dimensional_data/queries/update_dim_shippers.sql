USE ORDER_DDS;

INSERT INTO DimShipper (
    shipper_id_nk,
    shipper_name,
    current_shipper_name,
    prior_shipper_name,
    change_date
)
SELECT
    STG.ShipperID,
    STG.ShipperName,
    STG.ShipperName AS current_shipper_name, 
    NULL AS prior_shipper_name,
    GETDATE() AS change_date
FROM dbo.Staging_Shippers STG
LEFT JOIN DimShipper DIM
    ON STG.ShipperID = DIM.shipper_id_nk
WHERE DIM.shipper_id_nk IS NULL;


