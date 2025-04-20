Easy Tasks Solutions
1.List items where price > average price
SELECT * FROM Items 
WHERE price > (SELECT AVG(price) FROM Items);

2.Staff in divisions with >10 employees
SELECT * FROM Staff 
WHERE division_id IN (
    SELECT division_id FROM Staff 
    GROUP BY division_id 
    HAVING COUNT(*) > 10
);

3.Staff earning more than division average
SELECT s1.* FROM Staff s1 
WHERE salary > (
    SELECT AVG(salary) FROM Staff s2 
    WHERE s2.division_id = s1.division_id
);

4.Clients who made purchases
SELECT * FROM Clients 
WHERE client_id IN (SELECT DISTINCT client_id FROM Purchases);

5.Purchases with at least one detail (EXISTS)
SELECT * FROM Purchases p 
WHERE EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    WHERE pd.purchase_id = p.purchase_id
);

6.Items sold >100 times
SELECT i.* FROM Items i 
WHERE item_id IN (
    SELECT item_id FROM PurchaseDetails 
    GROUP BY item_id 
    HAVING SUM(quantity) > 100
);

7.Staff earning > company average
SELECT * FROM Staff 
WHERE salary > (SELECT AVG(salary) FROM Staff);

8.Vendors supplying items <$50
SELECT DISTINCT v.* FROM Vendors v 
JOIN Items i ON v.vendor_id = i.vendor_id 
WHERE i.price < 50;

9.Maximum item price
SELECT MAX(price) FROM Items;

10.Highest total purchase value
SELECT MAX(total_amount) FROM Purchases;

11.Clients who never made purchases
SELECT * FROM Clients 
WHERE client_id NOT IN (
    SELECT DISTINCT client_id FROM Purchases
);

12.Items in Electronics category
SELECT * FROM Items WHERE category = 'Electronics';

13.Purchases after specified date
SELECT * FROM Purchases 
WHERE purchase_date > '2023-01-01';

14.Total items in a specific purchase
SELECT SUM(quantity) FROM PurchaseDetails 
WHERE purchase_id = 123;

15.Staff employed >5 years
SELECT * FROM Staff 
WHERE hire_date < DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR);

16.Staff earning > division average (correlated)
SELECT s1.* FROM Staff s1 
WHERE salary > (
    SELECT AVG(salary) FROM Staff s2 
    WHERE s2.division_id = s1.division_id
);

17.Purchases including an item (EXISTS)
SELECT p.* FROM Purchases p 
WHERE EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    JOIN Items i ON pd.item_id = i.item_id 
    WHERE pd.purchase_id = p.purchase_id
);

18.Clients with purchases in last 30 days
SELECT DISTINCT c.* FROM Clients c 
JOIN Purchases p ON c.client_id = p.client_id 
WHERE p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

19.Oldest item
SELECT * FROM Items 
ORDER BY production_date ASC LIMIT 1;

20.Staff not assigned to any division
SELECT * FROM Staff WHERE division_id IS NULL;


Medium Tasks Solutions
1.Staff in same division as high earners (>$100K)
SELECT * FROM Staff 
WHERE division_id IN (
    SELECT DISTINCT division_id FROM Staff 
    WHERE salary > 100000
);

2.Highest paid staff in each division
SELECT s.* FROM Staff s 
WHERE salary = (
    SELECT MAX(salary) FROM Staff s2 
    WHERE s2.division_id = s.division_id
);

3.Clients who never bought >$200 items
SELECT c.* FROM Clients c 
WHERE NOT EXISTS (
    SELECT 1 FROM Purchases p 
    JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
    JOIN Items i ON pd.item_id = i.item_id 
    WHERE p.client_id = c.client_id AND i.price > 200
);

4.Items ordered more than average
SELECT i.* FROM Items i 
WHERE (
    SELECT SUM(pd.quantity) FROM PurchaseDetails pd 
    WHERE pd.item_id = i.item_id
) > (
    SELECT AVG(item_count) FROM (
        SELECT SUM(quantity) as item_count 
        FROM PurchaseDetails 
        GROUP BY item_id
    ) as counts
);

5.Clients with >3 purchases
SELECT c.* FROM Clients c 
WHERE (
    SELECT COUNT(*) FROM Purchases p 
    WHERE p.client_id = c.client_id
) > 3;

6.Items ordered by client in last 30 days
SELECT c.client_id, c.client_name, 
(
    SELECT SUM(pd.quantity) 
    FROM Purchases p 
    JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
    WHERE p.client_id = c.client_id 
    AND p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
) as items_ordered 
FROM Clients c;

7.Staff earning > division average (correlated)
SELECT s1.* FROM Staff s1 
WHERE salary > (
    SELECT AVG(salary) FROM Staff s2 
    WHERE s2.division_id = s1.division_id
);

8.Items never ordered
SELECT i.* FROM Items i 
WHERE NOT EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    WHERE pd.item_id = i.item_id
);

9.Vendors supplying items > average price
SELECT DISTINCT v.* FROM Vendors v 
JOIN Items i ON v.vendor_id = i.vendor_id 
WHERE i.price > (SELECT AVG(price) FROM Items);

10.Total sales per item in past year
SELECT i.item_id, i.item_name, 
(
    SELECT SUM(pd.quantity * pd.unit_price) 
    FROM PurchaseDetails pd 
    JOIN Purchases p ON pd.purchase_id = p.purchase_id 
    WHERE pd.item_id = i.item_id 
    AND p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
) as yearly_sales 
FROM Items i;

11.Staff older than company average age
SELECT * FROM Staff 
WHERE birth_date < (
    SELECT DATE_SUB(CURRENT_DATE, INTERVAL AVG(DATEDIFF(CURRENT_DATE, birth_date)/365) YEAR) 
    FROM Staff
);

12.Items > average price
SELECT * FROM Items 
WHERE price > (SELECT AVG(price) FROM Items);

13.Clients who bought from specific category
SELECT DISTINCT c.* FROM Clients c 
JOIN Purchases p ON c.client_id = p.client_id 
JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
JOIN Items i ON pd.item_id = i.item_id 
WHERE i.category = 'Electronics';

14.Items with stock > average
SELECT * FROM Items 
WHERE quantity_in_stock > (SELECT AVG(quantity_in_stock) FROM Items);

15.Staff in same division as bonus recipients
SELECT s.* FROM Staff s 
WHERE division_id IN (
    SELECT DISTINCT division_id FROM Staff 
    WHERE bonus_received = TRUE
);

16.Top 10% salary earners
SELECT * FROM Staff 
WHERE salary >= (
    SELECT salary FROM (
        SELECT salary, NTILE(10) OVER (ORDER BY salary DESC) as percentile 
        FROM Staff
    ) as ranked 
    WHERE percentile = 1 
    LIMIT 1
);

17.Division with most staff
SELECT d.* FROM Divisions d 
WHERE d.division_id = (
    SELECT division_id FROM Staff 
    GROUP BY division_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

18.Purchase with highest total value
SELECT * FROM Purchases 
ORDER BY total_amount DESC LIMIT 1;

19.Staff earning > division avg with >5 years service
SELECT s1.* FROM Staff s1 
WHERE salary > (
    SELECT AVG(salary) FROM Staff s2 
    WHERE s2.division_id = s1.division_id
) 
AND hire_date < DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR);

20.Clients never bought >$100 items
SELECT c.* FROM Clients c 
WHERE NOT EXISTS (
    SELECT 1 FROM Purchases p 
    JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
    JOIN Items i ON pd.item_id = i.item_id 
    WHERE p.client_id = c.client_id AND i.price > 100
);


Difficult Tasks Solutions
1.Staff earning > division average but not the highest
SELECT s1.* FROM Staff s1 
WHERE salary > (
    SELECT AVG(salary) FROM Staff s2 
    WHERE s2.division_id = s1.division_id
)
AND salary < (
    SELECT MAX(salary) FROM Staff s3 
    WHERE s3.division_id = s1.division_id
);

2.Items purchased by clients with >5 orders
SELECT DISTINCT i.* FROM Items i 
JOIN PurchaseDetails pd ON i.item_id = pd.item_id 
JOIN Purchases p ON pd.purchase_id = p.purchase_id 
WHERE p.client_id IN (
    SELECT client_id FROM Purchases 
    GROUP BY client_id 
    HAVING COUNT(*) > 5
);

3.Staff older than average and earning > average
SELECT * FROM Staff 
WHERE birth_date < (
    SELECT DATE_SUB(CURRENT_DATE, INTERVAL AVG(DATEDIFF(CURRENT_DATE, birth_date)/365) YEAR) 
    FROM Staff
)
AND salary > (SELECT AVG(salary) FROM Staff);

4.Staff in divisions with >5 high earners (>$100K)
SELECT s.* FROM Staff s 
WHERE division_id IN (
    SELECT division_id FROM Staff 
    WHERE salary > 100000 
    GROUP BY division_id 
    HAVING COUNT(*) > 5
);

5.Items not purchased in past year
SELECT i.* FROM Items i 
WHERE NOT EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    JOIN Purchases p ON pd.purchase_id = p.purchase_id 
    WHERE pd.item_id = i.item_id 
    AND p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
);

6.Clients with purchases from ≥2 categories
SELECT c.* FROM Clients c 
WHERE (
    SELECT COUNT(DISTINCT i.category) 
    FROM Purchases p 
    JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
    JOIN Items i ON pd.item_id = i.item_id 
    WHERE p.client_id = c.client_id
) >= 2;

7.Staff earning > average for their position
SELECT s1.* FROM Staff s1 
WHERE salary > (
    SELECT AVG(salary) FROM Staff s2 
    WHERE s2.position = s1.position
);

8.Top 10% priced items
SELECT * FROM (
    SELECT *, NTILE(10) OVER (ORDER BY price DESC) as percentile 
    FROM Items
) as ranked 
WHERE percentile = 1;

9.Top 10% earners in each division
SELECT s.* FROM (
    SELECT *, NTILE(10) OVER (PARTITION BY division_id ORDER BY salary DESC) as percentile 
    FROM Staff
) as s 
WHERE s.percentile = 1;

10.Staff with no bonus in last 6 months
SELECT s.* FROM Staff s 
WHERE NOT EXISTS (
    SELECT 1 FROM Bonuses b 
    WHERE b.staff_id = s.staff_id 
    AND b.bonus_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
);

11.Items ordered more than average frequency
SELECT i.* FROM Items i 
WHERE (
    SELECT COUNT(*) FROM PurchaseDetails pd 
    WHERE pd.item_id = i.item_id
) > (
    SELECT AVG(order_count) FROM (
        SELECT COUNT(*) as order_count 
        FROM PurchaseDetails 
        GROUP BY item_id
    ) as counts
);

12.Clients who bought >avg priced items last year
SELECT DISTINCT c.* FROM Clients c 
JOIN Purchases p ON c.client_id = p.client_id 
JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
JOIN Items i ON pd.item_id = i.item_id 
WHERE p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
AND i.price > (SELECT AVG(price) FROM Items);

13.Division with highest average salary
SELECT d.* FROM Divisions d 
WHERE d.division_id = (
    SELECT division_id FROM Staff 
    GROUP BY division_id 
    ORDER BY AVG(salary) DESC 
    LIMIT 1
);

14.Items purchased by clients with >10 orders
SELECT DISTINCT i.* FROM Items i 
JOIN PurchaseDetails pd ON i.item_id = pd.item_id 
JOIN Purchases p ON pd.purchase_id = p.purchase_id 
WHERE p.client_id IN (
    SELECT client_id FROM Purchases 
    GROUP BY client_id 
    HAVING COUNT(*) > 10
);

15.Staff in division with highest sales
SELECT s.* FROM Staff s 
WHERE s.division_id = (
    SELECT d.division_id FROM Divisions d 
    JOIN Staff s ON d.division_id = s.division_id 
    JOIN Purchases p ON s.staff_id = p.staff_id 
    GROUP BY d.division_id 
    ORDER BY SUM(p.total_amount) DESC 
    LIMIT 1
);

16.Top 5% salary earners company-wide
SELECT * FROM (
    SELECT *, NTILE(20) OVER (ORDER BY salary DESC) as percentile 
    FROM Staff
) as ranked 
WHERE percentile = 1;

17.Items not purchased in past month
SELECT i.* FROM Items i 
WHERE NOT EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    JOIN Purchases p ON pd.purchase_id = p.purchase_id 
    WHERE pd.item_id = i.item_id 
    AND p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
);

18.Staff in same division as top purchasers
SELECT s.* FROM Staff s 
WHERE division_id IN (
    SELECT division_id FROM Staff 
    WHERE staff_id IN (
        SELECT staff_id FROM Purchases 
        GROUP BY staff_id 
        ORDER BY SUM(total_amount) DESC 
        LIMIT 5
    )
);

19.Inactive clients (no purchases in 6 months, spent <$100)
SELECT c.* FROM Clients c 
WHERE NOT EXISTS (
    SELECT 1 FROM Purchases p 
    WHERE p.client_id = c.client_id 
    AND p.purchase_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
)
AND (
    SELECT COALESCE(SUM(total_amount), 0) FROM Purchases p 
    WHERE p.client_id = c.client_id
) < 100;

20.Long-term staff (>10 years) who made >$1000 purchases
SELECT DISTINCT s.* FROM Staff s 
JOIN Purchases p ON s.staff_id = p.staff_id 
JOIN PurchaseDetails pd ON p.purchase_id = pd.purchase_id 
JOIN Items i ON pd.item_id = i.item_id 
WHERE s.hire_date < DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR)
AND (pd.quantity * pd.unit_price) > 1000;
