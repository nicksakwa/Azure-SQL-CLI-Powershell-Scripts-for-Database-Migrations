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
    @subscriber_type = 0

