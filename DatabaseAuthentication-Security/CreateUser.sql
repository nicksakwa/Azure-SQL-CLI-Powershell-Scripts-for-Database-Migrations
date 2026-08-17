-- create user in DB External not in master for AZ DB auth
CREATE USER [dba@constos.com] FROM EXTERNAL PROVIDER;
GO

-- create user at SQL instance level
USE [master]
GO

CREATE LOGIN demo WITH PASSWORD ='YourPassword'
GO

USE [WorldWideImporters]
GO

CREATE USER demo FOR LOGIN demo
GO