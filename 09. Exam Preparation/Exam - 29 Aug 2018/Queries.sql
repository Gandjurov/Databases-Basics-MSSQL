-- DDL PART --

--CREATE DATABASE Supermarket

--USE Supermarket

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Items
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	Price DECIMAL(15,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
	Phone CHAR(12) NOT NULL,
	Salary DECIMAL(15,2) NOT NULL
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY,
	[DateTime] DATETIME NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
)

CREATE TABLE OrderItems
(
	OrderId INT FOREIGN KEY REFERENCES Orders(Id) NOT NULL,
	ItemId INT FOREIGN KEY REFERENCES Items(Id) NOT NULL,
	Quantity INT CHECK(Quantity >= 1) NOT NULL

	PRIMARY KEY (OrderId, ItemId)
)

CREATE TABLE Shifts
(
	Id INT IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CheckIn DATETIME NOT NULL,
	CheckOut DATETIME NOT NULL

	PRIMARY KEY (Id, EmployeeId)
)

ALTER TABLE Shifts
ADD CONSTRAINT CH_CheckInCheckOut CHECK(CheckIn < CheckOut)

--DML PART --
--INSERTs
INSERT INTO Employees (FirstName, LastName, Phone, Salary) VALUES
('Stoyan', 'Petrov', '888-785-8573', 500.25),
('Stamat', 'Nikolov', '789-613-1122', 999995.25),
('Evgeni', 'Petkov', '645-369-9517', 1234.51),
('Krasimir', 'Vidolov',	'321-471-9982',	50.25)

INSERT INTO Items ([Name], Price, CategoryId) VALUES
('Tesla battery', 154.25, 8),
('Chess', 30.25, 8),
('Juice', 5.32,	1),
('Glasses',	10,	8),
('Bottle of water',	1, 1)

--UPDATE
--Make all items’ prices 27% more expensive where the category ID is either 1, 2 or 3.
UPDATE Items
   SET Price *= 1.27
 WHERE CategoryId IN(1,2,3)

--check how records will be affected
--SELECT COUNT(*)
--  FROM Items
-- WHERE CategoryId IN(1,2,3)

--DELETE
--Delete all order items where the order id is 48 (be careful with the relationships)
DELETE FROM OrderItems
WHERE OrderId = 48

DELETE FROM Orders
WHERE Id = 48

GO
--Querying
--05. Richest People 
SELECT Id, FirstName 
  FROM Employees
 WHERE Salary > 6500
ORDER BY FirstName, Id
GO

--06. Cool Phone Numbers 
SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name], Phone AS [Phone Number]
  FROM Employees
 WHERE LEFT(Phone, 1) IN (3)
ORDER BY FirstName, Phone
GO

--07. Employee Statistics 
EXEC sp_changedbowner 'sa'
SELECT e.FirstName, e.LastName, COUNT(o.Id) AS [Count]
  FROM Employees AS e
  JOIN Orders AS o ON o.EmployeeId = e.Id
GROUP BY e.FirstName, e.LastName
ORDER BY [Count] DESC, e.FirstName
GO

--08. Hard Workers Club
SELECT e.FirstName, 
       e.LastName, 
	   AVG(DATEDIFF(HOUR, s.CheckIn, s.CheckOut)) AS [Work hours]
  FROM Employees AS e
  JOIN Shifts AS s ON s.EmployeeId = e.Id
GROUP BY e.Id, e.FirstName, e.LastName
HAVING AVG(DATEDIFF(HOUR, s.CheckIn, s.CheckOut)) > 7
ORDER BY [Work hours] DESC, e.Id
GO

--9. The Most Expensive Order
SELECT TOP 1 oi.OrderId, SUM(i.Price * oi.Quantity) AS TotalPrice
  FROM OrderItems AS oi 
  JOIN Items AS i ON i.Id = oi.ItemId
GROUP BY oi.OrderId
ORDER BY TotalPrice DESC
GO

--10. Rich Item, Poor Item 
SELECT TOP(10) oi.OrderId
		, MAX(i.Price) AS ExpensivePrice
		, MIN(i.Price) AS CheapPrice
  FROM OrderItems AS oi 
  JOIN Items AS i ON i.Id = oi.ItemId
GROUP BY oi.OrderId
ORDER BY ExpensivePrice DESC, oi.OrderId
GO

--11. Cashiers
SELECT DISTINCT e.Id, FirstName, LastName
  FROM Employees AS e
  JOIN Orders AS o ON o.EmployeeId = e.Id
ORDER BY e.Id
GO

--12. Lazy Employees 
SELECT DISTINCT e.Id, 
       CONCAT(e.FirstName, ' ', e.LastName) AS [Full Name]
  FROM Employees AS e
  JOIN Shifts AS s ON s.EmployeeId = e.Id
 WHERE DATEDIFF(HOUR, s.CheckIn, s.CheckOut) < 4
ORDER BY e.Id

--13. Sellers 
SELECT TOP(10) CONCAT(e.FirstName, ' ', e.LastName) AS [Full Name],
	   SUM(i.Price * oi.Quantity) AS [Total Price],
	   SUM(oi.Quantity) AS [Items]
  FROM Employees AS e
  JOIN Orders AS o ON o.EmployeeId = e.Id
  JOIN OrderItems AS oi ON oi.OrderId = o.Id
  JOIN Items AS i ON i.Id = oi.ItemId
 WHERE o.DateTime < '2018-06-15'
GROUP BY e.FirstName, e.LastName
ORDER BY [Total Price] DESC, [Items] DESC
GO

--14. Tough days
   SELECT CONCAT(e.FirstName, ' ', e.LastName) AS [Full Name]
          ,DATENAME(WEEKDAY, s.CheckIn) AS [Day of week]
     FROM Employees AS e
LEFT JOIN Orders AS o ON o.EmployeeId = e.Id
     JOIN Shifts AS s ON s.EmployeeId = e.Id
 WHERE o.EmployeeId IS NULL AND DATEDIFF(HOUR, s.CheckIn, s.CheckOut) > 12
 ORDER BY e.Id
GO

--15. Top Order per Employee 
SELECT k.FullName
       ,DATEDIFF(HOUR, s.CheckIn, s.CheckOut) AS [WorkHours]
       ,k.[Total Price]
  FROM (
   SELECT o.Id AS OrderId
          ,e.Id AS EmployeeId
		  ,o.DateTime
          ,CONCAT(e.FirstName, ' ', e.LastName) AS [FullName]
		  ,SUM(i.Price * oi.Quantity) AS [Total Price]
		  ,ROW_NUMBER() OVER (PARTITION BY e.Id ORDER BY SUM(i.Price * oi.Quantity) DESC) AS RowNumber
     FROM Employees AS e
     JOIN Orders AS o ON o.EmployeeId = e.Id
     JOIN OrderItems AS oi ON oi.OrderId = o.Id
     JOIN Items AS i ON i.Id = oi.ItemId
 GROUP BY o.Id, e.FirstName, e.LastName, e.Id, o.DateTime) AS k
     JOIN Shifts AS s ON s.EmployeeId = k.EmployeeId
 WHERE k.RowNumber = 1 AND k.DateTime BETWEEN s.CheckIn AND s.CheckOut
 ORDER BY [FullName], [WorkHours] DESC, k.[Total Price] DESC
GO

--16. Average Profit per Day 
SELECT DATEPART(DAY, o.DateTime) AS [DayOfMonth]
	   ,FORMAT(AVG(i.Price * oi.Quantity), 'N2') AS AveragePrice
  FROM Orders AS o
  JOIN OrderItems AS oi ON oi.OrderId = o.Id
  JOIN Items AS i ON i.Id = oi.ItemId
GROUP BY DATEPART(DAY, o.DateTime)
ORDER BY [DayOfMonth]
GO

--17. Top Products 
   SELECT i.Name AS [Item]
   	     ,c.Name AS [Category]
   	     ,SUM(oi.Quantity) AS [Count]
   	     ,SUM(oi.Quantity * i.Price) AS [TotalPrice]
     FROM Items AS i
     JOIN Categories AS c ON c.Id = i.CategoryId
LEFT JOIN OrderItems AS oi ON oi.ItemId = i.Id
 GROUP BY i.Name, c.Name
 ORDER BY TotalPrice DESC, [Count] DESC
GO

--18. Promotion Days 
CREATE FUNCTION udf_GetPromotedProducts(@CurrentDate DATETIME
									   ,@StartDate DATETIME
									   ,@EndDate DATETIME
									   ,@Discount DECIMAL(15,2)
									   ,@FirstItemId INT
									   ,@SecondItemId INT
									   ,@ThirdItemId INT)
RETURNS VARCHAR(MAX)
BEGIN
	DECLARE @firstItemName VARCHAR(50) = (SELECT [Name] FROM Items WHERE Id = @FirstItemId)
	DECLARE @secondItemName VARCHAR(50) = (SELECT [Name] FROM Items WHERE Id = @SecondItemId)
	DECLARE @thirdItemName VARCHAR(50) = (SELECT [Name] FROM Items WHERE Id = @ThirdItemId)

	IF(@firstItemName IS NULL OR @thirdItemName IS NULL OR @thirdItemName IS NULL)
	BEGIN
		RETURN 'One of the items does not exists!'
	END

	IF(@CurrentDate NOT BETWEEN @StartDate AND @EndDate)
	BEGIN
		RETURN 'The current date is not within the promotion dates!'
	END

	DECLARE @firstItemPrice DECIMAL(15,2) = (SELECT Price FROM Items WHERE Id = @FirstItemId)
	DECLARE @secondItemPrice DECIMAL(15,2) = (SELECT Price FROM Items WHERE Id = @SecondItemId)
	DECLARE @thirdItemPrice DECIMAL(15,2) = (SELECT Price FROM Items WHERE Id = @ThirdItemId)

	SET @firstItemPrice = @firstItemPrice - (@firstItemPrice * (@Discount / 100))
	SET @secondItemPrice = @secondItemPrice - (@secondItemPrice * (@Discount / 100))
	SET @thirdItemPrice = @thirdItemPrice - (@thirdItemPrice * (@Discount / 100))

	RETURN @firstItemName + ' price: ' + CAST(@firstItemPrice AS VARCHAR(10)) + ' <-> ' +
	       @secondItemName + ' price: ' + CAST(@secondItemPrice AS VARCHAR(10)) + ' <-> ' +
		   @thirdItemName + ' price: ' + CAST(@thirdItemPrice AS VARCHAR(10)) + ' <-> '
END
GO

SELECT dbo.udf_GetPromotedProducts('2018-08-02', '2018-08-01', '2018-08-03',13, 3,4,5)

SELECT dbo.udf_GetPromotedProducts('2018-08-01', '2018-08-02', '2018-08-03',13,3 ,4,5)
GO

--19. Cancel Order 


--20. Deleted Orders 
