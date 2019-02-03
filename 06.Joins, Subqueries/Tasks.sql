--01. Employee Address 
SELECT TOP 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
ORDER BY a.AddressID

--02. Addresses with Towns 
SELECT TOP 50 FirstName, LastName, [Name] AS Town, AddressText FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY FirstName, LastName

--03. Sales Employees 
SELECT EmployeeID, FirstName, LastName, d.Name AS DeparmentName FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID AND d.[Name] IN ('Sales')
ORDER BY EmployeeID

--04. Employee Departments 
SELECT TOP 5 EmployeeID, FirstName, Salary, d.Name AS DeparmentName FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID AND e.Salary > 15000
ORDER BY e.DepartmentID

--05. Employees Without Projects 
SELECT DISTINCT TOP 3 e.EmployeeID, e.FirstName
  FROM Employees AS e
RIGHT OUTER JOIN EmployeesProjects AS p ON e.EmployeeID NOT IN (SELECT DISTINCT EmployeeID FROM EmployeesProjects)
ORDER BY e.EmployeeID

--06. Employees Hired After 
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID 
		AND e.HireDate > '1999-01-01' 
		AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate

--07. Employees With Project 
SELECT * FROM Projects

SELECT TOP 5 e.EmployeeID, e.FirstName, p.[Name] AS ProjectName
  FROM Employees AS e
  JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p ON ep.ProjectID = p.ProjectID AND p.StartDate > '2002-08-13'
ORDER BY e.EmployeeID

--08. Employee 24 
SELECT e.EmployeeID, e.FirstName,
		CASE
			WHEN p.StartDate >= '2005-01-01' THEN NULL
			ELSE p.Name
		END AS ProjectName
		FROM Employees AS e
  JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID AND e.EmployeeID = 24
  JOIN Projects AS p ON p.ProjectID = ep.ProjectID

--09. Employee Manager 


--10. Employees Summary 


--11. Min Average Salary 


--12. Highest Peaks in Bulgaria 


--13. Count Mountain Ranges 


--14. Countries With or Without Rivers 


--15. Continents and Currencies


--16. Countries Without any Mountains 


--17. Highest Peak and Longest River by Country


--18. Highest Peak Name and Elevation by Country



