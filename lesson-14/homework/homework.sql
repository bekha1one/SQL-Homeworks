Easy Tasks
1.Create a numbers table using a recursive query:
WITH Numbers AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM Numbers
    WHERE Number < 10
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 100);

2.Beginning at 1, double the number for each record:
WITH Doubling AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number * 2
    FROM Doubling
    WHERE Number < 100
)
SELECT * FROM Doubling
OPTION (MAXRECURSION 100);

3.Total sales per employee using a derived table:
SELECT e.EmployeeID, e.FirstName, e.LastName, dt.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID;

4.Average salary of employees using CTE:
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT * FROM AvgSalary;

5.Highest sales for each product using derived table:
SELECT p.ProductID, p.ProductName, dt.MaxSales
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSales
    FROM Sales
    GROUP BY ProductID
) dt ON p.ProductID = dt.ProductID;

6.Employees with more than 5 sales using CTE:
WITH EmployeeSales AS (
    SELECT EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT e.* 
FROM Employees e
JOIN EmployeeSales es ON e.EmployeeID = es.EmployeeID;

7.Products with sales > $500 using CTE:
WITH HighValueSales AS (
    SELECT DISTINCT ProductID
    FROM Sales
    WHERE SalesAmount > 500
)
SELECT p.* 
FROM Products p
JOIN HighValueSales hvs ON p.ProductID = hvs.ProductID;

8.Employees with salaries above average using CTE:
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT e.*
FROM Employees e, AvgSalary
WHERE e.Salary > AvgSalary.AverageSalary;

9.Total number of products sold using derived table:
SELECT SUM(Quantity) AS TotalProductsSold
FROM (
    SELECT ProductID, COUNT(*) AS Quantity
    FROM Sales
    GROUP BY ProductID
) dt;

10.Employees with no sales using CTE:
WITH EmployeesWithSales AS (
    SELECT DISTINCT EmployeeID FROM Sales
)
SELECT e.*
FROM Employees e
LEFT JOIN EmployeesWithSales ews ON e.EmployeeID = ews.EmployeeID
WHERE ews.EmployeeID IS NULL;


Medium Tasks
1.Calculate factorials using recursion:
WITH Factorials AS (
    SELECT 1 AS n, 1 AS factorial
    UNION ALL
    SELECT n + 1, factorial * (n + 1)
    FROM Factorials
    WHERE n < 10
)
SELECT * FROM Factorials
OPTION (MAXRECURSION 100);

2.Calculate Fibonacci numbers using recursion:
WITH Fibonacci AS (
    SELECT 0 AS n, 0 AS fib
    UNION ALL
    SELECT 1, 1
    UNION ALL
    SELECT f1.n + 1, f1.fib + f2.fib
    FROM Fibonacci f1
    JOIN Fibonacci f2 ON f1.n = f2.n + 1
    WHERE f1.n < 20
)
SELECT * FROM Fibonacci
OPTION (MAXRECURSION 100);

3.Split string into rows for each character:
WITH SplitString AS (
    SELECT 
        1 AS Position,
        SUBSTRING(String, 1, 1) AS Character
    FROM Example
    WHERE Id = 1
    
    UNION ALL
    
    SELECT 
        Position + 1,
        SUBSTRING(String, Position + 1, 1)
    FROM SplitString
    JOIN Example ON Example.Id = 1
    WHERE Position < LEN(String)
)
SELECT * FROM SplitString;

4.Rank employees by total sales using CTE:
WITH EmployeeSales AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        SUM(s.SalesAmount) AS TotalSales
    FROM Employees e
    JOIN Sales s ON e.EmployeeID = s.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM EmployeeSales;

5.Top 5 employees by number of orders using derived table:
SELECT TOP 5
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.OrderCount DESC;

6.Sales difference between current and previous month using CTE:
WITH MonthlySales AS (
    SELECT 
        MONTH(SaleDate) AS Month,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY MONTH(SaleDate)
),
MonthlySalesWithPrev AS (
    SELECT 
        Month,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY Month) AS PrevMonthSales
    FROM MonthlySales
)
SELECT 
    Month,
    TotalSales,
    PrevMonthSales,
    TotalSales - PrevMonthSales AS SalesDifference
FROM MonthlySalesWithPrev;

7.Sales per product category using derived table:
SELECT 
    p.CategoryID,
    SUM(dt.SalesAmount) AS CategorySales
FROM Products p
JOIN (
    SELECT ProductID, SUM(SalesAmount) AS SalesAmount
    FROM Sales
    GROUP BY ProductID
) dt ON p.ProductID = dt.ProductID
GROUP BY p.CategoryID;

8.Rank products by total sales in last year using CTE:
WITH ProductSales AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(s.SalesAmount) AS TotalSales
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    WHERE s.SaleDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY p.ProductID, p.ProductName
)
SELECT 
    ProductID,
    ProductName,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM ProductSales;

9.Employees with sales over $5000 each quarter using derived table:
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    DATEPART(QUARTER, s.SaleDate) AS Quarter,
    SUM(s.SalesAmount) AS QuarterlySales
FROM Employees e
JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, DATEPART(QUARTER, s.SaleDate)
HAVING SUM(s.SalesAmount) > 5000;

10.Top 3 employees by sales in last month using derived table:
SELECT TOP 3
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.MonthlySales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS MonthlySales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -1, GETDATE())
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.MonthlySales DESC;


Difficult Tasks
1.Numbers table with gradually increasing sequences:
WITH Numbers AS (
    SELECT 1 AS n, CAST('1' AS VARCHAR(MAX)) AS sequence
    UNION ALL
    SELECT n + 1, sequence + CAST(n + 1 AS VARCHAR(10))
    FROM Numbers
    WHERE n < 5
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 100);

2.Employees with most sales in last 6 months using derived table:
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.SalesCount
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        COUNT(*) AS SalesCount,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS SalesRank
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID
WHERE dt.SalesRank = 1;

3.Running total with bounds (0-10) using recursion:
WITH RunningTotal AS (
    SELECT 
        Id,
        StepNumber,
        [Count],
        [Count] AS RunningSum,
        CASE WHEN [Count] < 0 THEN 0
             WHEN [Count] > 10 THEN 10
             ELSE [Count] END AS BoundedSum
    FROM Numbers
    WHERE StepNumber = 1
    
    UNION ALL
    
    SELECT 
        n.Id,
        n.StepNumber,
        n.[Count],
        rt.RunningSum + n.[Count] AS RunningSum,
        CASE 
            WHEN rt.BoundedSum + n.[Count] < 0 THEN 0
            WHEN rt.BoundedSum + n.[Count] > 10 THEN 10
            ELSE rt.BoundedSum + n.[Count] END AS BoundedSum
    FROM Numbers n
    JOIN RunningTotal rt ON n.Id = rt.Id AND n.StepNumber = rt.StepNumber + 1
)
SELECT * FROM RunningTotal
ORDER BY Id, StepNumber
OPTION (MAXRECURSION 100);

4.Merge employee shifts and activities:
WITH TimeSlots AS (
    SELECT 
        s.ScheduleID,
        s.StartTime,
        s.EndTime,
        a.ActivityName,
        a.StartTime AS ActivityStart,
        a.EndTime AS ActivityEnd,
        CASE 
            WHEN a.ActivityName IS NULL THEN 'Work'
            ELSE a.ActivityName END AS ActivityType
    FROM Schedule s
    LEFT JOIN Activity a ON s.ScheduleID = a.ScheduleID
        AND a.StartTime >= s.StartTime
        AND a.EndTime <= s.EndTime
)
SELECT 
    ScheduleID,
    StartTime,
    EndTime,
    ActivityType
FROM TimeSlots
ORDER BY ScheduleID, StartTime;

5.Sales totals by department and product using CTE and derived table:
WITH DepartmentSales AS (
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        p.ProductID,
        p.ProductName,
        SUM(s.SalesAmount) AS TotalSales
    FROM Departments d
    JOIN Employees e ON d.DepartmentID = e.DepartmentID
    JOIN Sales s ON e.EmployeeID = s.EmployeeID
    JOIN Products p ON s.ProductID = p.ProductID
    GROUP BY d.DepartmentID, d.DepartmentName, p.ProductID, p.ProductName
),
DepartmentTotals AS (
    SELECT 
        DepartmentID,
        SUM(TotalSales) AS DepartmentTotal
    FROM DepartmentSales
    GROUP BY DepartmentID
)
SELECT 
    ds.DepartmentID,
    ds.DepartmentName,
    ds.ProductID,
    ds.ProductName,
    ds.TotalSales,
    dt.DepartmentTotal,
    (ds.TotalSales / dt.DepartmentTotal) * 100 AS PercentageOfDepartment
FROM DepartmentSales ds
JOIN DepartmentTotals dt ON ds.DepartmentID = dt.DepartmentID
ORDER BY ds.DepartmentID, ds.TotalSales DESC;
