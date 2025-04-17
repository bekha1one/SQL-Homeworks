Easy Tasks
1. Output "100-Steven King" format
SELECT CONCAT(EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) AS employee_info
FROM Employees
WHERE EMPLOYEE_ID = 100;

2. Update phone_number replacing '124' with '999'
UPDATE Employees
SET PHONE_NUMBER = REPLACE(PHONE_NUMBER, '124', '999')
WHERE PHONE_NUMBER LIKE '%124%';

3. First name and length for names starting with A, J, or M
SELECT FIRST_NAME AS "First Name", LEN(FIRST_NAME) AS "Name Length"
FROM Employees
WHERE FIRST_NAME LIKE 'A%' OR FIRST_NAME LIKE 'J%' OR FIRST_NAME LIKE 'M%'
ORDER BY FIRST_NAME;

4. Total salary for each manager ID
SELECT MANAGER_ID, SUM(SALARY) AS total_salary
FROM Employees
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID;

5. Year and highest value from Max1, Max2, Max3
SELECT Year1, 
       (SELECT MAX(val) FROM (VALUES (Max1), (Max2), (Max3)) AS value(val)) AS highest_value
FROM TestMax;

6. Odd numbered movies where description is not boring
SELECT *
FROM cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;

7. Sort data with ID 0 last
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;

8. First non-null value from a set of columns
SELECT id,
       COALESCE(ssn, passportid, itin) AS first_non_null_value
FROM person;

9. Employees with 10-15 years of service
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
       ROUND(DATEDIFF(YEAR, HIRE_DATE, GETDATE()), 2) AS years_of_service
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 10 
  AND DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 15;

10. Employees with salary > department average
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.SALARY, e.DEPARTMENT_ID
FROM Employees e
WHERE e.SALARY > (
    SELECT AVG(SALARY) 
    FROM Employees 
    WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
);


Medium Tasks
1. Separate characters from 'tf56sd#%OqH'
DECLARE @str VARCHAR(50) = 'tf56sd#%OqH';

SELECT 
    (SELECT STRING_AGG(SUBSTRING(@str, n, 1), '') 
     FROM (SELECT number FROM master..spt_values WHERE type='P' AND number BETWEEN 1 AND LEN(@str)) AS nums(n)
     WHERE SUBSTRING(@str, n, 1) LIKE '[A-Z]') AS uppercase,
    
    (SELECT STRING_AGG(SUBSTRING(@str, n, 1), '') 
     FROM (SELECT number FROM master..spt_values WHERE type='P' AND number BETWEEN 1 AND LEN(@str)) AS nums(n)
     WHERE SUBSTRING(@str, n, 1) LIKE '[a-z]') AS lowercase,
    
    (SELECT STRING_AGG(SUBSTRING(@str, n, 1), '') 
     FROM (SELECT number FROM master..spt_values WHERE type='P' AND number BETWEEN 1 AND LEN(@str)) AS nums(n)
     WHERE SUBSTRING(@str, n, 1) LIKE '[0-9]') AS numbers,
    
    (SELECT STRING_AGG(SUBSTRING(@str, n, 1), '') 
     FROM (SELECT number FROM master..spt_values WHERE type='P' AND number BETWEEN 1 AND LEN(@str)) AS nums(n)
     WHERE SUBSTRING(@str, n, 1) NOT LIKE '[A-Z]' 
       AND SUBSTRING(@str, n, 1) NOT LIKE '[a-z]' 
       AND SUBSTRING(@str, n, 1) NOT LIKE '[0-9]') AS other_chars;

2. Split FullName into First, Middle, Last
SELECT 
    StudentID,
    FullName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS FirstName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS MiddleName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS LastName
FROM Students;

3. Customer orders to Texas after California delivery
SELECT o.*
FROM Orders o
WHERE o.CustomerID IN (
    SELECT CustomerID 
    FROM Orders 
    WHERE DeliveryState = 'CA'
)
AND o.DeliveryState = 'TX';

4. Transform product quantities to single units
WITH Numbers AS (
    SELECT n = 1
    UNION ALL SELECT n + 1 FROM Numbers WHERE n < (SELECT MAX(Quantity) FROM Ungroup)
)
SELECT u.ProductDescription, n.n AS UnitNumber
FROM Ungroup u
JOIN Numbers n ON n.n <= u.Quantity
WHERE n <= (SELECT MAX(Quantity) FROM Ungroup)
ORDER BY u.ProductDescription, n.n
OPTION (MAXRECURSION 100);

5. Group concatenate values
SELECT STRING_AGG(String, ' ') WITHIN GROUP (ORDER BY SequenceNumber) AS concatenated_string
FROM DMLTable;

6. Employment Stage based on HIRE_DATE
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
       CASE 
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 5 AND 10 THEN 'Mid-Level'
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 20 THEN 'Senior'
           ELSE 'Veteran'
       END AS EmploymentStage
FROM Employees;

7. Employees with salary > department average
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.SALARY, e.DEPARTMENT_ID
FROM Employees e
WHERE e.SALARY > (
    SELECT AVG(SALARY) 
    FROM Employees 
    WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
    GROUP BY DEPARTMENT_ID
);

8. Employees with names containing "a" and salary divisible by 5
SELECT *
FROM Employees
WHERE CONCAT(FIRST_NAME, LAST_NAME) LIKE '%a%'
  AND SALARY % 5 = 0;

9. Department employees count and percentage with >3 years
SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) AS employees_over_3_years,
    CAST(SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS percentage_over_3_years
FROM Employees
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID;

10. Most and least experienced Spaceman by job
WITH RankedSpacemen AS (
    SELECT 
        SpacemanID,
        JobDescription,
        MissionCount,
        RANK() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS rank_most_exp,
        RANK() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS rank_least_exp
    FROM Personal
)
SELECT 
    JobDescription,
    MAX(CASE WHEN rank_most_exp = 1 THEN SpacemanID END) AS most_experienced,
    MAX(CASE WHEN rank_least_exp = 1 THEN SpacemanID END) AS least_experienced
FROM RankedSpacemen
GROUP BY JobDescription;


Difficult Tasks
1. Replace row with sum of current and previous row
WITH NumberedStudents AS (
    SELECT 
        StudentID,
        FullName,
        Grade,
        ROW_NUMBER() OVER (ORDER BY StudentID) AS row_num
    FROM Students
)
SELECT 
    s1.StudentID,
    s1.FullName,
    s1.Grade + ISNULL(s2.Grade, 0) AS cumulative_grade
FROM NumberedStudents s1
LEFT JOIN NumberedStudents s2 ON s1.row_num = s2.row_num + 1
ORDER BY s1.StudentID;

2. Employee depth from president
WITH EmployeeHierarchy AS (
    -- Anchor member: President (no manager)
    SELECT 
        EmployeeID,
        ManagerID,
        JobTitle,
        0 AS depth
    FROM Employee
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive member: Employees with managers
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        eh.depth + 1
    FROM Employee e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy
ORDER BY depth, EmployeeID;

3. Sum mathematical equations
-- This requires dynamic SQL or CLR function in SQL Server
-- Here's an approach using a temporary table and dynamic SQL

-- Create a temp table to store results
CREATE TABLE #EquationResults (
    Equation VARCHAR(200),
    TotalSum INT
);

-- Use dynamic SQL to evaluate each equation
DECLARE @sql NVARCHAR(MAX);
DECLARE @equation VARCHAR(200);

DECLARE equation_cursor CURSOR FOR 
SELECT Equation FROM Equations;

OPEN equation_cursor;
FETCH NEXT FROM equation_cursor INTO @equation;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'INSERT INTO #EquationResults (Equation, TotalSum) 
                 SELECT ''' + @equation + ''', ' + @equation;
    
    BEGIN TRY
        EXEC sp_executesql @sql;
    END TRY
    BEGIN CATCH
        -- Handle invalid equations if needed
        INSERT INTO #EquationResults (Equation, TotalSum)
        VALUES (@equation, NULL);
    END CATCH
    
    FETCH NEXT FROM equation_cursor INTO @equation;
END

CLOSE equation_cursor;
DEALLOCATE equation_cursor;

-- Return the results
SELECT * FROM #EquationResults;

-- Clean up
DROP TABLE #EquationResults;

4. Students with same birthday
SELECT s1.StudentName AS student1, s2.StudentName AS student2, s1.Birthday
FROM Student s1
JOIN Student s2 ON s1.Birthday = s2.Birthday AND s1.StudentName < s2.StudentName
ORDER BY s1.Birthday;

5. Total score for each unique player pair
WITH UniquePairs AS (
    SELECT 
        CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS player1,
        CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS player2
    FROM PlayerScores
    GROUP BY 
        CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
        CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END
)
SELECT 
    p.player1,
    p.player2,
    SUM(ps.Score) AS total_score
FROM UniquePairs p
LEFT JOIN PlayerScores ps ON 
    (ps.PlayerA = p.player1 AND ps.PlayerB = p.player2) OR
    (ps.PlayerA = p.player2 AND ps.PlayerB = p.player1)
GROUP BY p.player1, p.player2
ORDER BY p.player1, p.player2;
