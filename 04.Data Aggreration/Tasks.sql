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
SELECT TOP(2) DepositGroup, AVG(MagicWandSize)
  FROM WizzardDeposits
GROUP BY DepositGroup 
ORDER BY DepositGroup

--05. Deposits Sum 

--06. Deposits Sum for Ollivander Family

--07. Deposits Filter 

--08. Deposit Charge 

--09. Age Groups 

--10. First Letter 

--11. Average Interest 

--12. Rich Wizard, Poor Wizard

--13. Departments Total Salaries

--14. Employees Minimum Salaries

--15. Employees Average Salaries 

--16. Employees Maximum Salaries 

--17. Employees Count Salaries 

--18. 3rd Highest Salary

--19. Salary Challenge

