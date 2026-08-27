-- Creating Sales table with data for tenant users

CREATE TABLE [SALES](SalesID INT,
    ProductID INT,
    TenantName NVARCHAR(10)
    OrderQtd INT,
    UnitPrice MONEY
)
GO

INSERT INTO [Sales] VALUES (1, 3, 'Tenant1', 5, 10.00);
INSERT INTO [Sales] VALUES (2, 4, 'Tenant1', 2, 57.00);
INSERT INTO [Sales] VALUES (3, 3, 'Tenant1', 5, 10.00);
INSERT INTO [Sales] VALUES (4, 4, 'Tenant1', 2, 57.00);
INSERT INTO [Sales] VALUES (5, 3, 'Tenant1', 5, 10.00);
INSERT INTO [Sales] VALUES (6, 4, 'Tenant1', 2, 57.00);
INSERT INTO [Sales] VALUES (7, 4, 'Tenant1', 2, 57.00);

SELECT * FROM Sales;

-- creating tenant users
CREATE USER [TenantAdmin] WITH PASSWORD ='' GO

CREATE USER [Tenant1] WITH PASSWORD ='' GO
CREATE USER [Tenant2] WITH PASSWORD ='' GO
CREATE USER [Tenant3] WITH PASSWORD ='' GO
CREATE USER [Tenant4] WITH PASSWORD ='' GO

GRANT SELECT [Sales] TO [TenantAdmin] GO

GRANT SELECT [Sales] TO [Tenant1] GO
GRANT SELECT [Sales] TO [Tenant2] GO
GRANT SELECT [Sales] TO [Tenant3] GO
GRANT SELECT [Sales] TO [Tenant4] GO

-- Create Schema
CREATE SCHEMA sec; GO

-- Create the filter functions
CREATE FUNCTION sec.tvf_SecurityPredicatebyTenant(@TenantName AS NVARCHAR(10))
    RETURNS TABLE
WITH SCHEMABINDING
AS 
    RETURN SELECT 1 AS result
        WHERE @TenantName = USER_NAME() OR USER_NAME() = 'TenantAdmin'; GO

-- Create selection permissions to Tenant users
GRANT SELECT ON sec.tvf_SecurityPredicatebyTenant TO [TenantAdmin] GO
GRANT SELECT ON sec.tvf_SecurityPredicatebyTenant TO [Tenant1] GO
GRANT SELECT ON sec.tvf_SecurityPredicatebyTenant TO [Tenant2] GO
GRANT SELECT ON sec.tvf_SecurityPredicatebyTenant TO [Tenant3] GO
GRANT SELECT ON sec.tvf_SecurityPredicatebyTenant TO [Tenant4] GO