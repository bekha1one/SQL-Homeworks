-- Creating the database
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- Table for customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(50)
);

INSERT INTO Customers (CustomerName, Email, Phone) VALUES
('John Doe', 'john@example.com', '123-456-7890'),
('Jane Smith', 'jane@example.com', '987-654-3210'),
('Michael Brown', 'michael@example.com', '555-234-5678'),
('Emily Davis', 'emily@example.com', '777-888-9999'),
('David Wilson', 'david@example.com', '111-222-3333'),
('Sophia Martinez', 'sophia@example.com', '444-555-6666'),
('Daniel Anderson', 'daniel@example.com', '999-000-1111'),
('Olivia Thomas', 'olivia@example.com', '222-333-4444');

-- Table for orders (One to Many with Customers)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2) CHECK (OrderAmount >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (CustomerID, OrderDate, OrderAmount) VALUES
(1, '2024-03-01', 250.00),
(2, '2024-03-02', 100.00),
(3, '2024-03-03', 500.00),
(4, '2024-03-04', 750.00),
(5, '2024-03-05', 1200.00),
(6, '2024-03-06', 300.00),
(7, '2024-03-07', 450.00),
(8, '2024-03-08', 900.00);

-- Table for employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(255) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2) CHECK (Salary >= 0),
    HireDate DATE
);

INSERT INTO Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES
('Alice Johnson', 1, 5500.00, '2020-01-15'),
('Bob Williams', 2, 4800.00, '2019-06-10'),
('Charlie Carter', 3, 6000.00, '2018-09-20'),
('Diana Ross', 1, 7000.00, '2017-05-30'),
('Edward Collins', 2, 6500.00, '2016-11-22'),
('Fiona Scott', 3, 7200.00, '2015-08-14'),
('George Harris', 1, 5800.00, '2019-12-01'),
('Hannah Lewis', 2, 4900.00, '2021-04-10');

-- Table for employee details (One to One with Employees)
CREATE TABLE EmployeeDetails (
    EmployeeID INT PRIMARY KEY,
    Address VARCHAR(255),
    BirthDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO EmployeeDetails (EmployeeID, Address, BirthDate) VALUES
(1, '123 Main St, City A', '1990-05-20'),
(2, '456 Maple Ave, City B', '1985-09-10'),
(3, '789 Oak St, City C', '1988-07-15'),
(4, '321 Pine St, City D', '1979-04-05'),
(5, '654 Birch St, City E', '1992-11-30'),
(6, '987 Cedar St, City F', '1983-06-25'),
(7, '159 Walnut St, City G', '1995-02-18'),
(8, '753 Spruce St, City H', '1987-08-09');

-- Table for departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(255) NOT NULL
);

INSERT INTO Departments (DepartmentName) VALUES
('HR'),
('IT'),
('Finance'),
('Marketing');

-- Table for products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(255) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10,2) CHECK (Price >= 0)
);

INSERT INTO Products (ProductName, CategoryID, SupplierID, Price) VALUES
('Laptop', 1, 1, 1200.00),
('Phone', 1, 2, 800.00),
('Tablet', 1, 3, 600.00),
('Desk', 2, 4, 300.00),
('Chair', 2, 5, 150.00),
('Monitor', 1, 6, 400.00),
('Keyboard', 1, 7, 100.00),
('Mouse', 1, 8, 50.00);

-- Table for product categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(255) NOT NULL
);

INSERT INTO Categories (CategoryName) VALUES
('Electronics'),
('Furniture'),
('Office Supplies');

-- Table for suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName VARCHAR(255) NOT NULL
);

INSERT INTO Suppliers (SupplierName) VALUES
('Supplier A'),
('Supplier B'),
('Supplier C'),
('Supplier D'),
('Supplier E'),
('Supplier F'),
('Supplier G'),
('Supplier H');

-- Table for order details (Many to Many between Orders and Products)
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 4),
(4, 4, 5),
(5, 5, 2),
(6, 6, 3),
(7, 7, 1),
(8, 8, 6);

-- 1. Join Customers and Orders using INNER JOIN to get CustomerName and OrderDate
SELECT Customers.CustomerName, Orders.OrderDate 
FROM Customers 
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 2. Demonstrate One to One relationship between EmployeeDetails and Employees tables
SELECT Employees.EmployeeName, EmployeeDetails.Address, EmployeeDetails.BirthDate 
FROM Employees 
INNER JOIN EmployeeDetails ON Employees.EmployeeID = EmployeeDetails.EmployeeID;

-- 3. Join Products and Categories tables using INNER JOIN
SELECT Products.ProductName, Categories.CategoryName 
FROM Products 
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID;

-- 4. Show all Customers and corresponding OrderDate using LEFT JOIN
SELECT Customers.CustomerName, Orders.OrderDate 
FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 5. Demonstrate Many to Many relationship between Orders and Products using OrderDetails table
SELECT Orders.OrderID, Products.ProductName, OrderDetails.Quantity 
FROM OrderDetails 
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID 
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

-- 6. Perform a CROSS JOIN between Products and Categories
SELECT Products.ProductName, Categories.CategoryName 
FROM Products 
CROSS JOIN Categories;

-- 7. Demonstrate One to Many relationship between Customers and Orders using INNER JOIN
SELECT Customers.CustomerName, Orders.OrderID 
FROM Customers 
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 8. Filter a CROSS JOIN result using WHERE clause for OrderAmount > 500
SELECT Products.ProductName, Orders.OrderID, Orders.OrderAmount 
FROM Products 
CROSS JOIN Orders 
WHERE Orders.OrderAmount > 500;

-- 9. Join Employees and Departments using INNER JOIN
SELECT Employees.EmployeeName, Departments.DepartmentName 
FROM Employees 
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;

-- 10. Use ON clause with <> operator to join tables and return rows where values are not equal
SELECT Employees.EmployeeName, Departments.DepartmentName 
FROM Employees 
INNER JOIN Departments ON Employees.DepartmentID <> Departments.DepartmentID;

-- 11. One to Many relationship: Customers and Orders (Total Orders per Customer)
SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName;

-- 12. Many to Many relationship: Students and Courses (via StudentCourses table)
SELECT Students.StudentName, Courses.CourseName
FROM Students
INNER JOIN StudentCourses ON Students.StudentID = StudentCourses.StudentID
INNER JOIN Courses ON StudentCourses.CourseID = Courses.CourseID;

-- 13. CROSS JOIN: Employees and Departments (Filtered by Salary > 5000)
SELECT Employees.EmployeeName, Departments.DepartmentName, Employees.Salary
FROM Employees
CROSS JOIN Departments
WHERE Employees.Salary > 5000;

-- 14. One to One relationship: Employees and EmployeeDetails
SELECT Employees.EmployeeName, EmployeeDetails.Address, EmployeeDetails.BirthDate
FROM Employees
INNER JOIN EmployeeDetails ON Employees.EmployeeID = EmployeeDetails.EmployeeID;

-- 15. INNER JOIN: Products and Suppliers (Filtered by Supplier 'Supplier A')
SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.SupplierName = 'Supplier A';

-- 16. LEFT JOIN: Products and Sales (Including Products with No Sales)
SELECT Products.ProductName, COALESCE(SUM(Sales.Quantity), 0) AS TotalSales
FROM Products
LEFT JOIN Sales ON Products.ProductID = Sales.ProductID
GROUP BY Products.ProductName;

-- 17. Employees in HR department with Salary > 4000
SELECT Employees.EmployeeName, Departments.DepartmentName, Employees.Salary
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.Salary > 4000 AND Departments.DepartmentName = 'HR';

-- 18. Using >= in ON clause to join tables
SELECT A.Col1, B.Col2
FROM TableA A
INNER JOIN TableB B ON A.Value >= B.Value;

-- 19. INNER JOIN: Products and Suppliers (Products with Price >= 50)
SELECT Products.ProductName, Products.Price, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Products.Price >= 50;

-- 20. CROSS JOIN: Sales and Regions (Filtered by Sales > 1000)
SELECT Sales.SaleID, Regions.RegionName, Sales.Amount
FROM Sales
CROSS JOIN Regions
WHERE Sales.Amount > 1000;

-- 21. Many to Many relationship between Authors and Books
SELECT Authors.AuthorName, Books.BookTitle
FROM Authors
INNER JOIN AuthorBooks ON Authors.AuthorID = AuthorBooks.AuthorID
INNER JOIN Books ON AuthorBooks.BookID = Books.BookID;

-- 22. INNER JOIN between Products and Categories excluding 'Electronics'
SELECT Products.ProductName, Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName <> 'Electronics';

-- 23. CROSS JOIN between Orders and Products with quantity filter
SELECT Orders.OrderID, Products.ProductName, Orders.Quantity
FROM Orders
CROSS JOIN Products
WHERE Orders.Quantity > 100;

-- 24. INNER JOIN Employees and Departments with experience filter
SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE DATEDIFF(YEAR, Employees.HireDate, GETDATE()) > 5;

-- 25. Difference between INNER JOIN and LEFT JOIN
SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;

-- 26. CROSS JOIN between Products and Suppliers filtered by 'Category A'
SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
CROSS JOIN Suppliers
WHERE Products.CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Category A');

-- 27. INNER JOIN Orders and Customers filtering customers with at least 10 orders
SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS OrderCount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName
HAVING COUNT(Orders.OrderID) >= 10;

-- 28. Many to Many relationship between Courses and Students with count
SELECT Courses.CourseName, COUNT(StudentCourses.StudentID) AS EnrolledStudents
FROM Courses
INNER JOIN StudentCourses ON Courses.CourseID = StudentCourses.CourseID
GROUP BY Courses.CourseName;

-- 29. LEFT JOIN Employees and Departments filtered by 'Marketing'
SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Marketing';

-- 30. JOIN with ON clause using <= operator
SELECT Orders.OrderID, Products.ProductName
FROM Orders
INNER JOIN Products ON Orders.OrderDate <= Products.ReleaseDate;

--Updating

-- Creating the database
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- Table for customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(50)
);

INSERT INTO Customers (CustomerName, Email, Phone) VALUES
('John Doe', 'john@example.com', '123-456-7890'),
('Jane Smith', 'jane@example.com', '987-654-3210'),
('Michael Brown', 'michael@example.com', '555-234-5678'),
('Emily Davis', 'emily@example.com', '777-888-9999'),
('David Wilson', 'david@example.com', '111-222-3333'),
('Sophia Martinez', 'sophia@example.com', '444-555-6666'),
('Daniel Anderson', 'daniel@example.com', '999-000-1111'),
('Olivia Thomas', 'olivia@example.com', '222-333-4444');

-- Table for orders (One to Many with Customers)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2) CHECK (OrderAmount >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (CustomerID, OrderDate, OrderAmount) VALUES
(1, '2024-03-01', 250.00),
(2, '2024-03-02', 100.00),
(3, '2024-03-03', 500.00),
(4, '2024-03-04', 750.00),
(5, '2024-03-05', 1200.00),
(6, '2024-03-06', 300.00),
(7, '2024-03-07', 450.00),
(8, '2024-03-08', 900.00);

-- Table for employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(255) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2) CHECK (Salary >= 0),
    HireDate DATE
);

INSERT INTO Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES
('Alice Johnson', 1, 5500.00, '2020-01-15'),
('Bob Williams', 2, 4800.00, '2019-06-10'),
('Charlie Carter', 3, 6000.00, '2018-09-20'),
('Diana Ross', 1, 7000.00, '2017-05-30'),
('Edward Collins', 2, 6500.00, '2016-11-22'),
('Fiona Scott', 3, 7200.00, '2015-08-14'),
('George Harris', 1, 5800.00, '2019-12-01'),
('Hannah Lewis', 2, 4900.00, '2021-04-10');

-- Table for employee details (One to One with Employees)
CREATE TABLE EmployeeDetails (
    EmployeeID INT PRIMARY KEY,
    Address VARCHAR(255),
    BirthDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO EmployeeDetails (EmployeeID, Address, BirthDate) VALUES
(1, '123 Main St, City A', '1990-05-20'),
(2, '456 Maple Ave, City B', '1985-09-10'),
(3, '789 Oak St, City C', '1988-07-15'),
(4, '321 Pine St, City D', '1979-04-05'),
(5, '654 Birch St, City E', '1992-11-30'),
(6, '987 Cedar St, City F', '1983-06-25'),
(7, '159 Walnut St, City G', '1995-02-18'),
(8, '753 Spruce St, City H', '1987-08-09');

-- Table for departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(255) NOT NULL
);

INSERT INTO Departments (DepartmentName) VALUES
('HR'),
('IT'),
('Finance'),
('Marketing');

-- Table for products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(255) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10,2) CHECK (Price >= 0)
);

INSERT INTO Products (ProductName, CategoryID, SupplierID, Price) VALUES
('Laptop', 1, 1, 1200.00),
('Phone', 1, 2, 800.00),
('Tablet', 1, 3, 600.00),
('Desk', 2, 4, 300.00),
('Chair', 2, 5, 150.00),
('Monitor', 1, 6, 400.00),
('Keyboard', 1, 7, 100.00),
('Mouse', 1, 8, 50.00);

-- Updating missing tasks and queries
-- Task 10: ON clause with <>
SELECT * FROM Customers C 
INNER JOIN Orders O ON C.CustomerID <> O.CustomerID;

-- Task 18: ON clause with >=
SELECT * FROM Products P 
INNER JOIN Orders O ON P.ProductID >= O.OrderID;

-- Task 24: Employees with more than 5 years in the company
SELECT * FROM Employees E 
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID 
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5;

-- Task 26: CROSS JOIN filtering suppliers by category
SELECT * FROM Products P 
CROSS JOIN Suppliers S 
WHERE P.CategoryID = 1;

-- Task 30: ON clause with <=
SELECT * FROM Orders O 
INNER JOIN Customers C ON O.OrderID <= C.CustomerID;
