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