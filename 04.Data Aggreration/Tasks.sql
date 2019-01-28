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

--12. Rich Wizard, Poor Wizard

--13. Departments Total Salaries

--14. Employees Minimum Salaries

--15. Employees Average Salaries 

--16. Employees Maximum Salaries 

--17. Employees Count Salaries 

--18. 3rd Highest Salary

--19. Salary Challenge

