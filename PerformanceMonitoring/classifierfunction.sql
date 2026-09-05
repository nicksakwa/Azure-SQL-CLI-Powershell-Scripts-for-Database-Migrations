-- creates User Defined Function (UDF) with the dbo schema
CREATE FUNCTION dbo.RGClassifier()

-- Built in SQL datatype SYSNAME like nvarchar(128)
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
DECLARE @WorkloadGroup AS SYSNAME;

--check if suser login name matches Report User is the UD workload group
IF(SUSER_NAME()='ReporterUser')
    SET @WorkloadGroup='ReporterServerGroup'
ELSE IF (SUSER_NAME()='PrimaryUser')
    SET @WorkloadGroup='PrimaryServerGroup'
ELSE
    SET @WorkloadGroup='DefaultServerGroup'
RETURN @WorkloadGroup
END