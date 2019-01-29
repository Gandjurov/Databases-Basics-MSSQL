--01. Records’ Count 
SELECT COUNT(*)
  FROM WizzardDeposits

--02. Longest Magic Wand 
SELECT MAX(MagicWandSize) AS LongestMagicWand
  FROM WizzardDeposits

--03. Longest Magic Wand per Deposit Groups 
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
  FROM WizzardDeposits
GROUP BY DepositGroup

--04. Smallest Deposit Group per Magic Wand Size
SELECT TOP(2) DepositGroup
  FROM WizzardDeposits
GROUP BY DepositGroup 
ORDER BY AVG(MagicWandSize)
 
--05. Deposits Sum 
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
  FROM WizzardDeposits
GROUP BY DepositGroup 

--06. Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander Family'
GROUP BY DepositGroup

--07. Deposits Filter 
SELECT *
  FROM WizzardDeposits

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander Family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY [TotalSum] DESC

--08. Deposit Charge 
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
  FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

--09. Age Groups 
SELECT *, COUNT(*) AS WizardCount FROM
(
	SELECT 
		CASE
		WHEN Age <= 10 THEN '[0-10]'
		WHEN Age between 11 and 20 THEN '[11-20]'
		WHEN Age between 21 and 30 THEN '[21-30]'
		WHEN Age between 31 and 40 THEN '[31-40]'
		WHEN Age between 41 and 50 THEN '[41-50]'
		WHEN Age between 51 and 60 THEN '[51-60]'
		ELSE '[61+]'
	  END AS AgeGroup 
	 FROM WizzardDeposits
) AS t
GROUP BY AgeGroup
ORDER BY AgeGroup

--10. First Letter 
SELECT LEFT(FirstName, 1) AS FirstLetter
  FROM WizzardDeposits
 WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)

--11. Average Interest 
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AvarageInterest
  FROM WizzardDeposits
 WHERE YEAR(DepositStartDate) >= 1985
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--12. Rich Wizard, Poor Wizard

--First Way
--SELECT SUM(k.Diff) AS SumDifference
--  FROM (
--		SELECT wd.DepositAmount - (SELECT w.DepositAmount FROM WizzardDeposits AS w WHERE w.Id = wd.Id + 1) AS Diff
--		FROM WizzardDeposits AS wd
--	   ) AS k

--Second Way
SELECT SUM (k.SumDiff) AS SumDifference
  FROM (
		SELECT DepositAmount - LEAD(DepositAmount, 1) OVER (ORDER BY Id) AS SumDiff
		  FROM WizzardDeposits
	   ) AS k

--13. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSum
  FROM Employees
GROUP BY DepartmentID

--14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS TotalSum
  FROM Employees
 WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01/01/2000'
GROUP BY DepartmentID

--15. Employees Average Salaries 
SELECT * INTO NewEmployeeTable
  FROM Employees
 WHERE Salary > 30000

DELETE FROM NewEmployeeTable
 WHERE ManagerID = 42

UPDATE NewEmployeeTable
   SET Salary += 5000
 WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary
 FROM NewEmployeeTable
GROUP BY DepartmentID

--16. Employees Maximum Salaries 
SELECT DepartmentID, MAX(Salary) AS MaxSalary
  FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17. Employees Count Salaries 
SELECT COUNT(*)
  FROM Employees
 WHERE ManagerID IS NULL

--18. 3rd Highest Salary
SELECT DISTINCT k.DepartmentID, k.Salary
  FROM (
		SELECT DepartmentID, Salary, DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS SalaryRank
		  FROM Employees
       ) AS k
 WHERE k.SalaryRank = 3

--19. Salary Challenge
SELECT TOP(10) FirstName, LastName, DepartmentID
  FROM Employees AS e
 WHERE Salary > (SELECT AVG(Salary) FROM Employees AS em WHERE em.DepartmentID = e.DepartmentID)
ORDER BY DepartmentID