USE [AdventureWorks]
GO

EXEC sp_addpublication
    @publication = N'AdventureWorks_TransactionalPublication',
    @description = N'Transactional publication of database ''AdventureWorks''.',
    @sync_method = N'concurrent_c', 
    @retention = 0, 
    @allow_push = N'true', 
    @allow_pull = N'true', 
    @allow_anonymous = N'true', 
    @enabled_for_internet = N'false', 
    @snapshot_in_defaultfolder = N'false', 
    @compress_snapshot = N'true', 
    @ftp_port = 21, 
    @ftp_login = N'anonymous', 
    @allow_subscription_copy = N'false', 
    @add_to_active_directory = N'false', 
    @repl_freq = N'continuous', 
    @status = N'active', 
    @independent_agent = N'true', 
    @immediate_sync = N'true', 
    @allow_sync_tran = N'false', 
    @autogen_sync_procs = N'false', 
    @allow_queued_tran = N'false', 
    @allow_dts = N'false', 
    @replicate_ddl = 1,
    @allow_initialize_from_backup = N'false',
    @enabled_for_p2p = N'false',
    @enabled_for_het_sub = N'false'
GO