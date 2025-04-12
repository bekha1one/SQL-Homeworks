🟢 Easy-Level Tasks (7)
Task 1: Show all orders placed after 2022 along with customer names
SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) > 2022;

Task 2: Display employees in Sales or Marketing department
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');

Task 3: For each department, show employee with highest salary
SELECT d.DepartmentName, e.Name AS TopEmployeeName, e.Salary AS MaxSalary
FROM Departments d
JOIN Employees e ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (
    SELECT MAX(Salary) 
    FROM Employees 
    WHERE DepartmentID = d.DepartmentID
);

Task 4: List USA customers who placed orders in 2023
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, o.OrderID, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND YEAR(o.OrderDate) = 2023;

Task 5: Show order count per customer
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, 
       COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName + ' ' + c.LastName;

Task 6: Display products supplied by Gadget Supplies or Clothing Mart
SELECT p.ProductName, s.SupplierName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

Task 7: Show each customers most recent order (including customers with no orders)
SELECT c.FirstName + ' ' + c.LastName AS CustomerName,
       o.OrderDate AS MostRecentOrderDate,
       o.OrderID
FROM Customers c
LEFT JOIN (
    SELECT CustomerID, OrderID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rn
    FROM Orders
) o ON c.CustomerID = o.CustomerID AND o.rn = 1;


🟠 Medium-Level Tasks (6)
Task 1: Customers with orders > $500
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, 
       o.OrderID, 
       o.TotalAmount AS OrderTotal
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;

Task 2: Product sales in 2022 or amount > $400
SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;

Task 3: Products with total sales amount
SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

Task 4: HR employees earning > $50,000
SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR' AND e.Salary > 50000;

Task 5: Products sold in 2023 with >50 in stock
SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2023 AND p.StockQuantity > 50;

Task 6: Employees in Sales or hired after 2020
SELECT e.Name AS EmployeeName, d.DepartmentName, e.HireDate
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' OR e.HireDate > '2020-12-31';


🔴 Hard-Level Tasks (7)
Task 1: USA customers with address starting with 4 digits
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, 
       o.OrderID, 
       c.Address, 
       o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';

Task 2: Electronics products or sales > $350
SELECT p.ProductName, p.Category, s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryName = 'Electronics' OR s.SaleAmount > 350;

Task 3: Product count per category
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.Category
GROUP BY c.CategoryName;

Task 4: Los Angeles customers with orders > $300
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, 
       c.City, 
       o.OrderID, 
       o.TotalAmount AS Amount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles' AND o.TotalAmount > 300;

Task 5: Employees in HR/Finance or with ≥4 vowels in name
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('HR', 'Finance')
   OR LOWER(e.Name) LIKE '%a%a%a%a%'
   OR LOWER(e.Name) LIKE '%e%e%e%e%'
   OR LOWER(e.Name) LIKE '%i%i%i%i%'
   OR LOWER(e.Name) LIKE '%o%o%o%o%'
   OR LOWER(e.Name) LIKE '%u%u%u%u%';

Task 6: Products with quantity >100 and price >$500
SELECT p.ProductName, s.Quantity AS QuantitySold, p.Price
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE s.Quantity > 100 AND p.Price > 500;

Task 7: Sales/Marketing employees earning >$60,000
SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing') AND e.Salary > 60000;
