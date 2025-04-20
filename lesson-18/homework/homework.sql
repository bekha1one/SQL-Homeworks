Level 1: Basic Subqueries
1.Find Employees with Minimum Salary
SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

2.Find Products Above Average Price
SELECT id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);


Level 2: Nested Subqueries with Conditions
3.Find Employees in Sales Department
SELECT e.id, e.name
FROM employees e
WHERE e.department_id = (SELECT id FROM departments WHERE department_name = 'Sales');

4.Find Customers with No Orders
SELECT c.customer_id, c.name
FROM customers c
WHERE c.customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);


Level 3: Aggregation and Grouping in Subqueries
5.Find Products with Max Price in Each Category
SELECT p.id, p.product_name, p.price, p.category_id
FROM products p
WHERE p.price = (
    SELECT MAX(price) 
    FROM products 
    WHERE category_id = p.category_id
);

6.Find Employees in Department with Highest Average Salary
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);


Level 4: Correlated Subqueries
7.Find Employees Earning Above Department Average
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

8.Find Students with Highest Grade per Course
SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);


Level 5: Subqueries with Ranking and Complex Conditions
9.Find Third-Highest Price per Category
WITH RankedProducts AS (
    SELECT 
        id, 
        product_name, 
        price, 
        category_id,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
    FROM products
)
SELECT id, product_name, price, category_id
FROM RankedProducts
WHERE price_rank = 3;

10.Find Employees Between Company Average and Department Max Salary
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) 
    FROM employees
)
AND e.salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);
