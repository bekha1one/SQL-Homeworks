CREATE DATABASE HomeworkDB;

USE HomeworkDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(50),
    Age INT,
    GPA DECIMAL(3,2)
);

Select * from Students

ALTER TABLE Students  
ADD Email VARCHAR(50);

sp_rename 'Students.FullName', 'Name', 'COLUMN';

ALTER TABLE Students  
DROP COLUMN Age;

INSERT INTO Students (StudentID, Name, GPA, Email)  
VALUES  
(1, 'Ivan Petrov', 3.8, 'ivan.petrov@example.com'),  
(2, 'Maria Ivanova', 3.5, 'maria.ivanova@example.com'),  
(3, 'Alex Smirnov', 3.9, 'alex.smirnov@example.com'),  
(4, 'Elena Kuznetsova', 3.7, 'elena.kuznetsova@example.com'),  
(5, 'Dmitry Sokolov', 3.4, 'dmitry.sokolov@example.com');

TRUNCATE TABLE Students;

SELECT @@SERVERNAME AS ServerName;

SELECT GETDATE() AS CurrentDateTime;
