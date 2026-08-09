-- Partition function
CREATE PARTITION FUNCTION PartitionByMonth (datetime2)
    AS RANGE RIGHT
    -- The boundary values defined is the first day of each month, where the table will be partitioned into 13 partitions
    FOR VALUES ('20210101', '20210201', '20210301',
      '20210401', '20210501', '20210601', '20210701',
      '20210801', '20210901', '20211001', '20211101', 
      '20211201');

-- The partition scheme below will use the partition function created above, and assign each partition to a specific filegroup.
CREATE PARTITION SCHEME PartitionByMonthSch
    AS PARTITION PartitionByMonth
    TO (FILEGROUP1, FILEGROUP2, FILEGROUP3, FILEGROUP4,
        FILEGROUP5, FILEGROUP6, FILEGROUP7, FILEGROUP8,
        FILEGROUP9, FILEGROUP10, FILEGROUP11, FILEGROUP12,
        FILEGROUP13);

-- Creates a partitioned table called Order that applies PartitionByMonthSch partition scheme to partition the OrderDate column  
CREATE TABLE Order ([Id] int PRIMARY KEY, OrderDate datetime2)  
    ON PartitionByMonthSch (OrderDate) ;  
GO  