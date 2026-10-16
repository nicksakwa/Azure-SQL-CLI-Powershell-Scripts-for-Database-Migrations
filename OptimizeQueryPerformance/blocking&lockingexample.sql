-- Plain SQL example for inserting into DemoTable

INSERT INTO DemoTable (A) VALUES (1);

-- Begin a transaction to demonstrate blocking and locking behavior
BEGIN TRANSACTION;

INSERT INTO DemoTable (A) VALUES (1);

COMMIT TRANSACTION;

-- select test sessions
SELECT tst.session_id, [database_name] = db.name(s.database_id)
    , tat.transaction_begin_time
    , transaction_duration_s = datediff(s, tat.transaction_begin_time, sysdatetime()) 
    , transaction_type = CASE tat.transaction_type  WHEN 1 THEN 'Read/write transaction'
        WHEN 2 THEN 'Read-only transaction'
        WHEN 3 THEN 'System transaction'
        WHEN 4 THEN 'Distributed transaction' END
