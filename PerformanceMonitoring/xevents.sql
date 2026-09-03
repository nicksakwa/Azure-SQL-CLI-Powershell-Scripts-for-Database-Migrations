-- select all available extended events, actions, and targets
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

-- Create events session but 1st check if one exists
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name='test_session')
    DROP EVENT SESSION test_session ON SERVER;
GO

