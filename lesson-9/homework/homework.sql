-- Create the database
CREATE DATABASE CompanyDB;
GO

-- Switch to the newly created database
USE CompanyDB;
GO

-- Table: Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1), -- Auto-incrementing primary key
    DepartmentName VARCHAR(50) NOT NULL
);
GO

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    DepartmentID INT,
    ManagerID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID) -- Self-referencing for managers
);
GO

-- Table: Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(50) NOT NULL
);
GO

-- Table: Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    OrderDate DATE NOT NULL,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Table: Suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName VARCHAR(50) NOT NULL
);
GO

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- Table: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Table: Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    PaymentDate DATE NOT NULL,
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- Table: Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName VARCHAR(50) NOT NULL
);
GO

-- Table: Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    StudentName VARCHAR(50) NOT NULL,
    CourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- Table: Sales
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY IDENTITY(1,1),
    SalesAmount DECIMAL(10, 2) NOT NULL,
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Insert data into Departments
INSERT INTO Departments (DepartmentName) VALUES
('HR'), ('IT'), ('Sales'), ('Finance'), ('Marketing');
GO

-- Insert data into Employees
INSERT INTO Employees (EmployeeName, Salary, DepartmentID, ManagerID) VALUES
('John Doe', 6000, 1, NULL), -- John Doe is a top-level manager
('Jane Smith', 5500, 2, 1),   -- Jane reports to John
('Alice Johnson', 7000, 3, 1), -- Alice reports to John
('Bob Brown', 4500, 4, 2),    -- Bob reports to Jane
('Charlie Davis', 8000, 5, 2), -- Charlie reports to Jane
('Eva Green', 5000, 1, 1);    -- Eva reports to John
GO

-- Insert data into Customers
INSERT INTO Customers (CustomerName) VALUES
('Customer A'), ('Customer B'), ('Customer C'), ('Customer D');
GO

-- Insert data into Orders
INSERT INTO Orders (OrderDate, CustomerID) VALUES
('2023-01-15', 1),
('2023-02-20', 2),
('2022-12-10', 3),
('2023-03-25', 4),
('2023-04-30', 1);
GO

-- Insert data into Suppliers
INSERT INTO Suppliers (SupplierName) VALUES
('Supplier X'), ('Supplier Y'), ('Supplier Z');
GO

-- Insert data into Categories
INSERT INTO Categories (CategoryName) VALUES
('Electronics'), ('Furniture'), ('Clothing');
GO

-- Insert data into Products
INSERT INTO Products (ProductName, SupplierID, CategoryID) VALUES
('Laptop', 1, 1),
('Chair', 2, 2),
('Smartphone', 1, 1),
('Table', 2, 2),
('T-Shirt', 3, 3);
GO

-- Insert data into Payments
INSERT INTO Payments (PaymentDate, OrderID) VALUES
('2023-01-20', 1),
('2023-02-25', 2),
('2023-03-30', 4);
GO

-- Insert data into Courses
INSERT INTO Courses (CourseName) VALUES
('Math 101'), ('Physics 102'), ('Chemistry 103');
GO

-- Insert data into Students
INSERT INTO Students (StudentName, CourseID) VALUES
('Student 1', 1),
('Student 2', 2),
('Student 3', 1),
('Student 4', 3);
GO

-- Insert data into Sales
INSERT INTO Sales (SalesAmount, ProductID) VALUES
(1500, 1),
(200, 2),
(3000, 3),
(500, 4);
GO

-- Check Employees
SELECT * FROM Employees;
GO

-- Check Orders
SELECT * FROM Orders;
GO

-- Check Products
SELECT * FROM Products;
GO

-- Check Sales
SELECT * FROM Sales;
GO

--🟢 Easy-Level Tasks (10)

--1. INNER JOIN Employees and Departments with WHERE clause for salary > 5000:
-- Show employees with a salary greater than 5000
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 5000;
GO

--2. INNER JOIN Customers and Orders with WHERE clause for orders placed in 2023:
-- Show orders placed in 2023
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;
GO

--3. LEFT OUTER JOIN Employees and Departments to show all employees and their departments:
-- Show all employees, including those without a department
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
LEFT OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

--4. RIGHT OUTER JOIN Products and Suppliers to show all suppliers and their products:
-- Show all suppliers, including those without products
SELECT p.ProductID, p.ProductName, s.SupplierName
FROM Products p
RIGHT OUTER JOIN Suppliers s ON p.SupplierID = s.SupplierID;
GO

--5. FULL OUTER JOIN Orders and Payments to show all orders and their payments:
-- Show all orders and payments, including unmatched records
SELECT o.OrderID, o.OrderDate, p.PaymentID, p.PaymentDate
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID;
GO

--6. SELF JOIN Employees to show employees and their managers:
-- Show employees and their managers
SELECT e1.EmployeeName AS Employee, e2.EmployeeName AS Manager
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID;
GO

--7. Demonstrate the logical order of SQL execution with JOIN and WHERE:
-- Show products with sales greater than 100
SELECT p.ProductID, p.ProductName, s.SalesAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SalesAmount > 100;
GO

--8. INNER JOIN Students and Courses with WHERE clause for students enrolled in 'Math 101':
-- Show students enrolled in 'Math 101'
SELECT s.StudentID, s.StudentName, c.CourseName
FROM Students s
INNER JOIN Courses c ON s.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';
GO

--9. INNER JOIN Customers and Orders with WHERE clause for customers with more than 3 orders:
-- Show customers who have placed more than 3 orders
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 3;
GO

--10. LEFT OUTER JOIN Employees and Departments with WHERE clause for employees in the 'HR' department:
-- Show employees in the 'HR' department
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
LEFT OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR';
GO


--🟠 Medium-Level Tasks (10)

--11. INNER JOIN Employees and Departments with WHERE clause for departments with more than 2 employees:
-- Find departments with more than 2 employees
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IN (
    SELECT DepartmentID
    FROM Employees
    GROUP BY DepartmentID
    HAVING COUNT(EmployeeID) > 2
);
GO

--12. LEFT OUTER JOIN Products and Sales with WHERE clause for products with no sales:
-- Find products with no sales
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT OUTER JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SalesID IS NULL;
GO

--13. RIGHT OUTER JOIN Customers and Orders with WHERE clause for customers who placed at least one order:
-- Find customers who placed at least one order
SELECT c.CustomerID, c.CustomerName
FROM Customers c
RIGHT OUTER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NOT NULL;
GO

--14. FULL OUTER JOIN Employees and Departments with WHERE clause to exclude NULL departments:
-- Find all employees and departments, excluding NULL departments
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
FULL OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IS NOT NULL;
GO

--15. SELF JOIN Employees to find employees who report to the same manager:
-- Find employees who report to the same manager
SELECT e1.EmployeeName AS Employee1, e2.EmployeeName AS Employee2, e1.ManagerID
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID <> e2.EmployeeID;
GO

--16. LEFT OUTER JOIN Orders and Customers with WHERE clause for orders placed in 2022:
-- Find orders placed in 2022
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Orders o
LEFT OUTER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2022;
GO

--17. INNER JOIN Employees and Departments with ON and WHERE clauses for 'Sales' department and salary > 5000:
-- Find employees in the 'Sales' department with a salary > 5000
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' AND e.Salary > 5000;
GO

--18. INNER JOIN Employees and Departments with WHERE clause for 'IT' department:
-- Find employees in the 'IT' department
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';
GO

--19. FULL OUTER JOIN Orders and Payments with WHERE clause for orders with payments:
-- Find orders with corresponding payments
SELECT o.OrderID, o.OrderDate, p.PaymentID
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NOT NULL;
GO

--20. LEFT OUTER JOIN Products and Orders with WHERE clause for products with no orders:
-- Find products with no orders
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT OUTER JOIN Orders o ON p.ProductID = o.OrderID
WHERE o.OrderID IS NULL;
GO


--🔴 Hard-Level Tasks (10)

--21. JOIN Employees and Departments with WHERE clause for employees earning more than the average salary in their department:
-- Find employees earning more than the average salary in their department
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = d.DepartmentID
);
GO

--22. LEFT OUTER JOIN Orders and Payments with WHERE clause for unpaid orders placed before 2020:
-- Find unpaid orders placed before 2020
SELECT o.OrderID, o.OrderDate
FROM Orders o
LEFT OUTER JOIN Payments p ON o.OrderID = p.OrderID
WHERE YEAR(o.OrderDate) < 2020 AND p.PaymentID IS NULL;
GO

--23. FULL OUTER JOIN Products and Categories with WHERE clause for products with no category:
-- Find products with no category
SELECT p.ProductID, p.ProductName
FROM Products p
FULL OUTER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IS NULL;
GO

--24. SELF JOIN Employees to find employees who report to the same manager and earn more than 5000:
-- Find employees who report to the same manager and earn more than 5000
SELECT e1.EmployeeName AS Employee1, e2.EmployeeName AS Employee2, e1.ManagerID
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID <> e2.EmployeeID AND e1.Salary > 5000 AND e2.Salary > 5000;
GO

--25. RIGHT OUTER JOIN Employees and Departments with WHERE clause for departments starting with 'M':
-- Find employees in departments starting with 'M'
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
RIGHT OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName LIKE 'M%';
GO

--26. Difference between ON and WHERE clauses with JOIN Products and Sales:
-- Demonstrate the difference between ON and WHERE
SELECT p.ProductID, p.ProductName, s.SalesAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SalesAmount > 1000;
GO

--27. LEFT OUTER JOIN Students and Courses with WHERE clause for students not enrolled in 'Math 101':
-- Find students not enrolled in 'Math 101'
SELECT s.StudentID, s.StudentName
FROM Students s
LEFT OUTER JOIN Courses c ON s.CourseID = c.CourseID
WHERE c.CourseName <> 'Math 101' OR c.CourseID IS NULL;
GO

--28. FULL OUTER JOIN Orders and Payments with WHERE clause for orders with no payment:
-- Find orders with no payment
SELECT o.OrderID, o.OrderDate
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;
GO

--29. INNER JOIN Products and Categories with WHERE clause for 'Electronics' or 'Furniture':
-- Find products in 'Electronics' or 'Furniture' categories
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');
GO

--30. CROSS JOIN Customers and Orders with WHERE clause for customers with more than 2 orders in 2023:
-- Find customers with more than 2 orders in 2023
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
CROSS JOIN Orders o
WHERE c.CustomerID = o.CustomerID AND YEAR(o.OrderDate) = 2023
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 2;
GO
