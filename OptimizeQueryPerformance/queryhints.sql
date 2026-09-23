DECLARE @city_name nvarchar(30) ='Acheim',
        @postal_code nvarchar(15) = 86171;

SELECT * 
FROM Person.Address
WHERE city = @city_name
    AND postal_code = @postal_code
OPTION (OPTIMIZE FOR (@city_name = 'seattle'));