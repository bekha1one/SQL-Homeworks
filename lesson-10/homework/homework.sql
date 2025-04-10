🟢 Easy-Level Tasks (10)
1. INNER JOIN with AND in ON clause
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID 
    AND o.OrderDate > '2022-12-31';

2. JOIN with OR in ON clause
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
    AND (d.DepartmentName = 'Sales' OR d.DepartmentName = 'Marketing');

3. JOIN with derived table
SELECT p.ProductID, p.ProductName, o.OrderID, o.OrderDate
FROM (SELECT * FROM Products WHERE Price > 100) p
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID;

4. JOIN with temp table
SELECT o.OrderID, o.OrderDate, t.SpecialNotes
FROM Orders o
JOIN Temp_Orders t ON o.OrderID = t.OrderID;

5. CROSS APPLY example
SELECT e.EmployeeID, e.EmployeeName, top_sales.SaleAmount
FROM Employees e
CROSS APPLY (
    SELECT TOP 5 s.SaleAmount, s.SaleDate
    FROM Sales s
    WHERE s.EmployeeID = e.EmployeeID
    ORDER BY s.SaleAmount DESC
) AS top_sales;

6. JOIN with multiple AND conditions
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
    AND YEAR(o.OrderDate) = 2023
    AND c.LoyaltyStatus = 'Gold';

7. JOIN with aggregated derived table
SELECT c.CustomerID, c.CustomerName, o.OrderCount
FROM Customers c
JOIN (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID;

8. JOIN with OR condition
SELECT p.ProductID, p.ProductName, s.SupplierName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
    AND (s.SupplierName = 'Supplier A' OR s.SupplierName = 'Supplier B');

9. OUTER APPLY example
SELECT e.EmployeeID, e.EmployeeName, recent_order.OrderDate
FROM Employees e
OUTER APPLY (
    SELECT TOP 1 o.OrderDate
    FROM Orders o
    WHERE o.EmployeeID = e.EmployeeID
    ORDER BY o.OrderDate DESC
) AS recent_order;

10. CROSS APPLY with table-valued function
SELECT d.DepartmentID, d.DepartmentName, emp.EmployeeList
FROM Departments d
CROSS APPLY dbo.GetEmployeesByDepartment(d.DepartmentID) emp;


🟠 Medium-Level Tasks (10)
11. JOIN with amount filter
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
    AND o.TotalAmount > 5000;

12. JOIN with OR conditions
SELECT p.ProductID, p.ProductName, s.SaleDate, s.Discount
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
    AND (YEAR(s.SaleDate) = 2022 OR s.Discount > 0.20);

13. JOIN with sales aggregation
SELECT p.ProductID, p.ProductName, s.TotalSales
FROM Products p
JOIN (
    SELECT ProductID, SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
) s ON p.ProductID = s.ProductID;

14. JOIN with discontinued products
SELECT p.ProductID, p.ProductName, tp.DiscontinuedDate
FROM Products p
JOIN Temp_Products tp ON p.ProductID = tp.ProductID
WHERE tp.Discontinued = 1;

15. CROSS APPLY with TVF
SELECT e.EmployeeID, e.EmployeeName, sp.SalesAmount, sp.Rank
FROM Employees e
CROSS APPLY dbo.GetEmployeeSalesPerformance(e.EmployeeID) sp;

16. JOIN with multiple AND conditions
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
    AND d.DepartmentName = 'HR'
    AND e.Salary > 5000;

17. JOIN with OR payment conditions
SELECT o.OrderID, o.OrderDate, p.PaymentAmount, p.PaymentStatus
FROM Orders o
JOIN Payments p ON o.OrderID = p.OrderID
    AND (p.PaymentStatus = 'Fully Paid' OR p.PaymentStatus = 'Partially Paid');

18. OUTER APPLY with most recent orders
SELECT c.CustomerID, c.CustomerName, recent.OrderID, recent.OrderDate
FROM Customers c
OUTER APPLY (
    SELECT TOP 1 o.OrderID, o.OrderDate
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
    ORDER BY o.OrderDate DESC
) AS recent;

19. JOIN with product filters
SELECT p.ProductID, p.ProductName, s.SaleDate, s.Rating
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
    AND YEAR(s.SaleDate) = 2023
    AND s.Rating > 4;

20. JOIN with complex OR condition
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName, e.JobTitle
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
    AND (d.DepartmentName = 'Sales' OR e.JobTitle LIKE '%Manager%');


🔴 Hard-Level Tasks (10)
21. Complex AND conditions
SELECT o.OrderID, o.OrderDate, c.CustomerName, c.City
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
    AND c.City = 'New York'
JOIN (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(*) > 10
) oc ON c.CustomerID = oc.CustomerID;

22. Complex OR conditions
SELECT p.ProductID, p.ProductName, c.CategoryName, s.Discount
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
    AND (p.CategoryID IN (
        SELECT CategoryID FROM Categories WHERE CategoryName = 'Electronics'
    ) OR s.Discount > 0.15)
JOIN Categories c ON p.CategoryID = c.CategoryID;

23. Derived table with aggregation
SELECT c.CategoryID, c.CategoryName, pc.ProductCount
FROM Categories c
JOIN (
    SELECT CategoryID, COUNT(*) AS ProductCount
    FROM Products
    GROUP BY CategoryID
) pc ON c.CategoryID = pc.CategoryID;

24. Complex temp table join
SELECT e.EmployeeID, e.EmployeeName, te.NewSalary, d.DepartmentName
FROM Employees e
JOIN Temp_Employees te ON e.EmployeeID = te.EmployeeID
    AND te.NewSalary > 4000
    AND te.Department = 'IT'
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

25. CROSS APPLY with department employees
SELECT d.DepartmentID, d.DepartmentName, emp.EmployeeCount
FROM Departments d
CROSS APPLY dbo.GetEmployeeCountByDepartment(d.DepartmentID) emp;

26. Complex AND conditions
SELECT o.OrderID, o.OrderDate, c.CustomerName, o.Amount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
    AND c.State = 'California'
    AND o.Amount > 1000;

27. Complex OR conditions
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName, e.JobTitle
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
    AND (d.DepartmentName IN ('HR', 'Finance') 
    OR e.JobTitle LIKE '%Executive%');

28. OUTER APPLY with TVF
SELECT c.CustomerID, c.CustomerName, ord.OrderCount
FROM Customers c
OUTER APPLY dbo.GetCustomerOrders(c.CustomerID) ord;

29. Multiple AND conditions
SELECT p.ProductID, p.ProductName, s.Quantity, s.Price
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
    AND s.Quantity > 100
    AND s.Price > 50;

30. Complex OR with AND condition
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
    AND (d.DepartmentName IN ('Sales', 'Marketing'))
    AND e.Salary > 6000;
