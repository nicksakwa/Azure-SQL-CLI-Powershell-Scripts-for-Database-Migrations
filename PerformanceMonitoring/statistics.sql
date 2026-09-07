SELECT sp.stats_id,
    name,
    last_upated,
    rows,
    rows_sampled
FROM sys.stats
    CROSS APPLY sys.dm_db_stats_properties(object_id, stats_id) AS sp
WHERE user_created = 1