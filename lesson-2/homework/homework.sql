🟢 Easy-Level Tasks
1. Define and explain DDL and DML. Give two examples of each.
DDL (Data Definition Language): Commands used to define database structure.

Examples: CREATE TABLE, ALTER TABLE

DML (Data Manipulation Language): Commands used to manipulate data.

Examples: INSERT, UPDATE

2. Create Employees table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);

3. Insert three records
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
    (1, 'John Smith', 5000.00),
    (2, 'Jane Doe', 6500.00),
    (3, 'Mike Johnson', 7200.00);

4. Update Salary
UPDATE Employees
SET Salary = 5500.00
WHERE EmpID = 1;

5. Delete a record
DELETE FROM Employees
WHERE EmpID = 2;

6. Difference between DELETE, DROP, and TRUNCATE
DELETE: Removes specific rows (can use WHERE), logs each row deletion
DELETE FROM Employees WHERE EmpID = 1;

TRUNCATE: Removes all rows, resets identity, faster than DELETE
TRUNCATE TABLE Employees;

DROP: Removes entire table structure and data
DROP TABLE Employees;

7. Modify Name column
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

8. Add Department column
ALTER TABLE Employees
ADD Department VARCHAR(50);

9. SSMS - Create CompanyDB
Note: Screenshot would be provided showing the database creation in SSMS

10. Purpose of TRUNCATE TABLE
TRUNCATE TABLE quickly removes all rows from a table while keeping the table structure intact. It's faster than DELETE as it doesn't log individual row deletions and resets identity counters.


🟠 Medium-Level Tasks
11. Create Departments table with FK
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    ManagerID INT FOREIGN KEY REFERENCES Employees(EmpID)
);

12. Insert into Departments using INSERT SELECT
INSERT INTO Departments (DeptID, DeptName, ManagerID)
SELECT 
    ROW_NUMBER() OVER (ORDER BY EmpID),
    CASE WHEN Salary > 6000 THEN 'Management' ELSE 'General' END,
    EmpID
FROM Employees
WHERE EmpID IN (1, 2, 3, 4, 5);

13. Update Department based on Salary
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

14. Remove all records without removing structure
TRUNCATE TABLE Employees;

15. VARCHAR vs NVARCHAR
VARCHAR: Stores non-Unicode characters (1 byte per character)

NVARCHAR: Stores Unicode characters (2 bytes per character), needed for multilingual data

16. Change Salary to FLOAT
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

17. Drop Department column
ALTER TABLE Employees
DROP COLUMN Department;

18. SSMS - Add JoinDate column
Note: Screenshot would be provided showing the column addition in SSMS

19. Create temporary table
CREATE TABLE #TempEmployees (
    TempID INT,
    TempName VARCHAR(50)
);

INSERT INTO #TempEmployees VALUES (1, 'Temp1'), (2, 'Temp2');

20. Remove Departments table
DROP TABLE Departments;


🔴 Hard-Level Tasks
21. Customers table with CHECK constraint
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age > 18),
    Email VARCHAR(100)
);

22. Delete employees without salary increase
DELETE FROM Employees
WHERE EmpID NOT IN (
    SELECT DISTINCT EmpID 
    FROM SalaryHistory
    WHERE ChangeDate >= DATEADD(YEAR, -2, GETDATE())
);

23. Stored procedure to insert employee
CREATE PROCEDURE sp_InsertEmployee
    @EmpID INT,
    @Name VARCHAR(100),
    @Salary DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Employees (EmpID, Name, Salary)
    VALUES (@EmpID, @Name, @Salary);
END;

24. Create backup table
SELECT * INTO Employees_Backup
FROM Employees
WHERE 1=0; -- Creates empty table with same structure

25. MERGE INTO for multiple rows
MERGE INTO Employees AS target
USING Employees_Updates AS source
ON target.EmpID = source.EmpID
WHEN MATCHED THEN
    UPDATE SET 
        target.Name = source.Name,
        target.Salary = source.Salary
WHEN NOT MATCHED THEN
    INSERT (EmpID, Name, Salary)
    VALUES (source.EmpID, source.Name, source.Salary);

26. Drop and recreate CompanyDB
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CompanyDB')
    DROP DATABASE CompanyDB;
GO

CREATE DATABASE CompanyDB;
GO

27. SSMS - Rename Employees table
Note: Screenshot would be provided showing the table rename in SSMS

28. CASCADE DELETE vs CASCADE UPDATE
CASCADE DELETE: When parent record is deleted, child records are automatically deleted

CASCADE UPDATE: When parent key is updated, child foreign keys are automatically updated

Example:
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

29. Reset IDENTITY seed
DBCC CHECKIDENT ('Employees', RESEED, 0);

30. Table with PK and UNIQUE constraints
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductCode VARCHAR(20) UNIQUE,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);
