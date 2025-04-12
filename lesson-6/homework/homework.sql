Puzzle 1: Finding Distinct Values
Solution 1: Using DISTINCT
SELECT DISTINCT col1, col2 
FROM InputTbl;

Solution 2: Using GROUP BY
SELECT col1, col2
FROM InputTbl
GROUP BY col1, col2;

Solution 3: Using ROW_NUMBER()
WITH RankedData AS (
    SELECT 
        col1, 
        col2,
        ROW_NUMBER() OVER (PARTITION BY col1, col2 ORDER BY col1) AS rn
    FROM InputTbl
)
SELECT col1, col2
FROM RankedData
WHERE rn = 1;


Puzzle 2: Removing Rows with All Zeroes
SELECT A, B, C, D
FROM TestMultipleZero
WHERE A <> 0 OR B <> 0 OR C <> 0 OR D <> 0;

Alternative solution:
SELECT A, B, C, D
FROM TestMultipleZero
WHERE NOT (A = 0 AND B = 0 AND C = 0 AND D = 0);


Puzzle 3: Find those with odd ids
SELECT id, name
FROM section1
WHERE id % 2 = 1;

Alternative solution:
SELECT id, name
FROM section1
WHERE id % 2 <> 0;


Puzzle 4: Person with the smallest id
SELECT TOP 1 id, name
FROM section1
ORDER BY id ASC;

Alternative solution:
SELECT id, name
FROM section1
WHERE id = (SELECT MIN(id) FROM section1);


Puzzle 5: Person with the highest id
SELECT TOP 1 id, name
FROM section1
ORDER BY id DESC;

Alternative solution:
SELECT id, name
FROM section1
WHERE id = (SELECT MAX(id) FROM section1);


Puzzle 6: People whose name starts with b
SELECT id, name
FROM section1
WHERE name LIKE 'b%';

Case-insensitive version:
SELECT id, name
FROM section1
WHERE LOWER(name) LIKE 'b%';


Puzzle 7: Rows where code contains underscore
SELECT Code
FROM ProductCodes
WHERE Code LIKE '%\_%' ESCAPE '\';

Alternative solution:
SELECT Code
FROM ProductCodes
WHERE CHARINDEX('_', Code) > 0;
