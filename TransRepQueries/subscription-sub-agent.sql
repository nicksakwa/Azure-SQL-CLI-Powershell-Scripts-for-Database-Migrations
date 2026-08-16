USE [AdventureWorks]
GO

EXEC sp_addsubscription
    @publication = N'AdventureWorks_TransactionalPublication', 
    @subscriber = N'AdventureWorksSubscriber', 
    @destination_db = N'AdventureWorksSubscriber', 
    @subscription_type = N'Push', 
    @sync_type = N'automatic', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0,

exec sp_addpushsubscription_agent
    @publication = N'AdventureWorks_TransactionalPublication', 
    @subscriber = N'AdventureWorksSubscriber', 
    @subscriber_db = N'AdventureWorksSubscriber', 
    @job_login = null, 
    @job_password = null, 
    @subscriber_security_mode = 0,
    @subscriber_login = null,
    @subscriber_password = null,
    @frequency_type = 64,
    @frequency_interval = 1,
    @frequency_relative_interval = 1,
    @frequency_recurrence_factor = 0,
    @frequency_subday = 4,
    @frequency_subday_interval = 5,
    @active_start_time_of_day = 0,
    @active_end_time_of_day = 235959,
    @active_start_date = 0,
    @active_end_date = 0,
    @dts_package_location = N'Distributor'
GO

