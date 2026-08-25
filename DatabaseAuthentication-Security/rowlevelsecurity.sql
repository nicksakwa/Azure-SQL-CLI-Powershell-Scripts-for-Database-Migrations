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
