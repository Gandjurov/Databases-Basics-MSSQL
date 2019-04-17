CREATE DATABASE ReportService
GO
USE ReportService
GO

CREATE TABLE Users
(Id        INT NOT NULL IDENTITY,
 Username  NVARCHAR(30) NOT NULL UNIQUE,
 Password  NVARCHAR(50) NOT NULL,
 Name      NVARCHAR(50),
 Gender    CHAR(1),
 BirthDate DATETIME,
 Age       INT,
 Email     NVARCHAR(50) NOT NULL,
 CONSTRAINT PK_Users PRIMARY KEY(Id),
 CONSTRAINT CH_Users_Gender CHECK(Gender IN('M', 'F'))
);

CREATE TABLE Departments
(Id   INT NOT NULL IDENTITY,
 Name NVARCHAR(50) NOT NULL,
 CONSTRAINT PK_Departments PRIMARY KEY(Id),
);

CREATE TABLE Employees
(Id           INT NOT NULL IDENTITY,
 FirstName    NVARCHAR(25),
 LastName     NVARCHAR(25),
 Gender       CHAR(1),
 BirthDate    DATETIME,
 Age          INT,
 DepartmentId INT NOT NULL,
 CONSTRAINT PK_Employees PRIMARY KEY(Id),
 CONSTRAINT FK_Employees_Departments FOREIGN KEY(DepartmentId) REFERENCES Departments(Id),
 CONSTRAINT CH_Employees_Gender CHECK(Gender IN('M', 'F'))
);

CREATE TABLE Categories
(Id           INT NOT NULL IDENTITY,
 Name         NVARCHAR(50) NOT NULL,
 DepartmentId INT,
 CONSTRAINT PK_Categories PRIMARY KEY(Id),
 CONSTRAINT FK_Categories_Departments FOREIGN KEY(DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Status
(Id    INT NOT NULL IDENTITY,
 Label NVARCHAR(30) NOT NULL,
 CONSTRAINT PK_Status PRIMARY KEY(Id)
);

CREATE TABLE Reports
(Id          INT NOT NULL IDENTITY,
 CategoryId  INT NOT NULL,
 StatusId    INT NOT NULL,
 OpenDate    DATETIME NOT NULL,
 CloseDate   DATETIME,
 Description NVARCHAR(200),
 UserId      INT NOT NULL,
 EmployeeId  INT,
 CONSTRAINT PK_Reports PRIMARY KEY(Id),
 CONSTRAINT FK_Reports_Categories FOREIGN KEY(CategoryId) REFERENCES Categories(Id),
 CONSTRAINT FK_Reports_Employees FOREIGN KEY(EmployeeId) REFERENCES Employees(Id),
 CONSTRAINT FK_Reports_Status FOREIGN KEY(StatusId) REFERENCES Status(Id),
 CONSTRAINT FK_Reports_Users FOREIGN KEY(UserId) REFERENCES Users(Id)
);

--DML Part
-- 02. Insert

INSERT INTO Employees(Firstname,
                      Lastname,
                      Gender,
                      Birthdate,
                      DepartmentId)
VALUES
('Marlo', 'O’Malley', 'M', '09/21/1958', '1'),
('Niki', 'Stanaghan', 'F', '11/26/1969', '4'),
('Ayrton', 'Senna', 'M', '03/21/1960 ', '9'),
('Ronnie', 'Peterson', 'M', '02/14/1944', '9'),
('Giovanna', 'Amati', 'F', '07/20/1959', '5');

INSERT INTO Reports(CategoryId,
                    StatusId,
                    OpenDate,
                    CloseDate,
                    Description,
                    UserId,
                    EmployeeId)
VALUES
('1', '1', '04/13/2017', NULL, 'Stuck Road on Str.133', '6', '2'),
('6', '3', '09/05/2015', '12/06/2015', 'Charity trail running', '3', '5'),
('14', '2', '09/07/2015', NULL, 'Falling bricks on Str.58', '5', '2'),
('4', '3', '07/03/2017', '07/06/2017', 'Cut off streetlight on Str.11', '1', '1');

-- 03. Update

UPDATE Reports
SET StatusId = 2 
WHERE StatusId = 1 AND CategoryId = 4

-- 04. Delete 

DELETE Reports
WHERE  StatusId = 4

--Task 5 - Users by Age

SELECT Username,
       Age
FROM Users
ORDER BY Age,
         Username DESC;

--Task 6 - Unassigned Reports

SELECT Description,
       Opendate
FROM Reports
WHERE Employeeid IS NULL
ORDER BY Opendate, 
		 Description;

--Task 7. Employees & Reports

SELECT E.Firstname,
       E.Lastname,
       R.Description,
       FORMAT(R.Opendate, 'yyyy-MM-dd') AS Opendate
FROM Employees AS E
     JOIN Reports AS R ON R.Employeeid = E.Id
ORDER BY E.Id,
         R.Opendate;

--Task 8 - Most reported Category

SELECT C.Name AS CategoryName,
       COUNT(*) AS ReportsNumber
FROM Categories AS C
     JOIN Reports AS R ON R.Categoryid = C.Id
GROUP BY C.Name
ORDER BY Reportsnumber DESC,
         Categoryname;

--Task 9. Employees in Category

SELECT C.Name,
       COUNT(E.Id) AS Numberemployees
FROM Categories AS C
     JOIN Departments AS D ON D.Id = C.Departmentid
     JOIN Employees AS E ON E.Departmentid = D.Id
GROUP BY C.Name;

--Task 10 - Birthday Reports

SELECT DISTINCT C.Name
FROM Categories C 
     JOIN Reports AS R ON R.CategoryId = C.Id
     JOIN Users AS U ON U.Id = R.Userid
WHERE DAY(R.Opendate) = DAY(U.Birthdate)
	 AND MONTH(R.Opendate) = MONTH(U.Birthdate)
ORDER BY C.Name;

-- Task 11 - Users per Employee

SELECT E.Firstname + ' ' + E.Lastname AS FullName,
       COUNT(DISTINCT R.Userid) AS UsersCount
FROM Employees AS E
     LEFT JOIN Reports AS R ON R.Employeeid = E.Id
GROUP BY E.Firstname + ' ' + E.Lastname
ORDER BY UsersCount DESC,
         FullName;

--Task 12 - Emergency Patrol

SELECT OpenDate, Description, u.email [Reporter Emial] 
FROM Reports r
	JOIN Users AS u on u.id = r.UserId
	JOIN Categories c on c.id = r.CategoryId
	JOIN Departments d on d.id = c.Departmentid 
WHERE Description LIKE '%str%' AND
	  LEN(Description) > 20 AND
	  CloseDate IS NULL AND
	  d.Id IN (1,4,5)
ORDER BY OpenDate, 
	     [Reporter Emial];

--Task 13 - Numbers Coincidence

SELECT DISTINCT Username 
FROM Users u
	JOIN Reports r on r.UserId = u.id
	JOIN Categories c ON c.id = r.CategoryId
WHERE (Username LIKE '[0-9]_%' AND CAST(c.id as varchar) = LEFT(username, 1)) OR
      (Username LIKE '%_[0-9]' AND CAST(c.id as varchar) = RIGHT(username, 1))
ORDER BY Username;

--Task 14 - Count open and closed reports per employee in the last month

SELECT E.Firstname+' '+E.Lastname AS FullName, 
	   ISNULL(CONVERT(varchar, CC.ReportSum), '0') + '/' +        
       ISNULL(CONVERT(varchar, OC.ReportSum), '0') AS [Stats]
FROM Employees AS E
JOIN (SELECT EmployeeId,  COUNT(1) AS ReportSum
	  FROM Reports R
	  WHERE  YEAR(OpenDate) = 2016
	  GROUP BY EmployeeId) AS OC ON OC.Employeeid = E.Id
LEFT JOIN (SELECT EmployeeId,  COUNT(1) AS ReportSum
	       FROM Reports R
	       WHERE  YEAR(CloseDate) = 2016
	       GROUP BY EmployeeId) AS CC ON CC.Employeeid = E.Id
ORDER BY FullName

--Task 15 - Average closing time

SELECT D.Name AS Departmentname,
       ISNULL(
	          CONVERT(
			          VARCHAR, AVG(DATEDIFF(DAY, R.Opendate, R.Closedate))
					 ), 'no info'
			 ) AS AverageTime
FROM Departments AS D
     JOIN Categories AS C ON C.DepartmentId = D.Id
     LEFT JOIN Reports AS R ON R.CategoryId = C.Id
GROUP BY D.Name
ORDER BY D.Name

--Task 16 - Favourite Categories

SELECT Department,
       Category,
       Percentage
FROM
    (SELECT D.Name AS Department,
		    C.Name AS Category,
		    CAST(
			     ROUND(
				       COUNT(1) OVER(PARTITION BY C.Id) * 100.00 / COUNT(1) OVER(PARTITION BY D.Id), 0
					  ) as int
				) AS Percentage
     FROM Categories AS C
		  JOIN Reports AS R ON R.Categoryid = C.Id
		  JOIN Departments AS D ON D.Id = C.Departmentid) AS Stats
GROUP BY Deprtment,
         Category,
         Percentage;
ORDER BY Deprtment,
         Category,
         Percentage;

--Task 20 - Bonus - Categories Revisiion

SELECT c.Name,
	  COUNT(r.Id) AS ReportsNumber,
	  CASE 
	      WHEN InProgressCount > WaitingCount THEN 'in progress'
		  WHEN InProgressCount < WaitingCount THEN 'waiting'
		  ELSE 'equal'
	  END AS MainStatus
FROM Reports AS r
    JOIN Categories AS c ON c.Id = r.CategoryId
    JOIN Status AS s ON s.Id = r.StatusId
    JOIN (SELECT r.CategoryId, 
		         SUM(CASE WHEN s.Label = 'in progress' THEN 1 ELSE 0 END) as InProgressCount,
		         SUM(CASE WHEN s.Label = 'waiting' THEN 1 ELSE 0 END) as WaitingCount
		  FROM Reports AS r
		  JOIN Status AS s on s.Id = r.StatusId
		  WHERE s.Label IN ('waiting','in progress')
		  GROUP BY r.CategoryId
		 ) AS sc ON sc.CategoryId = c.Id
WHERE s.Label IN ('waiting','in progress') 
GROUP BY C.Name,
	     CASE 
		     WHEN InProgressCount > WaitingCount THEN 'in progress'
		     WHEN InProgressCount < WaitingCount THEN 'waiting'
		     ELSE 'equal'
	     END
ORDER BY C.Name, 
		 ReportsNumber, 
		 MainStatus;

--Task 17 - UDF GetReportsCount - DONE

CREATE FUNCTION udf_GetReportsCount(@employeeId INT, @statusId INT)
RETURNS INT
AS
BEGIN
    DECLARE @num INT= (SELECT COUNT(*)
                       FROM reports
                       WHERE Employeeid = @employeeId
                             AND Statusid = @statusId);
    RETURN @num;
END;

-- END Judge Submission

SELECT Id,
       Firstname,
       Lastname,
       dbo.udf_GetReportsCount(Id, 2)
FROM Employees;
GO

--Task 18 - Transaction - Assign Employee
CREATE PROC usp_AssignEmployeeToReport(@employeeId INT, @reportId INT)
AS
BEGIN
    BEGIN TRAN
		DECLARE @categoryId INT= (
								 SELECT Categoryid
								 FROM Reports
								 WHERE Id = @reportId);
		/*IF (@categoryId IS NULL)
		BEGIN;
		   THROW 50011,'Invalid report Id!', 1;
		   return;
		END*/

		DECLARE @employeeDepId INT= (
									SELECT Departmentid
									FROM Employees
									WHERE Id = @employeeId);
		/*IF (@employeeDepId IS NULL)
		BEGIN;
		   THROW 50012,'Invalid employee Id!', 1;
		   RETURN;
		END*/

		DECLARE @categoryDepId INT= (
									SELECT Departmentid
									FROM Categories
									WHERE Id = @categoryId);
		UPDATE Reports
		SET EmployeeId = @employeeId
		WHERE Id = @reportId

		IF @employeeId IS NOT NULL
		   AND @categoryDepId <> @employeeDepId
		BEGIN 
			ROLLBACK;
			THROW 50013,'Employee doesn''t belong to the appropriate department!', 1;
		END;   
    COMMIT; 
END;
--END Judge Submission

EXEC usp_AssignEmployeeToReport 17, 2;
SELECT EmployeeId FROM Reports WHERE id = 17

--Task 19 - Trigger - Close Reports

CREATE TRIGGER T_CloseReport ON Reports
AFTER UPDATE
AS
BEGIN
	UPDATE Reports
	SET StatusId = (SELECT Id FROM Status WHERE Label = 'completed')
	WHERE Id IN (SELECT Id FROM inserted
			     WHERE Id IN (SELECT Id FROM deleted
						      WHERE CloseDate IS NULL)
			           AND CloseDate IS NOT NULL)   
END;

--END Judge Submission 

UPDATE Reports
SET CloseDate = GETDATE()
WHERE EmployeeId = 5;