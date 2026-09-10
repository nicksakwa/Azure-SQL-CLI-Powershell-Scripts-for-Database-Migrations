ALTER DATABASE [WideWorldImporters] SET AUTOMATIC_TUNING (FORCE_LAST_GOOD_PLAN = ON);

SELECT 
    name,
    desired_state_desc,
    reason_desc
FROM sys.database_automatic_tuning_options
    
ALTER DATABASE [WideWorldImportersDW] SET COMPATIBILITY_LEVEL = 150;