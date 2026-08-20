CREATE OR ALTER PROCEDURE Sales.DemoProc
AS
DECLARE @sqlstring NVARCHAR(MAX)

SET @sqlstring = N '
SELECT P.Name,
    SUM(SOD.LineTotal) AS TotalSales,
    SOH.OrderDate
FROM Production.Products P
    INNER JOIN Sales.SalesOrderDetail SOD ON (SOD.ProductID = P.Product.ID)
    INNER JOIN Sales.SalesOrderHeader SOH ON (SOH.SalesOrderID = SOD.SalesOrderID)
GROUP BY P.Name,
    SOH.OrderDate'

EXEC sp_executesql @sqlstring
GO

--
EXECUTE AS USER = 'DP300User1';
EXEC Sales.DemoProc;