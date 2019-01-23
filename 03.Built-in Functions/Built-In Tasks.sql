--01. Find Names of All Employees by First Name
SELECT FirstName, LastName
  FROM Employees
 WHERE FirstName LIKE 'SA%'

--02. Find Names of All Employees by Last Name 
SELECT FirstName, LastName
  FROM Employees
 WHERE LastName LIKE '%ei%'

--03. Find First Names of All Employess
SELECT FirstName
  FROM Employees
 WHERE DepartmentID IN (3, 10) AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

--04. Find All Employees Except Engineers 
SELECT FirstName, LastName
  FROM Employees
 WHERE JobTitle NOT LIKE '%engineer%'

--05. Find Towns with Name Length 
SELECT Name
  FROM Towns
 WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name]

--06. Find Towns Starting With 
  SELECT TownId, [Name]
    FROM Towns
   WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--07. Find Towns Not Starting With 
  SELECT TownId, [Name]
    FROM Towns
   WHERE [Name] LIKE '[^RBD]%'
ORDER BY [Name]
GO

--08. Create View Employees Hired After 
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
  FROM Employees
 WHERE DATEPART(YEAR, HireDate) > 2000
GO

SELECT * FROM V_EmployeesHiredAfter2000

--09. Length of Last Name 
SELECT FirstName, LastName
  FROM Employees
 WHERE LEN(LastName) = 5

--10. Rank Employees by Salary 


--11. Find All Employees with Rank 2


--12. Countries Holding 'A'
USE Geography

  SELECT CountryName, IsoCode
    FROM Countries
   WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

--13. Mix of Peak and River Names 


--14. Games From 2011 and 2012 Year


--15. User Email Providers 


--16. Get Users with IPAddress Like Pattern 


--17. Show All Games with Duration


--18. Orders Table