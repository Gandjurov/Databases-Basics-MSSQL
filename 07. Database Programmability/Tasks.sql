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