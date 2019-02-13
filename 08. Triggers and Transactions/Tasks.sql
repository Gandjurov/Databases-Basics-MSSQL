--CREATING BANK DATABASE
CREATE DATABASE Bank
GO
USE Bank
GO
CREATE TABLE AccountHolders
(
Id INT NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
SSN CHAR(10) NOT NULL
CONSTRAINT PK_AccountHolders PRIMARY KEY (Id)
)

CREATE TABLE Accounts
(
Id INT NOT NULL,
AccountHolderId INT NOT NULL,
Balance MONEY DEFAULT 0
CONSTRAINT PK_Accounts PRIMARY KEY (Id)
CONSTRAINT FK_Accounts_AccountHolders FOREIGN KEY (AccountHolderId) REFERENCES AccountHolders(Id)
)

INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (1, 'Susan', 'Cane', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (2, 'Kim', 'Novac', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (3, 'Jimmy', 'Henderson', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (4, 'Steve', 'Stevenson', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (5, 'Bjorn', 'Sweden', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (6, 'Kiril', 'Petrov', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (7, 'Petar', 'Kirilov', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (8, 'Michka', 'Tsekova', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (9, 'Zlatina', 'Pateva', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (10, 'Monika', 'Miteva', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (11, 'Zlatko', 'Zlatyov', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (12, 'Petko', 'Petkov Junior', '1234567890');

INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (1, 1, 123.12);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (2, 3, 4354.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (3, 12, 6546543.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (4, 9, 15345.64);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (5, 11, 36521.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (6, 8, 5436.34);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (7, 10, 565649.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (8, 11, 999453.50);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (9, 1, 5349758.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (10, 2, 543.30);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (11, 3, 10.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (12, 7, 245656.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (13, 5, 5435.32);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (14, 4, 1.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (15, 6, 0.19);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (16, 2, 5345.34);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (17, 11, 76653.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (18, 1, 235469.89);

--14. Create Table Logs 
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
	OldSum DECIMAL(15,2),
	NewSum DECIMAL(15,2)
)
GO

CREATE TRIGGER tr_InsertAccountInfo ON Accounts FOR UPDATE
AS
DECLARE @newSum DECIMAL(15,2) = (SELECT Balance FROM inserted)
DECLARE @oldSum DECIMAL(15,2) = (SELECT Balance FROM deleted)
DECLARE @accountId INT = (SELECT Id FROM inserted)

INSERT INTO Logs (AccountId, NewSum, OldSum) VALUES
(
	@accountId,
	@newSum,
	@oldSum
)
GO

UPDATE Accounts
SET Balance += 10
WHERE Id = 1

SELECT *
  FROM Accounts WHERE Id = 1

SELECT *
  FROM Logs
GO
--15. Create Table Emails 
CREATE TABLE NotificationEmails
( 
   Id INT PRIMARY KEY IDENTITY
  ,Recipient INT FOREIGN KEY REFERENCES Accounts(Id)
  ,Subject VARCHAR(50)
  ,Body VARCHAR(MAX)
)
GO

CREATE TRIGGER tr_LogEMail ON Logs FOR INSERT
AS
DECLARE @accountId INT = (SELECT TOP(1) AccountId FROM inserted)
DECLARE @oldSum DECIMAL(15,2) = (SELECT TOP(1) OldSum FROM inserted)
DECLARE @newSum DECIMAL(15,2) = (SELECT TOP(1) NewSum FROM inserted)

INSERT INTO NotificationEmails(Recipient, Subject, Body) VALUES
(
@accountId,
'Balance change for account: ' + CAST(@accountId AS VARCHAR(20)),
'On ' + CONVERT(VARCHAR(30), GETDATE(), 103) + ' your balance was changed from ' + 
CAST(@oldSum AS VARCHAR(20)) + ' to ' + CAST(@newSum AS VARCHAR(20))
)

SELECT * 
FROM Accounts
WHERE Id = 1

UPDATE Accounts
SET Balance += 100
WHERE Id = 1
GO

--16. Deposit Money 
CREATE PROC usp_DepositMoney @accountId INT, @moneyAmount DECIMAL(15,4)
AS
BEGIN TRANSACTION

DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @accountId)

IF(@account IS NULL)
BEGIN
	ROLLBACK
	RAISERROR('Invalid account Id!', 16, 1)
	RETURN
END

IF(@moneyAmount < 0)
BEGIN 
	ROLLBACK
	RAISERROR('Negative amount!', 16, 2)
	RETURN
END

UPDATE Accounts
SET Balance += @moneyAmount
WHERE Id = @accountId

COMMIT
GO

EXEC usp_DepositMoney 1, 166.88

SELECT *
  FROM Accounts
 WHERE Id = 1
GO
--17. Withdraw Money Procedure 
CREATE OR ALTER PROC usp_WithdrawMoney @accountId INT, @moneyAmount DECIMAL(15,4)
AS
BEGIN TRANSACTION

DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @accountId)
DECLARE @accountBalance DECIMAL(15,4) = (SELECT Balance FROM Accounts WHERE Id = @accountId)

IF(@account IS NULL)
BEGIN
	ROLLBACK
	RAISERROR('Invalid account Id!', 16, 1)
	RETURN
END

IF(@moneyAmount < 0)
BEGIN 
	ROLLBACK
	RAISERROR('Negative amount!', 16, 2)
	RETURN
END

IF(@accountBalance - @moneyAmount < 0)
BEGIN 
	ROLLBACK
	RAISERROR('Insufficient funds!', 16, 3)
	RETURN
END

UPDATE Accounts
SET Balance -= @moneyAmount
WHERE Id = @accountId

COMMIT
GO

EXEC usp_DepositMoney 1, 600

SELECT *
  FROM Accounts
 WHERE Id = 1
GO

--18. Money Transfer 
CREATE PROC usp_TransferMoney (@senderId INT, @receiverId INT, @amount DECIMAL(15,4))
AS
BEGIN TRANSACTION

EXEC usp_WithdrawMoney @senderId, @amount
EXEC usp_DepositMoney @receiverId, @amount

COMMIT
GO

EXEC usp_TransferMoney 1, 2, 600
GO

SELECT *
  FROM Accounts
 WHERE Id = 1 OR Id = 2
GO

--20. *Massive Shopping 
USE Diablo

CREATE PROC usp_BuyItems(@Username VARCHAR(100)) AS
BEGIN
	DECLARE @UserId INT = (SELECT Id FROM Users WHERE Username = @Username)
	DECLARE @GameId INT = (SELECT Id FROM Games WHERE Name = 'Bali')
	DECLARE @UserGameId INT = (SELECT Id FROM UsersGames WHERE UserId = @UserId AND GameId = @GameId)
	DECLARE @UserGameLevel INT = (SELECT Level FROM UsersGames WHERE Id = @UserGameId)

	DECLARE @counter INT = 251

	WHILE(@counter <= 539)
	BEGIN
		DECLARE @ItemId INT = @counter
		DECLARE @ItemPrice MONEY = (SELECT Price FROM Items WHERE Id = @ItemId)
		DECLARE @ItemLevel INT = (SELECT MinLevel FROM Items WHERE Id = @ItemId)
		DECLARE @UserGameCash MONEY = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)

		IF(@UserGameCash >= @ItemPrice AND @UserGameLevel >= @ItemLevel)
		BEGIN
			UPDATE UsersGames
			SET Cash -= @ItemPrice
			WHERE Id = @UserGameId

			INSERT INTO UserGameItems VALUES
			(@ItemId, @UserGameId)
		END

		SET @counter += 1
		
		IF(@counter = 300)
		BEGIN
			SET @counter = 501
		END
	END
END

EXEC usp_BuyItems 'baleremuda'
EXEC usp_BuyItems 'loosenoise'
EXEC usp_BuyItems 'inguinalself'
EXEC usp_BuyItems 'buildingdeltoid'
EXEC usp_BuyItems 'monoxidecos'
GO

SELECT * FROM Users AS u
JOIN UsersGames AS ug
ON u.Id = ug.UserId
JOIN Games AS g
ON ug.GameId = g.Id
JOIN UserGameItems AS ugi
ON ug.Id = ugi.UserGameId
JOIN Items AS i
ON ugi.ItemId = i.Id
WHERE g.Name = 'Bali'
ORDER BY u.Username, i.Name
GO


DECLARE @UserId INT = (SELECT Id FROM Users WHERE Username = 'Stamat')
DECLARE @GameId INT = (SELECT Id FROM Games WHERE Name = 'Safflower')
DECLARE @UserGameId INT = (SELECT Id FROM UsersGames WHERE UserId = @UserId AND GameId = @GameId)
DECLARE @UserGameLevel INT = (SELECT Level FROM UsersGames WHERE Id = @UserGameId)
DECLARE @ItemStartLevel INT = 11
DECLARE @ItemEndLevel INT = 12
DECLARE @AllItemsPrice MONEY = (SELECT SUM(Price) FROM Items WHERE (MinLevel BETWEEN @ItemStartLevel AND @ItemEndLevel)) 
DECLARE @StamatCash MONEY = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)

IF(@StamatCash >= @AllItemsPrice)
BEGIN
	BEGIN TRAN	
		UPDATE UsersGames
		SET Cash -= @AllItemsPrice
		WHERE Id = @UserGameId
	
		INSERT INTO UserGameItems
		SELECT i.Id, @UserGameId  FROM Items AS i
		WHERE (i.MinLevel BETWEEN @ItemStartLevel AND @ItemEndLevel)
	COMMIT
END

SET @ItemStartLevel = 19
SET @ItemEndLevel = 21
SET @AllItemsPrice = (SELECT SUM(Price) FROM Items WHERE (MinLevel BETWEEN @ItemStartLevel AND @ItemEndLevel)) 
SET @StamatCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)

IF(@StamatCash >= @AllItemsPrice)
BEGIN
	BEGIN TRAN
		UPDATE UsersGames
		SET Cash -= @AllItemsPrice
		WHERE Id = @UserGameId
	
		INSERT INTO UserGameItems
		SELECT i.Id, @UserGameId  FROM Items AS i
		WHERE (i.MinLevel BETWEEN @ItemStartLevel AND @ItemEndLevel)
	COMMIT
END

SELECT i.Name AS [Item Name] FROM Users AS u
JOIN UsersGames AS ug
ON u.Id = ug.UserId
JOIN Games AS g
ON ug.GameId = g.Id
JOIN UserGameItems AS ugi
ON ug.Id = ugi.UserGameId
JOIN Items AS i
ON ugi.ItemId = i.Id
WHERE u.Username = 'Stamat' AND g.Name = 'Safflower'
ORDER BY i.Name

--21. Employees with Three Projects 
USE SoftUni
GO

CREATE PROC usp_AssignProject(@employeeId INT, @projectID INT) AS
BEGIN
	BEGIN TRAN
		INSERT INTO EmployeesProjects VALUES
		(@employeeId, @projectID)
		DECLARE @EmployeeProjectsCount INT = (SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeId = @employeeId)
		IF(@EmployeeProjectsCount > 3)
		BEGIN
			ROLLBACK
			RAISERROR('The employee has too many projects!', 16, 1)
			RETURN
		END
	COMMIT
END 

--22. Delete Employees 