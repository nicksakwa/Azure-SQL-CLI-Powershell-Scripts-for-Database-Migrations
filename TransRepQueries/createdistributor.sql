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