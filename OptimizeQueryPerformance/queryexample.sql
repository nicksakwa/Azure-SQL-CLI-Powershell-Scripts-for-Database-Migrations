select orderdate,
    AVG(salesAmount)
from FactResellerSales
WHERE shipdate= '2024-01-01'
GROUP BY orderdate;