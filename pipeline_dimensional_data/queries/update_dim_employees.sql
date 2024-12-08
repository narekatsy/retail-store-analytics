USE ORDER_DDS;

INSERT INTO DimEmployees (
    employee_id_nk, 
    first_name,
    last_name,
    title,
    reports_to,
    active_status,
    is_active
)
SELECT
    STG.EmployeeID,
    STG.FirstName,
    STG.LastName,
    STG.Title,
    STG.ReportsTo,
    'Active' AS active_status, 
    1 AS is_active
FROM dbo.Staging_Employees STG
LEFT JOIN DimEmployees DIM
    ON STG.EmployeeID = DIM.employee_id_nk
WHERE DIM.employee_id_nk IS NULL;
