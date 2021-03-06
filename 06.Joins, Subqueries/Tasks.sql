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
LEFT JOIN EmployeesProjects AS p ON e.EmployeeID = p.EmployeeID
WHERE p.ProjectID IS NULL
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
SELECT e.EmployeeID, e.FirstName, e.ManagerID, e2.FirstName AS ManagerName
  FROM Employees AS e
  JOIN Employees AS e2 ON e2.EmployeeID = e.ManagerID AND e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

--10. Employees Summary 
SELECT TOP 50 e.EmployeeID, 
	   CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
	   CONCAT(e2.FirstName, ' ', e2.LastName) AS ManagerName,
	   d.[Name] AS DepartmentName
  FROM Employees AS e
  JOIN Employees AS e2 ON e2.EmployeeID = e.ManagerID
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID

--11. Min Average Salary 
SELECT 
	MIN(a.AvarageSalary) AS MinAvarageSalary
	FROM
	(
		SELECT e.DepartmentID,
			   AVG(e.Salary) AS AvarageSalary
		  FROM Employees AS e
	  GROUP BY e.DepartmentID
	) AS a

--12. Highest Peaks in Bulgaria 
exec sp_changedbowner 'sa'

SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
  FROM Countries AS c
  JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode AND c.CountryCode = 'BG'
  JOIN Mountains AS m ON m.Id = mc.MountainId
  JOIN Peaks AS p ON p.MountainId = mc.MountainId AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--13. Count Mountain Ranges 
SELECT c.CountryCode, COUNT(mc.MountainId) AS MountainRanges
  FROM Countries AS c
  JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode AND c.CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.CountryCode

--14. Countries With or Without Rivers 
SELECT TOP 5 c.CountryName, r.RiverName
  FROM Rivers AS r
  JOIN CountriesRivers AS rc ON r.Id = rc.RiverId
 RIGHT OUTER JOIN Countries AS c ON c.CountryCode = rc.CountryCode
 WHERE c.ContinentCode = 'AF'
 ORDER BY c.CountryName

--15. Continents and Currencies
SELECT 
		MostUsedCurrency.ContinentCode,
		MostUsedCurrency.CurrencyCode,
		MostUsedCurrency.CurrencyUsage
  FROM  (
  SELECT c.ContinentCode,
         c.CurrencyCode,
		 COUNT(c.CurrencyCode) AS CurrencyUsage,
		 DENSE_RANK() OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [CurrencyRank]
	FROM Countries AS c
GROUP BY c.ContinentCode, c.CurrencyCode
  HAVING COUNT(c.CurrencyCode) > 1
) AS MostUsedCurrency
   WHERE MostUsedCurrency.CurrencyRank = 1
ORDER BY MostUsedCurrency.ContinentCode, MostUsedCurrency.CurrencyUsage

--16. Countries Without any Mountains 
SELECT COUNT(c.CountryCode) AS [CountryCode]
FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS m ON c.CountryCode = m.CountryCode
WHERE m.MountainId IS NULL

--17. Highest Peak and Longest River by Country
SELECT TOP (5) c.CountryName, MAX(p.Elevation) AS MaxElevation, MAX(r.Length) AS MaxRiverLength
  FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
 GROUP BY c.CountryName
 ORDER BY MaxElevation DESC, MaxRiverLength DESC, c.CountryName


--18. Highest Peak Name and Elevation by Country
SELECT TOP(5) k.CountryName,
	   ISNULL(k.PeakName, '(no highest peak)'),
	   ISNULL(k.MaxElevation, 0),
	   ISNULL(k.MountainRange, '(no mountain)')
  FROM (
        SELECT c.CountryName,
			   MAX(p.Elevation) AS MaxElevation,
			   p.PeakName,
			   m.MountainRange,
			   DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY MAX(p.Elevation) DESC) AS ElevationRank
		  FROM Countries AS c
	 LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
	 LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
	 LEFT JOIN Peaks AS p ON p.MountainId = m.Id
	  GROUP BY c.CountryName, p.PeakName, m.MountainRange) AS k
WHERE k.ElevationRank = 1
ORDER BY k.CountryName, k.PeakName



