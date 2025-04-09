🟢 Easy-Level Tasks
1. Top 5 employees
SELECT TOP 5 *
FROM Employees
ORDER BY EmployeeID;

2. Unique ProductNames
SELECT DISTINCT ProductName
FROM Products;

3. Products over $100
SELECT *
FROM Products
WHERE Price > 100;

4. Customers starting with 'A'
SELECT CustomerName
FROM Customers
WHERE CustomerName LIKE 'A%';

5. Products by ascending price
SELECT *
FROM Products
ORDER BY Price ASC;

6. HR employees with salary ≥5000
SELECT *
FROM Employees
WHERE Salary >= 5000 AND Department = 'HR';

7. Replace NULL emails
SELECT ISNULL(Email, 'noemail@example.com') AS Email
FROM Employees;

8. Products priced 50−100
SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;

9. Distinct Category and ProductName
SELECT DISTINCT Category, ProductName
FROM Products;

10. Products by descending name
SELECT *
FROM Products
ORDER BY ProductName DESC;


🟠 Medium-Level Tasks
11. Top 10 most expensive products
SELECT TOP 10 *
FROM Products
ORDER BY Price DESC;

12. COALESCE for first non-NULL name
SELECT COALESCE(FirstName, LastName, 'No Name Available') AS DisplayName
FROM Employees;

13. Distinct Category and Price
SELECT DISTINCT Category, Price
FROM Products;

14. Employees aged 30-40 or in Marketing
SELECT *
FROM Employees
WHERE (Age BETWEEN 30 AND 40) OR Department = 'Marketing';

15. Employees ranked 11-20 by salary
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

16. Affordable products with good stock
SELECT *
FROM Products
WHERE Price <= 1000 AND Stock > 50
ORDER BY Stock ASC;

17. Products containing 'e'
SELECT *
FROM Products
WHERE ProductName LIKE '%e%';

18. Employees in HR, IT, or Finance
SELECT *
FROM Employees
WHERE Department IN ('HR', 'IT', 'Finance');

19. Employees earning above average
SELECT *
FROM Employees
WHERE Salary > ANY (SELECT AVG(Salary) FROM Employees);

20. Customers ordered by City and PostalCode
SELECT *
FROM Customers
ORDER BY City ASC, PostalCode DESC;


🔴 Hard-Level Tasks
21. Top 10 best-selling products
SELECT TOP 10 ProductID, ProductName, SUM(Quantity) AS TotalSales
FROM OrderDetails
GROUP BY ProductID, ProductName
ORDER BY TotalSales DESC;

22. COALESCE for FullName
SELECT 
    EmployeeID,
    COALESCE(FirstName + ' ' + LastName, FirstName, LastName, 'Name Not Available') AS FullName
FROM Employees;

23. Distinct expensive products
SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;

24. Products within 10% of average price
SELECT *
FROM Products
WHERE Price BETWEEN 
    (SELECT AVG(Price) * 0.9 FROM Products) AND 
    (SELECT AVG(Price) * 1.1 FROM Products);

25. Young employees in HR/IT
SELECT *
FROM Employees
WHERE Age < 30 AND Department IN ('HR', 'IT');

26. Gmail users
SELECT *
FROM Customers
WHERE Email LIKE '%@gmail.com';

27. Employees earning more than all Sales
SELECT *
FROM Employees
WHERE Salary > ALL (
    SELECT Salary 
    FROM Employees 
    WHERE Department = 'Sales'
);

28. Pagination for top salaries
-- Page 1
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Page 2 would use OFFSET 10 ROWS, etc.

29. Recent orders (last 30 days)
SELECT *
FROM Orders
WHERE OrderDate BETWEEN DATEADD(day, -30, CURRENT_TIMESTAMP) AND CURRENT_TIMESTAMP;

30. Employees earning above department average
SELECT e.*
FROM Employees e
WHERE Salary > ANY (
    SELECT AVG(Salary)
    FROM Employees
    WHERE Department = e.Department
    GROUP BY Department
);
