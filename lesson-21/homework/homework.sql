ProductSales Table Solutions
1. Assign a row number to each sale based on the SaleDate
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    Quantity,
    CustomerID,
    ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

2. Rank products based on the total quantity sold (use DENSE_RANK())
SELECT 
    ProductName,
    SUM(Quantity) AS TotalQuantity,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS QuantityRank
FROM ProductSales
GROUP BY ProductName;

3. Identify the top sale for each customer based on the SaleAmount
WITH RankedSales AS (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        Quantity,
        CustomerID,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS Rank
    FROM ProductSales
)
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    Quantity,
    CustomerID
FROM RankedSales
WHERE Rank = 1;

4. Display each sales amount along with the next sale amount in order of SaleDate
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

5. Display each sales amount along with the previous sale amount in order of SaleDate
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales;

6. Rank each sale amount within each product category
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    RANK() OVER (PARTITION BY ProductName ORDER BY SaleAmount) AS AmountRank
FROM ProductSales;

7. Identify sales amounts that are greater than the previous sales amount
WITH SaleComparison AS (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousAmount
    FROM ProductSales
)
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    PreviousAmount
FROM SaleComparison
WHERE SaleAmount > PreviousAmount;

8. Calculate the difference in sale amount from the previous sale for every product
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS AmountDifference
FROM ProductSales;

9. Compare the current sale amount with the next sale amount in terms of percentage change
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount,
    (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / NULLIF(SaleAmount, 0) AS PercentChange
FROM ProductSales;

10. Calculate the ratio of the current sale amount to the previous sale amount within the same product
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount * 1.0 / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS AmountRatio
FROM ProductSales;

11. Calculate the difference in sale amount from the very first sale of that product
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DifferenceFromFirst
FROM ProductSales;

12. Find sales that have been increasing continuously for a product
WITH IncreasingSales AS (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousAmount,
        SUM(CASE WHEN SaleAmount <= LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) THEN 1 ELSE 0 END) 
            OVER (PARTITION BY ProductName ORDER BY SaleDate) AS ResetCounter
    FROM ProductSales
),
GroupedSales AS (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        PreviousAmount,
        ResetCounter,
        ROW_NUMBER() OVER (PARTITION BY ProductName, ResetCounter ORDER BY SaleDate) AS ConsecutiveCount
    FROM IncreasingSales
    WHERE PreviousAmount IS NULL OR SaleAmount > PreviousAmount
)
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount
FROM GroupedSales
WHERE ConsecutiveCount > 1;

13. Calculate a "closing balance" for sales amounts
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM ProductSales;

14. Calculate the moving average of sales amounts over the last 3 sales
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3Sales
FROM ProductSales;

15. Show the difference between each sale amount and the average sale amount
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - AVG(SaleAmount) OVER () AS DifferenceFromAvg
FROM ProductSales;


Employees1 Table Solutions
16. Assign a Unique Rank to Each Employee Based on Salary
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

17. Find Employees Who Have the Same Salary Rank
WITH SalaryRanks AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary) AS SalaryRank
    FROM Employees1
)
SELECT 
    Salary,
    STRING_AGG(Name, ', ') AS EmployeesWithSameSalary,
    COUNT(*) AS NumberOfEmployees
FROM SalaryRanks
GROUP BY Salary
HAVING COUNT(*) > 1;

18. Identify the Top 2 Highest Salaries in Each Department
WITH RankedSalaries AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptSalaryRank
    FROM Employees1
)
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary
FROM RankedSalaries
WHERE DeptSalaryRank <= 2;

19. Find the Lowest-Paid Employee in Each Department
WITH DeptMinSalaries AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        RANK() OVER (PARTITION BY Department ORDER BY Salary) AS SalaryRank
    FROM Employees1
)
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary
FROM DeptMinSalaries
WHERE SalaryRank = 1;

20. Calculate the Running Total of Salaries in Each Department
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY EmployeeID) AS RunningTotal
FROM Employees1;

21. Find the Total Salary of Each Department Without GROUP BY
SELECT DISTINCT
    Department,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary
FROM Employees1;

22. Calculate the Average Salary in Each Department Without GROUP BY
SELECT DISTINCT
    Department,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgSalary
FROM Employees1;

23. Find the Difference Between an Employee's Salary and Their Department's Average
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DifferenceFromAvg
FROM Employees1;

24. Calculate the Moving Average Salary Over 3 Employees
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

25. Find the Sum of Salaries for the Last 3 Hired Employees
WITH LastHired AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        HireDate,
        ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS HireRank
    FROM Employees1
)
SELECT 
    SUM(Salary) AS TotalSalaryLast3Hired
FROM LastHired
WHERE HireRank <= 3;
