-- Create Purview account user and assign db_owner role
CREATE user <purview-account> FROM EXTERNAL PROVIDER; GO
EXEC sp_addrolemember 'db_owner', '<purview-account>'; GO

CREATE MASTER KEY 
GO