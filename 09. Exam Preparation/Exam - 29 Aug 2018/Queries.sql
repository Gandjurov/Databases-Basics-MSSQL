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


