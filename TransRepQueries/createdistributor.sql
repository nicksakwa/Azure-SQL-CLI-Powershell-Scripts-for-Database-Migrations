USE [master]
GO
EXEC sp_adddistributor @distributor = N'contoso-srv', @password = N''
GO
EXEC sp_adddistributiondb
    @database = N'distribution',
    @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA',
    @data_file = N'distribution.MDF',
    @data_file_size = 13,
    @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA',
    @log_file = N'distribution_log.LDF',
    @log_file_size = 9,
    @min_distretention = 0,
    @max_dstretention = 72,
    @history_retention = 48,
    @deletebatch_size_xact = 5000,
    @deletebatch_size_cmd = 2000,
    @security_mode = 1
GO

-- Add distribution publisher
exec sp_adddistpublisher
    @publisher = N'constoso-srv',
    @distribution_db = N'distribution',
    @security_mode = 1,
    @working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\ReplData',
    @trusted = N'false',
    @thirdparty_flag = 0,
    @publisher_type = N'MSSQLSERVER'
GO

-- register subscriber
exec sp_addsubscriber
    @subscriber = N'constoso.database.windows.net',
    @type= 0,
    @description = N'azure sql database(target)',
GO

-- Enable DB replication
use master
exec sp_replicationdboption
    @dbname = N'adventureworks',
    @optname = N'publish',
    @value = N' true'
GO

-- Exec log reader agent
exec [AdventureWorks].sys.sp_addlogreader_agent
    @publisher_security_mode = 1
GO

-- Add queue reader agent
exec [AdventureWorks].sys.sp_adddistribution_agent
    @frompublisher = 1
GO
