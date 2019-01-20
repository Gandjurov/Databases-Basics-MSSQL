-- 02 Find All Information About Departments From SoftUni
SELECT * 
  FROM Departments

-- 03 Find all Department Names 
SELECT [Name] 
  FROM Departments

-- 04 Find Salary of Each Employee 
SELECT FirstName, LastName, Salary
  FROM Employees

-- 05. Find Full Name of Each Employee 
SELECT FirstName, MiddleName, LastName
  FROM Employees

-- 06. Find Email Address of Each Employee 
SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address]
  FROM Employees

-- 07. Find All Different Employee�s Salaries 
SELECT DISTINCT Salary
  FROM Employees

-- 08. Find all Information About Employees 
SELECT *
  FROM Employees
 WHERE JobTitle = 'Sales Representative'

-- 09. Find Names of All Employees by Salary in Range
SELECT FirstName, LastName, JobTitle 
  FROM Employees
 WHERE Salary BETWEEN 20000 AND 30000

-- 10. Find Names of All Employees 
SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
  FROM Employees
 WHERE Salary IN (25000,14000,12500,23600) 

-- 11. Find All Employees Without Manager 

-- 12. Find All Employees with Salary More Than 

-- 13. Find 5 Best Paid Employees 

-- 14. Find All Employees Except Marketing

-- 15. Sort Employees Table 

-- 16. Create View Employees with Salaries 

-- 17. Create View Employees with Job Titles 

-- 18. Distinct Job Titles 

-- 19. Find First 10 Started Projects 

-- 20. Last 7 Hired Employees 

-- 21. Increase Salaries 

-- 22. All Mountain Peaks 

-- 23. Biggest Countries by Population 

-- 24. Countries and Currency (Euro / Not Euro) 

-- 25. All Diablo Characters 















