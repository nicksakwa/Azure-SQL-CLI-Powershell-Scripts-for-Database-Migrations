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
    , input_buffer = ib.event_info, tat.transaction_uow
    , transaction_state  = CASE tat.transaction_state
        WHEN 0 THEN 'The transaction has not been completely initialized yet.'
        WHEN 1 THEN 'The transaction has been initialized but has not started.'
        WHEN 2 THEN 'The transaction is active - has not been committed or rolled back.'
        WHEN 3 THEN 'The transaction had ended. This is used for read only transactions.'
        WHEN 4 THEN 'The commit process has been initiated for the transaction '    
        WHEN 5 THEN 'The transaction is in a prepared state and waiting resolution.'
