SELECT 
    [stockItemName],
    [UnitPrice] * [QuantityPerOuter] AS CostPerOuterBox,
    [Quantityonhand]
FROM 
    [Warehouse].[StockItems] s
JOIN 
    [Warehouse].[StockItemHoldings] sh ON s.StockItemID = sh.StockItemID
ORDER BY CostPerOuterBox;