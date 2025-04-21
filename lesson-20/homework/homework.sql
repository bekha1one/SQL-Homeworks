Question 1: Find customers who purchased at least one item in March 2024 using EXISTS
SELECT DISTINCT CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
    AND YEAR(s2.SaleDate) = 2024
    AND MONTH(s2.SaleDate) = 3
);

Question 2: Find the product with the highest total sales revenue using a subquery
SELECT TOP 1 Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

Question 3: Find the second highest sale amount using a subquery
SELECT MAX(Quantity * Price) AS SecondHighestSale
FROM #Sales
WHERE (Quantity * Price) < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);

Question 4: Find the total quantity of products sold per month using a subquery
SELECT 
    MONTH(SaleDate) AS Month,
    YEAR(SaleDate) AS Year,
    SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate)
ORDER BY Year, Month;

Question 5: Find customers who bought same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName <> s1.CustomerName
    AND s2.Product = s1.Product
);

Question 6: Return how many fruits does each person have in individual fruit level
SELECT 
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

Question 7: Return older people in the family with younger ones
SELECT f1.ParentId, f2.ChildID
FROM Family f1
JOIN Family f2 ON f1.ParentId < f2.ChildID
UNION
SELECT 1, ChildID FROM Family
UNION
SELECT 1, 4;

Question 8: For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
SELECT o.*
FROM #Orders o
WHERE o.CustomerID IN (
    SELECT CustomerID
    FROM #Orders
    WHERE DeliveryState = 'CA'
)
AND o.DeliveryState = 'TX';

Question 9: Insert the names of residents if they are missing
UPDATE #residents
SET fullname = SUBSTRING(address, CHARINDEX('name=', address) + 5, 
                         CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - (CHARINDEX('name=', address) + 5))
WHERE fullname NOT LIKE '%[a-z]%' OR fullname IS NULL;

Question 10: Return the route to reach from Tashkent to Khorezm (cheapest and most expensive)
WITH Routes AS (
    SELECT 
        DepartureCity + ' - ' + ArrivalCity AS Path,
        ArrivalCity,
        Cost,
        1 AS Level
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    
    UNION ALL
    
    SELECT 
        r.Path + ' - ' + rt.ArrivalCity,
        rt.ArrivalCity,
        r.Cost + rt.Cost,
        r.Level + 1
    FROM Routes r
    JOIN #Routes rt ON r.ArrivalCity = rt.DepartureCity
    WHERE rt.ArrivalCity <> 'Tashkent'
    AND r.Level < 3
)
SELECT Path, Cost
FROM Routes
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost;

Question 11: Rank products based on their order of insertion
SELECT 
    ID,
    Vals,
    RANK() OVER (ORDER BY ID) AS ProductRank
FROM #RankingPuzzle
WHERE Vals = 'Product';

Question 12: Return Ids, what number of the letter would be next if inserted, the maximum length of the consecutive occurence of the same digit
WITH ConsecutiveGroups AS (
    SELECT 
        Id,
        Vals,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY (SELECT NULL)) - 
        ROW_NUMBER() OVER (PARTITION BY Id, Vals ORDER BY (SELECT NULL)) AS Grp
    FROM #Consecutives
),
ConsecutiveCounts AS (
    SELECT 
        Id,
        Vals,
        COUNT(*) AS ConsecutiveCount
    FROM ConsecutiveGroups
    GROUP BY Id, Vals, Grp
)
SELECT 
    Id,
    CASE 
        WHEN MAX(CASE WHEN Vals = 1 THEN ConsecutiveCount ELSE 0 END) > 
             MAX(CASE WHEN Vals = 0 THEN ConsecutiveCount ELSE 0 END) THEN 0
        ELSE 1
    END AS NextNumber,
    MAX(ConsecutiveCount) AS MaxConsecutive
FROM ConsecutiveCounts
GROUP BY Id;

Question 13: Find employees whose sales were higher than the average sales in their department
SELECT e.*
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);

Question 14: Find employees who had the highest sales in any given month using EXISTS
SELECT DISTINCT e1.*
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e1.SalesMonth
    AND e2.SalesYear = e1.SalesYear
    GROUP BY e2.SalesMonth, e2.SalesYear
    HAVING e1.SalesAmount = MAX(e2.SalesAmount)
);

Question 15: Find employees who made sales in every month using NOT EXISTS
SELECT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT DISTINCT m.SalesMonth, m.SalesYear
    FROM #EmployeeSales m
    EXCEPT
    SELECT DISTINCT e2.SalesMonth, e2.SalesYear
    FROM #EmployeeSales e2
    WHERE e2.EmployeeID = e.EmployeeID
);

Question 16: Retrieve the names of products that are more expensive than the average price of all products
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

Question 17: Find the products that have a stock count lower than the highest stock count
SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

Question 18: Get the names of products that belong to the same category as 'Laptop'
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop');

Question 19: Retrieve products whose price is greater than the lowest price in the Electronics category
SELECT Name
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

Question 20: Find the products that have a higher price than the average price of their respective category
SELECT p.Name
FROM Products p
WHERE p.Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = p.Category
);

Question 21: Find the products that have been ordered at least once
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

Question 22: Retrieve the names of products that have been ordered more than the average quantity ordered
SELECT p.Name
FROM Products p
JOIN (
    SELECT ProductID, SUM(Quantity) AS TotalQuantity
    FROM Orders
    GROUP BY ProductID
) o ON p.ProductID = o.ProductID
WHERE o.TotalQuantity > (
    SELECT AVG(Quantity)
    FROM Orders
);

Question 23: Find the products that have never been ordered
SELECT p.Name
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

Question 24: Retrieve the product with the highest total quantity ordered
SELECT TOP 1 p.Name
FROM Products p
JOIN (
    SELECT ProductID, SUM(Quantity) AS TotalQuantity
    FROM Orders
    GROUP BY ProductID
) o ON p.ProductID = o.ProductID
ORDER BY o.TotalQuantity DESC;

Question 25: Find the products that have been ordered more times than the average number of orders placed
SELECT p.Name
FROM Products p
JOIN (
    SELECT ProductID, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY ProductID
) o ON p.ProductID = o.ProductID
WHERE o.OrderCount > (
    SELECT AVG(OrderCount)
    FROM (
        SELECT COUNT(*) AS OrderCount
        FROM Orders
        GROUP BY ProductID
    ) counts
);
