-- Plain SQL example for inserting into DemoTable

INSERT INTO DemoTable (A) VALUES (1);

-- Begin a transaction to demonstrate blocking and locking behavior
BEGIN TRANSACTION;

INSERT INTO DemoTable (A) VALUES (1);

COMMIT TRANSACTION;

-- select test sessions
SELECT tst.session_id, [database_name] = db.name(s.database_id)