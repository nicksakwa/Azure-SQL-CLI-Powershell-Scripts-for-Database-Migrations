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