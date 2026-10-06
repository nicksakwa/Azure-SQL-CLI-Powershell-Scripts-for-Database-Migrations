-- Plain SQL example for inserting into DemoTable

INSERT INTO DemoTable (A) VALUES (1);

-- Begin a transaction to demonstrate blocking and locking behavior
BEGIN TRANSACTION;

INSERT INTO DemoTable (A) VALUES (1);
