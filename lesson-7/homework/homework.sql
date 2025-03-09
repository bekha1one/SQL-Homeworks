CREATE DATABASE HomeworkDB;
GO

USE HomeworkDB;
GO

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

-- Insert sample data
INSERT INTO Products (ProductName, Category, Price)
VALUES 
('Laptop', 'Electronics', 1200.00),
('Smartphone', 'Electronics', 800.00),
('Tablet', 'Electronics', 500.00),
('Desk Chair', 'Furniture', 150.00),
('Coffee Table', 'Furniture', 200.00),
('Blender', 'Appliances', 80.00),
('Microwave', 'Appliances', 120.00),
('Running Shoes', 'Sports', 90.00),
('Yoga Mat', 'Sports', 25.00),
('Notebook', 'Stationery', 5.00);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Department NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Age INT NOT NULL
);

-- Insert sample data
INSERT INTO Employees (FirstName, LastName, Department, JobTitle, Salary, Age)
VALUES 
('John', 'Doe', 'HR', 'Manager', 75000.00, 45),
('Jane', 'Smith', 'HR', 'Recruiter', 50000.00, 30),
('Mike', 'Johnson', 'IT', 'Developer', 80000.00, 35),
('Sarah', 'Lee', 'IT', 'Analyst', 70000.00, 28),
('Chris', 'Brown', 'Sales', 'Sales Rep', 60000.00, 40),
('Emily', 'Davis', 'Sales', 'Sales Manager', 90000.00, 50),
('David', 'Wilson', 'Finance', 'Accountant', 65000.00, 33),
('Laura', 'Martinez', 'Finance', 'Analyst', 72000.00, 29),
('James', 'Anderson', 'Marketing', 'Manager', 85000.00, 42),
('Linda', 'Taylor', 'Marketing', 'Coordinator', 55000.00, 27);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Region NVARCHAR(50) NOT NULL
);

-- Insert sample data
INSERT INTO Customers (FirstName, LastName, Region)
VALUES 
('Alice', 'Brown', 'North'),
('Bob', 'Green', 'South'),
('Charlie', 'White', 'East'),
('Diana', 'Black', 'West'),
('Eva', 'Gray', 'North'),
('Frank', 'Blue', 'South'),
('Grace', 'Yellow', 'East'),
('Henry', 'Red', 'West'),
('Ivy', 'Pink', 'North'),
('Jack', 'Orange', 'South');

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Region NVARCHAR(50) NOT NULL,
    SalesAmount DECIMAL(10, 2) NOT NULL,
    SaleYear INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample data
INSERT INTO Sales (ProductID, CustomerID, Region, SalesAmount, SaleYear)
VALUES 
(1, 1, 'North', 1200.00, 2023),
(2, 2, 'South', 800.00, 2023),
(3, 3, 'East', 500.00, 2023),
(4, 4, 'West', 150.00, 2023),
(5, 5, 'North', 200.00, 2023),
(6, 6, 'South', 80.00, 2023),
(7, 7, 'East', 120.00, 2023),
(8, 8, 'West', 90.00, 2023),
(9, 9, 'North', 25.00, 2023),
(10, 10, 'South', 5.00, 2023),
(1, 2, 'South', 1200.00, 2022),
(2, 3, 'East', 800.00, 2022),
(3, 4, 'West', 500.00, 2022),
(4, 5, 'North', 150.00, 2022),
(5, 6, 'South', 200.00, 2022);

CREATE TABLE EmployeeSales (
    EmployeeID INT NOT NULL,
    Q1 DECIMAL(10, 2) NOT NULL,
    Q2 DECIMAL(10, 2) NOT NULL,
    Q3 DECIMAL(10, 2) NOT NULL,
    Q4 DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert sample data
INSERT INTO EmployeeSales (EmployeeID, Q1, Q2, Q3, Q4)
VALUES 
(1, 10000.00, 12000.00, 15000.00, 20000.00),
(2, 8000.00, 9000.00, 10000.00, 11000.00),
(3, 5000.00, 6000.00, 7000.00, 8000.00),
(4, 12000.00, 13000.00, 14000.00, 15000.00),
(5, 9000.00, 10000.00, 11000.00, 12000.00),
(6, 20000.00, 22000.00, 25000.00, 30000.00),
(7, 15000.00, 16000.00, 17000.00, 18000.00),
(8, 10000.00, 11000.00, 12000.00, 13000.00),
(9, 18000.00, 19000.00, 20000.00, 21000.00),
(10, 7000.00, 8000.00, 9000.00, 10000.00);

-- Check Products table
SELECT * FROM Products;

-- Check Employees table
SELECT * FROM Employees;

-- Check Customers table
SELECT * FROM Customers;

-- Check Sales table
SELECT * FROM Sales;

-- Check EmployeeSales table
SELECT * FROM EmployeeSales;


--🟢 Easy-Level Tasks (10)

--1. Write a query to find the minimum (MIN) price of a product in the Products table.
SELECT MIN(Price) AS MinPrice
FROM Products;

--2. Write a query to find the maximum (MAX) Salary from the Employees table.
SELECT MAX(Salary) AS MaxSalary
FROM Employees;

--3. Write a query to count the number of rows in the Customers table using COUNT(*).
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

--4. Write a query to count the number of unique product categories (COUNT(DISTINCT Category)) from the Products table.
SELECT COUNT(DISTINCT Category) AS UniqueCategories
FROM Products;

--5. Write a query to find the total (SUM) sales for a particular product in the Sales table.
SELECT SUM(SalesAmount) AS TotalSales
FROM Sales
WHERE ProductID = 1; -- Пример для продукта с ID = 1

--6. Write a query to calculate the average (AVG) age of employees in the Employees table.
SELECT AVG(Age) AS AvgAge
FROM Employees;

--7. Write a query that uses GROUP BY to count the number of employees in each department.
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;

--8. Write a query to show the minimum and maximum Price of products grouped by Category.
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

--9. Write a query to calculate the total (SUM) sales per Region in the Sales table.
SELECT Region, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY Region;

--10. Write a query to use HAVING to filter departments having more than 5 employees from the Employees table.
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 5;


--🟠 Medium-Level Tasks (10)

--11. Write a query to calculate the total sales and average sales for each product category from the Sales table.
SELECT 
    P.Category, 
    SUM(S.SalesAmount) AS TotalSales, 
    AVG(S.SalesAmount) AS AvgSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category;

--12. Write a query that uses COUNT(columnname) to count the number of employees with a specific JobTitle.
SELECT JobTitle, COUNT(EmployeeID) AS EmployeeCount
FROM Employees
WHERE JobTitle = 'Sales Rep' -- Example for job title 'Sales Rep'
GROUP BY JobTitle;

--13. Write a query that finds the highest (MAX) and lowest (MIN) Salary by department in the Employees table.
SELECT 
    Department, 
    MAX(Salary) AS MaxSalary, 
    MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;

--14. Write a query that uses GROUP BY to calculate the average salary per Department.
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department;

--15. Write a query to show the AVG salary and COUNT(*) of employees working in each department.
SELECT 
    Department, 
    AVG(Salary) AS AvgSalary, 
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;

--16. Write a query that uses HAVING to filter products with an average price greater than 100.
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 100;

--17. Write a query to count how many products have sales above 100 units using COUNT(DISTINCT ProductID).
SELECT COUNT(DISTINCT ProductID) AS ProductsAbove100
FROM Sales
WHERE SalesAmount > 100;

--18. Write a query that calculates the total sales for each year in the Sales table, and use GROUP BY to group them.
SELECT SaleYear, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY SaleYear;

--19. Write a query that uses COUNT to show the number of customers who placed orders in each region.
SELECT Region, COUNT(DISTINCT CustomerID) AS CustomerCount
FROM Sales
GROUP BY Region;

--20. Write a query that applies the HAVING clause to filter out Departments with total salary expenses greater than 100,000.
SELECT Department, SUM(Salary) AS TotalSalaryExpenses
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 100000;


--🔴 Hard-Level Tasks (10)

--21. Write a query that shows the average (AVG) sales for each product category, and then uses HAVING to filter categories with an average sales amount greater than 200.
SELECT 
    P.Category, 
    AVG(S.SalesAmount) AS AvgSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category
HAVING AVG(S.SalesAmount) > 200;

--22. Write a query to calculate the total (SUM) sales for each employee, then filter the results using HAVING to include only employees with total sales over 5000.
SELECT 
    E.EmployeeID, 
    E.FirstName, 
    E.LastName, 
    SUM(ES.Q1 + ES.Q2 + ES.Q3 + ES.Q4) AS TotalSales
FROM Employees E
JOIN EmployeeSales ES ON E.EmployeeID = ES.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
HAVING SUM(ES.Q1 + ES.Q2 + ES.Q3 + ES.Q4) > 5000;

--23. Write a query to find the total (SUM) and average (AVG) salary of employees grouped by department, and use HAVING to include only departments with an average salary greater than 6000.
SELECT 
    Department, 
    SUM(Salary) AS TotalSalary, 
    AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 6000;

--24. Write a query that finds the maximum (MAX) and minimum (MIN) order value for each customer, and then applies HAVING to exclude customers with an order value less than 50.
SELECT 
    C.CustomerID, 
    C.FirstName, 
    C.LastName, 
    MAX(S.SalesAmount) AS MaxOrderValue, 
    MIN(S.SalesAmount) AS MinOrderValue
FROM Customers C
JOIN Sales S ON C.CustomerID = S.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
HAVING MIN(S.SalesAmount) >= 50;

--25. Write a query that calculates the total sales (SUM) and counts distinct products sold in each Region, and then applies HAVING to filter regions with more than 10 products sold.
SELECT 
    Region, 
    SUM(SalesAmount) AS TotalSales, 
    COUNT(DISTINCT ProductID) AS UniqueProductsSold
FROM Sales
GROUP BY Region
HAVING COUNT(DISTINCT ProductID) > 10;

--26. Write a query to find the MIN and MAX order quantity per product, and then use GROUP BY to group the results by ProductCategory.
SELECT 
    P.Category, 
    MIN(S.SalesAmount) AS MinOrderValue, 
    MAX(S.SalesAmount) AS MaxOrderValue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category;

--27. Write a query to pivot the Sales table by Year and show the sum of SalesAmount for each Region.
SELECT 
    Region,
    SUM(CASE WHEN SaleYear = 2022 THEN SalesAmount ELSE 0 END) AS Sales2022,
    SUM(CASE WHEN SaleYear = 2023 THEN SalesAmount ELSE 0 END) AS Sales2023
FROM Sales
GROUP BY Region;

--28. Write a query to unpivot the Sales table, converting Q1, Q2, Q3, and Q4 columns into rows showing total sales per quarter.
SELECT 
    EmployeeID, 
    'Q1' AS Quarter, 
    Q1 AS SalesAmount
FROM EmployeeSales
UNION ALL
SELECT 
    EmployeeID, 
    'Q2' AS Quarter, 
    Q2 AS SalesAmount
FROM EmployeeSales
UNION ALL
SELECT 
    EmployeeID, 
    'Q3' AS Quarter, 
    Q3 AS SalesAmount
FROM EmployeeSales
UNION ALL
SELECT 
    EmployeeID, 
    'Q4' AS Quarter, 
    Q4 AS SalesAmount
FROM EmployeeSales;

--29. Write a query to count the number of orders per product, filter those with more than 50 orders using HAVING, and group them by ProductCategory.
SELECT 
    P.Category, 
    COUNT(S.SaleID) AS OrderCount
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category
HAVING COUNT(S.SaleID) > 50;

--30. Write a query to pivot the EmployeeSales table, displaying the total sales per employee for each quarter (Q1, Q2, Q3, Q4).
SELECT 
    EmployeeID,
    SUM(Q1) AS TotalQ1,
    SUM(Q2) AS TotalQ2,
    SUM(Q3) AS TotalQ3,
    SUM(Q4) AS TotalQ4
FROM EmployeeSales
GROUP BY EmployeeID
