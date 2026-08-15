USE [AdventureWorks]
GO

EXEC sp_addarticle
    @publication = N'AdventureWorks_TransactionalPublication', 
    @article = N'Person.Address', 
    @source_owner = N'Person', 
    @source_object = N'Address', 
    @type = N'logbased', 
    @description = null, 
    @creation_script = null, 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Address', 
    @destination_owner = N'Person',
    @status = 24, 
    @vertical_partition = N'false', 
    @ins_cmd = N'SQL', 
    @del_cmd = N'SQL', 
    @upd_cmd = N'SQL'
GO