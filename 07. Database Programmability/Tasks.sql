--01. Employees with Salary Above 35000 
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName
  FROM Employees
 WHERE Salary > 35000

GO
--02. Employees with Salary Above Number 
CREATE PROC usp_GetEmployeesSalaryAboveNumber @InputNumber DECIMAL(18,4)
AS
SELECT FirstName, LastName
  FROM Employees
 WHERE Salary >= @InputNumber

 GO
--03. Town Names Starting With 
CREATE PROC usp_GetTownsStartingWith @input VARCHAR(10)
AS
SELECT Name
  FROM Towns
 WHERE Name LIKE @input + '%'

  GO
--04. Employees from Town 
CREATE PROC usp_GetEmployeesFromTown @TownName VARCHAR(MAX)
AS
SELECT e.FirstName, e.LastName
  FROM Employees AS e
  JOIN Addresses AS a ON a.AddressID = e.AddressID
  JOIN Towns AS t ON t.TownID = a.TownID
 WHERE t.Name = @TownName

EXEC usp_GetEmployeesFromTown 'Sofia'
GO
--05. Salary Level Function 
CREATE FUNCTION ufn_GetSalaryLevel(@salary INT)
RETURNS NVARCHAR(10)
AS
BEGIN
 DECLARE @salaryLevel VARCHAR(10)
 IF(@salary < 30000)
	SET @salaryLevel = 'Low'
 ELSE IF(@salary <= 50000)
	SET @salaryLevel = 'Average'
 ELSE
    SET @salaryLevel = 'High'

RETURN @salaryLevel
END
GO

--06. Employees by Salary Level 
CREATE PROC usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(10)
AS 
SELECT FirstName, LastName
  FROM Employees
 WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

EXEC usp_EmployeesBySalaryLevel 'Low'
EXEC usp_EmployeesBySalaryLevel 'Average'
EXEC usp_EmployeesBySalaryLevel 'High'
GO

--07. Define Function 
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
BEGIN
DECLARE @count INT = 1

WHILE(@count <= LEN(@word))
BEGIN
	DECLARE @currentLatter CHAR(1) = SUBSTRING(@word, @count,1)
	DECLARE @charIndex INT = CHARINDEX(@currentLatter, @setOfLetters)

	IF(@charIndex = 0)
	BEGIN
		RETURN 0
	END

	SET @count += 1
END
RETURN 1
END

GO

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')

--08. Delete Employees and Departments 

--Steps:
--alter table departments set ManagerID column null
--delete from employeesProjects
--update departments set managerID column = null
--delete from employees where departmentID = departmentID
--delete from deparment where id = @id

CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentID INT)
AS
ALTER TABLE Departments
ALTER TABLE ManagerID INT

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentID)

UPDATE Departments
SET ManagerID = NULL
WHERE DepartmentID = @departmentID

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentID)

DELETE FROM Employees
WHERE DepartmentID = @departmentID

DELETE FROM Departments
WHERE DepartmentID = @departmentID

SELECT COUNT(*)
  FROM Employees
 WHERE DepartmentID = @departmentID

--09. Find Full Name 
USE Bank
GO 

CREATE OR ALTER PROC usp_GetHoldersFullName AS
SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name] 
  FROM AccountHolders

EXEC usp_GetHoldersFullName

GO
--10. People with Balance Higher Than 
CREATE PROC usp_GetHoldersWithBalanceHigherThan @inputNumber DECIMAL(18,4)
AS
SELECT k.FirstName, k.LastName
  FROM (
SELECT ah.FirstName, ah.LastName
  FROM AccountHolders AS ah
  JOIN Accounts AS a ON a.AccountHolderId = ah.Id
GROUP BY ah.Id, ah.FirstName, ah.LastName
HAVING SUM(a.Balance) > @inputNumber ) AS k
ORDER BY k.FirstName, k.LastName

EXEC usp_GetHoldersWithBalanceHigherThan 50000

--11. Future Value Function 
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18,4)
BEGIN
	RETURN @sum * POWER((1 + @yearlyInterestRate), @numberOfYears)
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--12. Calculating Interest 
CREATE PROC usp_CalculateFutureValueForAccount @accountId INT, @interestRate FLOAT
AS
SELECT a.Id, ah.FirstName, ah.LastName, a.Balance, dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5)
  FROM Accounts AS a
  JOIN AccountHolders AS ah ON ah.Id = a.AccountHolderId
 WHERE a.Id = @accountId

EXEC usp_CalculateFutureValueForAccount 1, 0.1 

--13. *Cash in User Games Odd Rows 
USE Diablo

EXEC sp_changedbowner 'sa'
GO 

CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(MAX))
RETURNS TABLE
RETURN (SELECT SUM(k.Cash) AS TotalCash
  FROM (
SELECT g.Name, ug.Cash,
       ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
  FROM Games AS g
  JOIN UsersGames AS ug ON ug.GameId = g.Id
 WHERE g.Name = @gameName) AS k
 WHERE k.RowNumber % 2 = 1)

GO

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')
