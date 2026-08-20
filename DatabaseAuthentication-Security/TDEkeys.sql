USE master; GO
-- Create a master key for the database
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourPassword'; GO

-- Create a certificate for TDE
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'TDEdemo Certificate'; GO

-- Create a DB encryption key and protect it by the certificate
USE [TDEdemo]; GO
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256 ENCRYPTION BY SERVER CERTIFICATE MyServerCert; GO

-- Enable TDE for the DB
ALTER DATABASE [TDEdemo] SET ENCRYPTION ON; GO


