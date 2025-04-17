Easy Tasks Solutions
1.List all staff members from the Staff table:
SELECT * FROM vwStaff;

2.Create a view vwItemPrices:
CREATE VIEW vwItemPrices AS
SELECT ItemID, ItemName, Price FROM Items;

3.Create and populate temporary table #TempPurchases:
CREATE TABLE #TempPurchases (
    PurchaseID INT,
    ClientID INT,
    ItemID INT,
    Quantity INT,
    PurchaseDate DATE
);

INSERT INTO #TempPurchases VALUES 
(1, 101, 1001, 2, '2023-01-15'),
(2, 102, 1002, 1, '2023-01-16');

4.Declare temporary variable for current month revenue:
DECLARE @currentRevenue DECIMAL(10,2);
SELECT @currentRevenue = SUM(TotalAmount) 
FROM Purchases 
WHERE MONTH(PurchaseDate) = MONTH(GETDATE()) 
AND YEAR(PurchaseDate) = YEAR(GETDATE());

5.Scalar function fnSquare:
CREATE FUNCTION fnSquare(@num INT)
RETURNS INT
AS
BEGIN
    RETURN @num * @num;
END;

6.Stored procedure spGetClients:
CREATE PROCEDURE spGetClients
AS
BEGIN
    SELECT * FROM Clients;
END;

7.MERGE statement for Purchases and Clients:
MERGE INTO Purchases AS target
USING Clients AS source
ON target.ClientID = source.ClientID
WHEN MATCHED THEN
    UPDATE SET target.ClientName = source.ClientName;

8.Temporary table #StaffInfo:
CREATE TABLE #StaffInfo (
    StaffID INT,
    StaffName VARCHAR(100),
    Department VARCHAR(50)
);

INSERT INTO #StaffInfo VALUES 
(1, 'John Smith', 'Sales'),
(2, 'Jane Doe', 'Marketing');

9.Function fnEvenOdd:
CREATE FUNCTION fnEvenOdd(@num INT)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CASE WHEN @num % 2 = 0 THEN 'Even' ELSE 'Odd' END;
END;

10.Stored procedure spMonthlyRevenue:
CREATE PROCEDURE spMonthlyRevenue
    @month INT,
    @year INT
AS
BEGIN
    SELECT SUM(TotalAmount) AS TotalRevenue
    FROM Purchases
    WHERE MONTH(PurchaseDate) = @month AND YEAR(PurchaseDate) = @year;
END;


Medium Tasks Solutions
1.View vwClientOrderHistory:
CREATE VIEW vwClientOrderHistory AS
SELECT c.ClientID, c.ClientName, p.PurchaseID, p.PurchaseDate, p.TotalAmount
FROM Clients c
JOIN Purchases p ON c.ClientID = p.ClientID;

2.Temporary table #YearlyItemSales:
CREATE TABLE #YearlyItemSales (
    ItemID INT,
    ItemName VARCHAR(100),
    TotalQuantity INT,
    TotalRevenue DECIMAL(10,2)
);

INSERT INTO #YearlyItemSales
SELECT i.ItemID, i.ItemName, SUM(p.Quantity), SUM(p.Quantity * i.Price)
FROM Items i
JOIN Purchases p ON i.ItemID = p.ItemID
WHERE YEAR(p.PurchaseDate) = YEAR(GETDATE())
GROUP BY i.ItemID, i.ItemName;

3.Stored procedure spUpdatePurchaseStatus:
CREATE PROCEDURE spUpdatePurchaseStatus
    @PurchaseID INT,
    @NewStatus VARCHAR(50)
AS
BEGIN
    UPDATE Purchases
    SET Status = @NewStatus
    WHERE PurchaseID = @PurchaseID;
END;

4.MERGE statement for Purchases table:
MERGE INTO Purchases AS target
USING #NewPurchases AS source
ON target.PurchaseID = source.PurchaseID
WHEN MATCHED THEN
    UPDATE SET 
        target.ClientID = source.ClientID,
        target.ItemID = source.ItemID,
        target.Quantity = source.Quantity,
        target.PurchaseDate = source.PurchaseDate
WHEN NOT MATCHED THEN
    INSERT (PurchaseID, ClientID, ItemID, Quantity, PurchaseDate)
    VALUES (source.PurchaseID, source.ClientID, source.ItemID, source.Quantity, source.PurchaseDate);

5.Temporary variable @avgItemSale:
DECLARE @avgItemSale DECIMAL(10,2);
SELECT @avgItemSale = AVG(Quantity * Price)
FROM Purchases p
JOIN Items i ON p.ItemID = i.ItemID
WHERE p.ItemID = 1001; -- Example item ID

6.View vwItemOrderDetails:
CREATE VIEW vwItemOrderDetails AS
SELECT p.PurchaseID, i.ItemName, p.Quantity, (p.Quantity * i.Price) AS TotalPrice
FROM Purchases p
JOIN Items i ON p.ItemID = i.ItemID;

7.Function fnCalcDiscount:
CREATE FUNCTION fnCalcDiscount(
    @amount DECIMAL(10,2),
    @discountPercent DECIMAL(5,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @amount * (@discountPercent / 100);
END;

8.Stored procedure spDeleteOldPurchases:
CREATE PROCEDURE spDeleteOldPurchases
    @cutoffDate DATE
AS
BEGIN
    DELETE FROM Purchases
    WHERE PurchaseDate < @cutoffDate;
END;


Difficult Tasks Solutions
1.Stored procedure spTopSalesStaff:
CREATE PROCEDURE spTopSalesStaff
    @year INT
AS
BEGIN
    SELECT TOP 1 s.StaffID, s.StaffName, SUM(p.TotalAmount) AS TotalRevenue
    FROM Staff s
    JOIN Purchases p ON s.StaffID = p.StaffID
    WHERE YEAR(p.PurchaseDate) = @year
    GROUP BY s.StaffID, s.StaffName
    ORDER BY TotalRevenue DESC;
END;

2.View vwClientOrderStats:
CREATE VIEW vwClientOrderStats AS
SELECT 
    c.ClientID, 
    c.ClientName, 
    COUNT(p.PurchaseID) AS NumberOfPurchases,
    SUM(p.TotalAmount) AS TotalPurchaseValue
FROM Clients c
LEFT JOIN Purchases p ON c.ClientID = p.ClientID
GROUP BY c.ClientID, c.ClientName;

3.Complex MERGE statement for Purchases and Items:
MERGE INTO Purchases AS target
USING (
    SELECT p.PurchaseID, p.ItemID, p.Quantity, i.Price, 
           (p.Quantity * i.Price) AS CalculatedTotal
    FROM #NewPurchases p
    JOIN Items i ON p.ItemID = i.ItemID
) AS source
ON target.PurchaseID = source.PurchaseID
WHEN MATCHED AND target.TotalAmount <> source.CalculatedTotal THEN
    UPDATE SET 
        target.ItemID = source.ItemID,
        target.Quantity = source.Quantity,
        target.TotalAmount = source.CalculatedTotal
WHEN NOT MATCHED THEN
    INSERT (PurchaseID, ItemID, Quantity, TotalAmount, PurchaseDate)
    VALUES (source.PurchaseID, source.ItemID, source.Quantity, source.CalculatedTotal, GETDATE());

4.Function fnMonthlyRevenue:
CREATE FUNCTION fnMonthlyRevenue(
    @year INT,
    @month INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @result DECIMAL(10,2);
    
    SELECT @result = SUM(TotalAmount)
    FROM Purchases
    WHERE YEAR(PurchaseDate) = @year AND MONTH(PurchaseDate) = @month;
    
    RETURN ISNULL(@result, 0);
END;

5.Stored procedure spProcessOrderTotals:
CREATE PROCEDURE spProcessOrderTotals
    @PurchaseID INT,
    @DiscountPercent DECIMAL(5,2) = 0,
    @TaxRate DECIMAL(5,2) = 0
AS
BEGIN
    DECLARE @Subtotal DECIMAL(10,2);
    DECLARE @DiscountAmount DECIMAL(10,2);
    DECLARE @TaxAmount DECIMAL(10,2);
    DECLARE @TotalAmount DECIMAL(10,2);
    
    -- Calculate subtotal
    SELECT @Subtotal = Quantity * Price
    FROM Purchases p
    JOIN Items i ON p.ItemID = i.ItemID
    WHERE p.PurchaseID = @PurchaseID;
    
    -- Calculate discount
    SET @DiscountAmount = @Subtotal * (@DiscountPercent / 100);
    
    -- Calculate tax
    SET @TaxAmount = (@Subtotal - @DiscountAmount) * (@TaxRate / 100);
    
    -- Calculate total
    SET @TotalAmount = @Subtotal - @DiscountAmount + @TaxAmount;
    
    -- Update purchase record
    UPDATE Purchases
    SET 
        Subtotal = @Subtotal,
        DiscountAmount = @DiscountAmount,
        TaxAmount = @TaxAmount,
        TotalAmount = @TotalAmount,
        Status = 'Processed'
    WHERE PurchaseID = @PurchaseID;
    
    -- Return results
    SELECT 
        @Subtotal AS Subtotal,
        @DiscountAmount AS DiscountAmount,
        @TaxAmount AS TaxAmount,
        @TotalAmount AS TotalAmount;
END;
