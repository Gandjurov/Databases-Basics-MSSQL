--01. Find Names of All Employees by First Name
SELECT FirstName, LastName
  FROM Employees
 WHERE FirstName LIKE 'SA%'

--02. Find Names of All Employees by Last Name 
SELECT FirstName, LastName
  FROM Employees
 WHERE LastName LIKE '%ei%'

--03. Find First Names of All Employess
SELECT *
  FROM Employees

--04. Find All Employees Except Engineers 
SELECT FirstName, LastName
  FROM Employees
 WHERE JobTitle not like '%engineer%'

--05. Find Towns with Name Length 


--06. Find Towns Starting With 


--07. Find Towns Not Starting With 


--08. Create View Employees Hired After 


--09. Length of Last Name 


--10. Rank Employees by Salary 


--11. Find All Employees with Rank 2


--12. Countries Holding 'A'


--13. Mix of Peak and River Names 


--14. Games From 2011 and 2012 Year


--15. User Email Providers 


--16. Get Users with IPAddress Like Pattern 


--17. Show All Games with Duration


--18. Orders Table