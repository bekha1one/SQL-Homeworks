Easy Tasks:
1.Matching and non-matching items in Cart1 and Cart2:
SELECT 
    COALESCE(c1.Item, c2.Item) AS Item,
    CASE WHEN c1.Item IS NOT NULL THEN 'In Cart1' ELSE '' END AS Cart1,
    CASE WHEN c2.Item IS NOT NULL THEN 'In Cart2' ELSE '' END AS Cart2
FROM #Cart1 c1
FULL OUTER JOIN #Cart2 c2 ON c1.Item = c2.Item;

2.Average days between executions for each workflow:
SELECT 
    WorkFlow,
    AVG(DATEDIFF(DAY, prev_date, ExecutionDate)) AS AvgDaysBetweenExecutions
FROM (
    SELECT 
        WorkFlow, 
        ExecutionDate,
        LAG(ExecutionDate) OVER (PARTITION BY WorkFlow ORDER BY ExecutionDate) AS prev_date
    FROM #ProcessLog
) t
WHERE prev_date IS NOT NULL
GROUP BY WorkFlow;

3.Movies where Amitabh and Vinod acted together as actors:
SELECT m1.MName
FROM #Movie m1
JOIN #Movie m2 ON m1.MName = m2.MName
WHERE m1.AName = 'Amitabh' AND m1.Roles = 'Actor'
AND m2.AName = 'Vinod' AND m2.Roles = 'Actor';

4.Pivot phone numbers into separate columns:
SELECT 
    CustomerID,
    MAX(CASE WHEN [Type] = 'Cellular' THEN PhoneNumber END) AS Cellular,
    MAX(CASE WHEN [Type] = 'Work' THEN PhoneNumber END) AS Work,
    MAX(CASE WHEN [Type] = 'Home' THEN PhoneNumber END) AS Home
FROM #PhoneDirectory
GROUP BY CustomerID;

5.Numbers up to n divisible by 9:
DECLARE @n INT = 100;
WITH Numbers AS (
    SELECT 9 AS num
    UNION ALL
    SELECT num + 9 FROM Numbers WHERE num + 9 <= @n
)
SELECT num FROM Numbers
OPTION (MAXRECURSION 100);

6.Batch start and end lines:
SELECT 
    b.Batch,
    b.BatchStart AS StartLine,
    MIN(l.Line) AS EndLine
FROM #BatchStarts b
JOIN #BatchLines l ON b.Batch = l.Batch AND l.Line > b.BatchStart
WHERE l.Syntax LIKE '%GO%'
GROUP BY b.Batch, b.BatchStart;

7.Running balance of inventory:
SELECT 
    InventoryDate,
    QuantityAdjustment,
    SUM(QuantityAdjustment) OVER (ORDER BY InventoryDate) AS RunningBalance
FROM #Inventory
ORDER BY InventoryDate;

8.2nd highest salary:
SELECT MAX(Salary) AS SecondHighestSalary
FROM #NthHighest
WHERE Salary < (SELECT MAX(Salary) FROM #NthHighest);

9.Current, previous, and two years ago sales:
SELECT 
    [Year],
    Amount AS CurrentYearSales,
    LAG(Amount, 1) OVER (ORDER BY [Year]) AS PreviousYearSales,
    LAG(Amount, 2) OVER (ORDER BY [Year]) AS TwoYearsAgoSales
FROM #Sales
WHERE [Year] IN (YEAR(GETDATE()), YEAR(GETDATE())-1, YEAR(GETDATE())-2)
ORDER BY [Year] DESC;


Medium Tasks:
1.Boxes with same dimensions:
SELECT b1.Box, b2.Box
FROM #Boxes b1
JOIN #Boxes b2 ON 
    (b1.[Length] = b2.[Length] AND b1.Width = b2.Width AND b1.Height = b2.Height) OR
    (b1.[Length] = b2.[Length] AND b1.Width = b2.Height AND b1.Height = b2.Width) OR
    (b1.[Length] = b2.Width AND b1.Width = b2.[Length] AND b1.Height = b2.Height) OR
    (b1.[Length] = b2.Width AND b1.Width = b2.Height AND b1.Height = b2.[Length]) OR
    (b1.[Length] = b2.Height AND b1.Width = b2.[Length] AND b1.Height = b2.Width) OR
    (b1.[Length] = b2.Height AND b1.Width = b2.Width AND b1.Height = b2.[Length])
WHERE b1.Box < b2.Box;

2.Numbers table doubling until 100:
WITH Numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT CASE WHEN num * 2 < 100 THEN num * 2 ELSE num + 1 END
    FROM Numbers
    WHERE num < 100
)
SELECT num FROM Numbers
OPTION (MAXRECURSION 1000);

3.Unique statuses prior to current status:
SELECT 
    StepID,
    Workflow,
    [Status],
    COUNT(DISTINCT [Status]) OVER (PARTITION BY Workflow ORDER BY StepID) AS UniqueStatusesSoFar
FROM #WorkflowSteps;

4.Alternate male and female:
WITH Ordered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY GENDER ORDER BY ID) AS rn
    FROM #AlternateMaleFemale
)
SELECT ID, NAME, GENDER
FROM (
    SELECT ID, NAME, GENDER, rn * 2 - (CASE WHEN GENDER = 'M' THEN 1 ELSE 0 END) AS sort_order
    FROM Ordered
) t
ORDER BY sort_order;

5.Group consecutive steps with same status:
WITH Groups AS (
    SELECT *,
           StepNumber - ROW_NUMBER() OVER (PARTITION BY [Status] ORDER BY StepNumber) AS grp
    FROM #Groupings
)
SELECT 
    MIN(StepNumber) AS MinStep,
    MAX(StepNumber) AS MaxStep,
    [Status],
    COUNT(*) AS Count
FROM Groups
GROUP BY [Status], grp
ORDER BY MinStep;

6.Permutations of 0 and 1 with length n (n=3 example):
WITH bits AS (
    SELECT 0 AS b UNION ALL SELECT 1
),
permutations AS (
    SELECT CAST(b1.b AS VARCHAR(3)) + CAST(b2.b AS VARCHAR(3)) + CAST(b3.b AS VARCHAR(3)) AS perm
    FROM bits b1 CROSS JOIN bits b2 CROSS JOIN bits b3
)
SELECT perm FROM permutations;

7.Spouse group criteria key:
SELECT 
    s1.PrimaryID,
    s1.SpouseID,
    CASE WHEN s1.PrimaryID < s1.SpouseID THEN s1.PrimaryID + '-' + s1.SpouseID 
         ELSE s1.SpouseID + '-' + s1.PrimaryID END AS GroupKey
FROM #Spouses s1;

8.Previous CurrentQuota value:
SELECT 
    BusinessEntityID,
    SalesYear,
    CurrentQuota,
    LAG(CurrentQuota) OVER (PARTITION BY BusinessEntityID ORDER BY SalesYear) AS PreviousQuota
FROM lag;

9.Bowlers consistently next to each other:
WITH Positions AS (
    SELECT 
        GameID,
        Bowler,
        Score,
        ROW_NUMBER() OVER (PARTITION BY GameID ORDER BY Score DESC) AS Position
    FROM #BowlingResults
),
Pairs AS (
    SELECT 
        p1.GameID,
        p1.Bowler AS Bowler1,
        p2.Bowler AS Bowler2,
        ABS(p1.Position - p2.Position) AS PositionDiff
    FROM Positions p1
    JOIN Positions p2 ON p1.GameID = p2.GameID AND p1.Bowler < p2.Bowler
)
SELECT Bowler1, Bowler2
FROM Pairs
GROUP BY Bowler1, Bowler2
HAVING MAX(PositionDiff) = 1;

10.Prime numbers up to 100:
WITH Numbers AS (
    SELECT 2 AS num
    UNION ALL
    SELECT num + 1 FROM Numbers WHERE num < 100
)
SELECT num
FROM Numbers n
WHERE NOT EXISTS (
    SELECT 1 FROM Numbers m 
    WHERE m.num <= SQRT(n.num) AND n.num % m.num = 0 AND m.num <> n.num
)
OPTION (MAXRECURSION 100);


Difficult Tasks:
1.Permutations of 0 and 1 with length n (generalized solution):
-- For n=3 as example
WITH digits AS (
    SELECT 0 AS d UNION ALL SELECT 1
),
permutations AS (
    SELECT CAST(d1.d AS VARCHAR(MAX)) AS perm, 1 AS level
    FROM digits d1
    UNION ALL
    SELECT p.perm + CAST(d.d AS VARCHAR(MAX)), p.level + 1
    FROM permutations p
    CROSS JOIN digits d
    WHERE p.level < 3  -- Change this to desired length
)
SELECT perm FROM permutations WHERE level = 3
OPTION (MAXRECURSION 100);

2.Top half players value 1, others 2:
WITH RankedPlayers AS (
    SELECT 
        PlayerA AS Player,
        ROW_NUMBER() OVER (ORDER BY SUM(Score) DESC) AS rn,
        COUNT(*) OVER () AS total
    FROM #PlayerScores
    GROUP BY PlayerA
)
SELECT 
    Player,
    CASE WHEN rn <= total/2 THEN 1 ELSE 2 END AS Value
FROM RankedPlayers;

3.Break SQL statements into words with positions:
WITH Words AS (
    SELECT 
        QuoteId,
        value AS word,
        CHARINDEX(' ' + value + ' ', ' ' + String + ' ') - 1 AS start_pos,
        CHARINDEX(' ' + value + ' ', ' ' + String + ' ') + LEN(value) - 1 AS end_pos
    FROM #Strings
    CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(String, ';', ''), ',', ' '), ' ')
    WHERE value <> ''
)
SELECT 
    QuoteId,
    word,
    start_pos,
    end_pos
FROM Words
ORDER BY QuoteId, start_pos;

4.Permutations of n distinct numbers (n=3 example):
WITH numbers AS (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3  -- Change for different n
),
permutations AS (
    SELECT 
        CAST(n1.n AS VARCHAR(MAX)) + ',' + 
        CAST(n2.n AS VARCHAR(MAX)) + ',' + 
        CAST(n3.n AS VARCHAR(MAX)) AS perm
    FROM numbers n1
    CROSS JOIN numbers n2
    CROSS JOIN numbers n3
    WHERE n1.n <> n2.n AND n1.n <> n3.n AND n2.n <> n3.n
)
SELECT perm FROM permutations;

5.3-perfect numbers (numbers where sum of proper divisors equals 3 times the number):
WITH Numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1 FROM Numbers WHERE num < 10000  -- Adjust range as needed
),
Divisors AS (
    SELECT 
        n1.num AS number,
        n2.num AS divisor
    FROM Numbers n1
    JOIN Numbers n2 ON n1.num % n2.num = 0 AND n2.num < n1.num
),
SumDivisors AS (
    SELECT 
        number,
        SUM(divisor) AS sum_div
    FROM Divisors
    GROUP BY number
)
SELECT number
FROM SumDivisors
WHERE sum_div = 3 * number
OPTION (MAXRECURSION 10000);
