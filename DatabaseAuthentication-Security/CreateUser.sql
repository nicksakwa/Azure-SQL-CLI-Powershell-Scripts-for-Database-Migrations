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

-- create OR alter procedures
CREATE OR ALTER PROCEDURE Sales.DemoProc
AS 
SELECT P.Name,
    SUM(SOD.LineTotal) AS TotalSales,
    SOH.OrderDate
FROM Production.Products P
    INNER JOIN Sales.SalesOrderDetail SOD ON (SOD.ProductID = P.ProductID)
    INNER JOIN Sales.SalesOrderHeader SOH ON (SOH.SalesOrderID= SOD.SalesOrderID)
GROUP BY P.Name,
    SOH.OrderDate
ORDER BY TotalSales DESC;
GO

EXEC AS USER = 'DP300User1';

SELECT P.Name,
    SUM(SOD.LineTotal) AS TotalSales,
    SOH.OrderDate
FROM Production.Products P
    INNER JOIN Sales.SalesOrderDetail SOD ON (SOD.ProductID = P.ProductID)
    INNER JOIN Sales.SalesOrderHeader SOH ON (SOH.SalesOrderID= SOD.SalesOrderID)
GROUP BY P.Name,
    SOH.OrderDate
ORDER BY TotalSales DESC;
    