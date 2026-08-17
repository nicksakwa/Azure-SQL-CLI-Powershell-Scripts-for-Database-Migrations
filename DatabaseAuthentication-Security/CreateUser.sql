-- create user in DB External not in master for AZ DB auth
CREATE USER [dba@constos.com] FROM EXTERNAL PROVIDER;
GO

-- create user at SQL instance level
USE [master]
GO
CREATE LOGIN demo WITH PASSWORD ='YourPassword';
USE [WorldWideImporters]
GO
CREATE USER demo FOR LOGIN demo;

-- create DB roles
CREATE USER [DP300User1] WITH PASSWORD = 'YourPassword1';
CREATE USER [DP300User2] WITH PASSWORD = 'YourPassword2';
CREATE ROLE [SalesReader];
ALTER ROLE [SalesReader] ADD MEMBER [DP300User1];
ALTER ROLE [SalesReader] ADD MEMBER [DP300User2];
GRANT SELECT ON SCHEMA::Sales TO [SalesReader];