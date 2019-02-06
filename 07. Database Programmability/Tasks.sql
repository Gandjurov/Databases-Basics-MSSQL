--01. Employees with Salary Above 35000 
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName
  FROM Employees
 WHERE Salary > 35000
