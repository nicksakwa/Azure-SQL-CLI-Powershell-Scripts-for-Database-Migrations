CREATE FUNCTION dbo.RGClassifier()
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
DECLARE @WorkloadGroup AS SYSNAME;
IF(SUSER_NAME()='ReporterUser')
    SET @WorkloadGroup='ReporterServerGroup'
ELSE IF (SUSER_NAME()='PrimaryUser')
    SET @WorkloadGroup='PrimaryServerGroup'
ELSE
    SET @WorkloadGroup='DefaultServerGroup'
RETURN @WorkloadGroup
END