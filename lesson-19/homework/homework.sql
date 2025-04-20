1. Retrieve Employees with Salary Greater than Average Salary
SELECT * 
FROM #Employees
WHERE Salary > (SELECT AVG(Salary) FROM #Employees);

2. Check if there are any employees in Department 1 using EXISTS
SELECT *
FROM #Employees e
WHERE EXISTS (
    SELECT 1 
    FROM #Employees 
    WHERE DepartmentID = 1 AND e.EmployeeID = EmployeeID
);

3. Return employees who work at the same department with Rachel Collins
SELECT *
FROM #Employees
WHERE DepartmentID = (
    SELECT DepartmentID 
    FROM #Employees 
    WHERE FirstName = 'Rachel' AND LastName = 'Collins'
);

4. Retrieve employees hired after the last hired person for department 2
SELECT *
FROM #Employees
WHERE HireDate > (
    SELECT MAX(HireDate)
    FROM #Employees
    WHERE DepartmentID = 2
);

5. Find employees whose salary is higher than their departments average salary
SELECT e.*
FROM #Employees e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM #Employees
    WHERE DepartmentID = e.DepartmentID
);

6. Get count of employees in each department with each employee
SELECT e.*, 
       (SELECT COUNT(*) 
        FROM #Employees 
        WHERE DepartmentID = e.DepartmentID) AS DeptEmployeeCount
FROM #Employees e;

7. Find the person with minimum salary
SELECT *
FROM #Employees
WHERE Salary = (SELECT MIN(Salary) FROM #Employees);

8. Find employees in departments where average salary > $65,000
SELECT e.*
FROM #Employees e
WHERE DepartmentID IN (
    SELECT DepartmentID
    FROM #Employees
    GROUP BY DepartmentID
    HAVING AVG(Salary) > 65000
);

9. List employees hired in last 3 years from last hire_date
SELECT *
FROM #Employees
WHERE HireDate >= DATEADD(YEAR, -3, (SELECT MAX(HireDate) FROM #Employees));

10. If anyone earns ≥ $80,000, return all employees from that department
SELECT e.*
FROM #Employees e
WHERE EXISTS (
    SELECT 1
    FROM #Employees
    WHERE Salary >= 80000 AND DepartmentID = e.DepartmentID
);

11. Return employees who earn the most in each department
SELECT e.*
FROM #Employees e
WHERE Salary = (
    SELECT MAX(Salary)
    FROM #Employees
    WHERE DepartmentID = e.DepartmentID
);

12. Get latest hired employee in each department
SELECT d.DepartmentName, e.FirstName, e.LastName, e.HireDate
FROM #Employees e
JOIN #Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate = (
    SELECT MAX(HireDate)
    FROM #Employees
    WHERE DepartmentID = e.DepartmentID
);

13. Find average salary by department location
SELECT d.Location, d.DepartmentName, AVG(e.Salary) AS AverageSalary
FROM #Employees e
JOIN #Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Location, d.DepartmentName;

14. If anyone earns the average salary, return all from that department
SELECT e.*
FROM #Employees e
WHERE EXISTS (
    SELECT 1
    FROM #Employees
    WHERE DepartmentID = e.DepartmentID
    AND Salary = (
        SELECT AVG(Salary)
        FROM #Employees
        WHERE DepartmentID = e.DepartmentID
    )
);

15. List departments with fewer employees than overall average
SELECT d.DepartmentName
FROM #Departments d
WHERE (
    SELECT COUNT(*)
    FROM #Employees
    WHERE DepartmentID = d.DepartmentID
) < (
    SELECT AVG(DeptCount)
    FROM (
        SELECT COUNT(*) AS DeptCount
        FROM #Employees
        GROUP BY DepartmentID
    ) AS Counts
);

16. Retrieve employees not in department with highest average salary
SELECT e.*
FROM #Employees e
WHERE DepartmentID <> (
    SELECT TOP 1 DepartmentID
    FROM #Employees
    GROUP BY DepartmentID
    ORDER BY AVG(Salary) DESC
);

17. Return departments that have employees using EXISTS
SELECT d.*
FROM #Departments d
WHERE EXISTS (
    SELECT 1
    FROM #Employees e
    WHERE e.DepartmentID = d.DepartmentID
);

18. Return departments with more seniors than juniors
SELECT d.DepartmentName
FROM #Departments d
WHERE (
    SELECT COUNT(*)
    FROM #Employees e
    WHERE e.DepartmentID = d.DepartmentID
    AND DATEDIFF(YEAR, e.HireDate, (SELECT MAX(HireDate) FROM #Employees)) > 3
) > (
    SELECT COUNT(*)
    FROM #Employees e
    WHERE e.DepartmentID = d.DepartmentID
    AND DATEDIFF(YEAR, e.HireDate, (SELECT MAX(HireDate) FROM #Employees)) <= 3
);

19. Return employees of department with most people
SELECT e.*
FROM #Employees e
WHERE DepartmentID = (
    SELECT TOP 1 DepartmentID
    FROM #Employees
    GROUP BY DepartmentID
    ORDER BY COUNT(*) DESC
);

20. For each department, find salary range
SELECT d.DepartmentName, 
       (SELECT MAX(Salary) FROM #Employees WHERE DepartmentID = d.DepartmentID) - 
       (SELECT MIN(Salary) FROM #Employees WHERE DepartmentID = d.DepartmentID) AS SalaryRange
FROM #Departments d
WHERE EXISTS (SELECT 1 FROM #Employees WHERE DepartmentID = d.DepartmentID);

21. Projects with no employees assigned as leads
SELECT p.ProjectName
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1
    FROM EmployeeProject ep
    WHERE ep.ProjectID = p.ProjectID AND ep.Role = 'Lead'
);

22. Employees earning more than average salary of their project teams
SELECT e.FirstName, e.LastName, e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(emp.Salary)
    FROM EmployeeProject ep
    JOIN Employees emp ON ep.EmployeeID = emp.EmployeeID
    WHERE ep.ProjectID IN (
        SELECT ProjectID
        FROM EmployeeProject
        WHERE EmployeeID = e.EmployeeID
    )
);

23. Projects with only one member
SELECT p.ProjectName
FROM Projects p
WHERE (
    SELECT COUNT(*)
    FROM EmployeeProject
    WHERE ProjectID = p.ProjectID
) = 1;

24. Project with highest budget and difference with others
SELECT p1.ProjectName, p1.Budget, 
       (SELECT MAX(Budget) FROM Projects) - p1.Budget AS DifferenceFromMax
FROM Projects p1;

25. Projects where lead salaries exceed average lead salary
SELECT p.ProjectName
FROM Projects p
WHERE (
    SELECT SUM(e.Salary)
    FROM EmployeeProject ep
    JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE ep.ProjectID = p.ProjectID AND ep.Role = 'Lead'
) > (
    SELECT AVG(e.Salary)
    FROM EmployeeProject ep
    JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE ep.Role = 'Lead'
);
