CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY,
	AddressText VARCHAR(50) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id),
)

CREATE TABLE Departments(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50),
	MiddleName VARCHAR(50),
	LastName VARCHAR(50),
	JobTitle NVARCHAR(50),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATETIME NOT NULL,
	Salary DECIMAL(15, 2) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

--Sofia, Plovdiv, Varna, Burgas
INSERT INTO Towns(Name) 
VALUES ('Sofia'), 
	   ('Plovdiv'), 
	   ('Varna'), 
	   ('Burgas')

--Engineering, Sales, Marketing, Software Development, Quality Assurance
INSERT INTO Departments(Name) 
VALUES ('Engineering'), 
	   ('Sales'), 
	   ('Marketing'), 
	   ('Software Development'), 
	   ('Quality Assurance')

--Name, Job Title, Department, Hire Date, Salary
INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary ) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

SELECT * FROM Towns
ORDER BY Name
SELECT * FROM Departments
ORDER BY Name
SELECT * FROM Employees
ORDER BY Salary DESC

