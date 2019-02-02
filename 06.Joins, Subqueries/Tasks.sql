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


--05. Employees Without Projects 


--06. Employees Hired After 


--07. Employees With Project 


--08. Employee 24 


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



