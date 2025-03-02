--## 🟢 Easy-Level Tasks (10)

-- Создаем базу данных
CREATE DATABASE StoreDB;
USE StoreDB;

-- Таблица Products (Товары)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    Price DECIMAL(10,2),
    Stock INT
);

-- Таблица Products_Discontinued (Снятые с продажи товары)
CREATE TABLE Products_Discontinued (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

-- Таблица Customers (Клиенты)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

-- Таблица Orders (Заказы)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Таблица Employees (Сотрудники)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Country VARCHAR(50)
);

--_________________________________________________________________________________

-- Заполняем таблицу Products
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, Stock) VALUES
(1, 'Laptop', 1, 1200.00, 50),
(2, 'Mouse', 2, 20.00, 500),
(3, 'Keyboard', 2, 50.00, 150),
(4, 'Monitor', 1, 300.00, 80);
Select * from Products

-- Заполняем таблицу Products_Discontinued
INSERT INTO Products_Discontinued (ProductID, ProductName) VALUES
(5, 'Old Mouse'),
(6, 'Old Keyboard');
Select * from Products_Discontinued

-- Заполняем таблицу Customers
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'Germany'),
(3, 'Charlie', 'USA');
Select * from Customers

-- Заполняем таблицу Orders
INSERT INTO Orders (OrderID, ProductID, CustomerID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);
Select * from Orders

-- Заполняем таблицу Employees
INSERT INTO Employees (EmployeeID, Name, Department, Country) VALUES
(1, 'John', 'Sales', 'USA'),
(2, 'Sarah', 'HR', 'Germany'),
(3, 'Mike', 'Sales', 'France');
Select * from Employees

--__________________________________________________________________________________

-- 1. Переименование ProductName в Name
SELECT ProductName AS Name FROM Products;

-- 2. Переименование таблицы Customers в Client
SELECT * FROM Customers AS Client;

-- 3. Объединение ProductName из Products и Products_Discontinued с помощью UNION
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discontinued;

-- 4. Пересечение таблиц Products и Products_Discontinued по ProductName
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discontinued;

-- 5. Объединение всех записей из Products и Orders с помощью UNION ALL
SELECT ProductID, ProductName, CategoryID, Price, Stock FROM Products
UNION ALL
SELECT ProductID, NULL, NULL, NULL, NULL FROM Orders;

-- 6. Выбор уникальных CustomerName и Country
SELECT DISTINCT CustomerName, Country FROM Customers;

-- 7. Условный столбец, который показывает 'High' при Price > 100, иначе 'Low'
SELECT ProductName, Price,
       CASE 
           WHEN Price > 100 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;

-- 8. Фильтрация сотрудников по отделу и группировка по стране
SELECT Country, COUNT(EmployeeID) AS EmployeeCount
FROM Employees
WHERE Department = 'Sales'
GROUP BY Country;

-- 9. Количество продуктов в каждой категории
SELECT CategoryID, COUNT(ProductID) AS ProductCount
FROM Products
GROUP BY CategoryID;

-- 10. Новый столбец, который показывает 'Yes', если Stock > 100, иначе 'No'
SELECT ProductName, Stock, 
       IIF(Stock > 100, 'Yes', 'No') AS StockStatus
FROM Products;


--## 🟠 Medium-Level Tasks (10)

-- 1. Создаем базу
CREATE DATABASE BusinessDB;
USE BusinessDB;

-- 2. Создаем таблицы
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50),
    City VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE OutOfStock (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Salary DECIMAL(10,2),
    Department VARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    Region VARCHAR(50),
    SalesAmount DECIMAL(10,2)
);

CREATE TABLE DiscontinuedProducts (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100)
);


-- 3. Заполняем данными
INSERT INTO Customers (CustomerID, CustomerName, Country, City, Email, Phone) VALUES
(1, 'John Doe', 'USA', 'New York', 'john@example.com', '123-456-789'),
(2, 'Alice Smith', 'UK', 'London', 'alice@example.com', '234-567-890'),
(3, 'Bob Brown', 'Canada', 'Toronto', 'bob@example.com', '345-678-901'),
(4, 'Charlie Johnson', 'Germany', 'Berlin', 'charlie@example.com', '456-789-012');
Select * from Customers

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Status) VALUES
(1, '2024-01-10', 500.00, 'Shipped'),
(2, '2024-01-12', 750.00, 'Pending'),
(1, '2024-02-01', 200.00, 'Delivered'),
(3, '2024-02-15', 900.00, 'Shipped'),
(4, '2024-02-20', 300.00, 'Canceled');
Select * from Orders

INSERT INTO Products (ProductName, Price) VALUES
('Laptop', 999.99),
('Smartphone', 699.99),
('Tablet', 399.99),
('Headphones', 199.99);
Select * from Products

INSERT INTO OutOfStock (ProductName) VALUES
('Smartwatch'),
('Wireless Charger'),
('Bluetooth Speaker');
Select * from OutOfStock

INSERT INTO Employees (Name, Age, Salary, Department) VALUES
('Michael Scott', 45, 5000, 'HR'),
('Dwight Schrute', 40, 5500, 'Sales'),
('Pam Beesly', 30, 4000, 'Reception'),
('Jim Halpert', 35, 6200, 'Sales'),
('Angela Martin', 38, 4800, 'Accounting');
Select * from Employees

INSERT INTO Sales (Region, SalesAmount) VALUES
('North America', 10000),
('Europe', 8500),
('Asia', 12000),
('South America', 5000);
Select * from Sales

INSERT INTO DiscontinuedProducts (ProductName) VALUES
('DVD Player'),
('MP3 Player'),
('CRT Monitor');
Select * from DiscontinuedProducts

--4. Выполняем SQL-запросы

--1️1) INNER JOIN: Получаем заказы и их клиентов
SELECT o.OrderID, c.CustomerName AS ClientName, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

--12️) UNION: Объединяем названия товаров из разных таблиц
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM OutOfStock;

--13️) EXCEPT: Разница между активными и снятыми с продажи товарами
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM DiscontinuedProducts;

--14️) CASE: Определяем статус клиента по числу заказов
SELECT c.CustomerName, 
       COUNT(o.OrderID) AS OrderCount,
       CASE 
           WHEN COUNT(o.OrderID) > 5 THEN 'Eligible'
           ELSE 'Not Eligible'
       END AS CustomerStatus
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;

--15️) IIF: Помечаем дорогие товары
SELECT ProductName, Price, 
       IIF(Price > 100, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;

--16️) GROUP BY: Считаем количество заказов на каждого клиента
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID;

--17️) WHERE: Находим сотрудников младше 25 лет или с зарплатой больше 6000
SELECT * FROM Employees
WHERE Age < 25 OR Salary > 6000;

--18️) GROUP BY: Считаем продажи по регионам
SELECT Region, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY Region;

--19️) LEFT JOIN: Клиенты и их заказы
SELECT c.CustomerName, o.OrderID, o.OrderDate AS Order_Date, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

--20) IF (UPDATE): Повышаем зарплату сотрудникам в HR на 10%
UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR';
Select * from Employees
