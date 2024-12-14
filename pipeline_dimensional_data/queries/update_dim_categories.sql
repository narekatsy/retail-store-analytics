DECLARE @SourceSystemKey INT;
DECLARE @SourceTableName NVARCHAR(100);

SET @SourceSystemKey = 1;
SET @SourceTableName = 'Categories_Staging';

INSERT INTO DimCategories (CategoryID, CategoryName, Description, IsDeleted)
SELECT
    C.CategoryID,
    C.CategoryName,
    C.Description,
    0
FROM
    Categories_Staging C
WHERE
    EXISTS (SELECT 1 FROM Dim_SOR S WHERE S.StagingRawTableName = @SourceTableName AND S.SORKey = @SourceSystemKey);
