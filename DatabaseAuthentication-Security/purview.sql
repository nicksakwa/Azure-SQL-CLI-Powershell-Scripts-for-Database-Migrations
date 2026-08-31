CREATE user <purview-account> FROM EXTERNAL PROVIDER; GO
EXEC sp_addrolemember 'db_owner', '<purview-account>'; GO