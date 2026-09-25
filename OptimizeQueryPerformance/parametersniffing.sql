CREATE PROC GetAccountID (@Param INT)
AS
<other statements in procedure>
SELECT accountId FROM CustomerSales WHERE sales > @Param;
<other statements in procedure>
RETURN;
-- Call the procedure:
EXEC GetAccountID 42;