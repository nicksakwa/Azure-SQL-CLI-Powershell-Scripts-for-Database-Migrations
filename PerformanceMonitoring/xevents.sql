SELECT
    obj.object_type,
    pkg.name AS [package_name],
    obj.name AS [object_name],
    obj.description AS [description]
FROM
    sys.dm_xe_objects AS obj
    INNER JOIN sys.dm_xe_packages AS pkg ON pkg.guid = obj.package_guid
WHERE 
    obj.object_type in ('action','event', 'target')
ORDER BY
    obj.object_type,
    pkg.name,
    obj.name;

IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name='test_session')
    DROP EVENT session test_session ON SERVER;
GO

CREATE EVENT SESSION test_session
ON SERVER
    ADD EVENT sqlos.async_io_requested,
    ADD EVENT sqlserver.lock_acquired
    ADD TARGET package0.etw_classic_sync_target (SET default_etw_session_logfile_path = N'C:\demo\traces\sqletw.etl' )
    WITH (MAX_MEMORY=4MB, MAX_EVENT_SIZE=4MB);
GO