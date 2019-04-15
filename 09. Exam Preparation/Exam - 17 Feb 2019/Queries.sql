CREATE DATABASE School

USE School

--DDL Part
CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(25),
	LastName NVARCHAR(30) NOT NULL,
	Age INT NOT NULL CHECK (Age > 0),
	[Address] NVARCHAR(50),
	Phone NVARCHAR(10)
)

CREATE TABLE Subjects
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	Lessons INT NOT NULL CHECK (Lessons > 0) 
)

CREATE TABLE StudentsSubjects
(
	Id INT PRIMARY KEY IDENTITY,
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL,
	Grade DECIMAL(15,2) NOT NULL CHECK(Grade >= 2 AND Grade <= 6)
)

CREATE TABLE Exams
(
	Id INT PRIMARY KEY IDENTITY,
	[Date] DATETIME,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL,
)

CREATE TABLE StudentsExams
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	ExamId INT FOREIGN KEY REFERENCES Exams(Id) NOT NULL,
	Grade DECIMAL(15,2) NOT NULL CHECK(Grade >= 2 AND Grade <= 6)

	CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentId, ExamId),
)

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	Address NVARCHAR(20) NOT NULL,
	Phone NVARCHAR(10),
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL,
)

CREATE TABLE StudentsTeachers
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	TeacherId INT FOREIGN KEY REFERENCES Teachers(Id) NOT NULL,

	CONSTRAINT PK_StudentsTeachers PRIMARY KEY (StudentId, TeacherId),
)

--DML Part

INSERT INTO Teachers (FirstName, LastName, [Address], Phone, SubjectId) VALUES
('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', 2),
('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)

INSERT INTO Subjects([Name], Lessons) VALUES
('Geometry',  12),
('Health',  10),
('Drama',  7),
('Sports',  9)

--03. Update
UPDATE StudentsSubjects
   SET Grade = 6.00
 WHERE Grade >= 5.50 AND SubjectId IN (1, 2)

--04. Delete
DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone LIKE '%72%')

DELETE FROM Teachers
WHERE Phone LIKE '%72%'

--05. Teen Students
SELECT FirstName, LastName, Age
  FROM Students
 WHERE Age >= 12
ORDER BY FirstName, LastName

--06. Cool Addresses
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], [Address]
  FROM Students
 WHERE [Address] LIKE '%Road%'
ORDER BY FirstName, LastName, [Address]

--07. 42 Phones
SELECT FirstName, [Address], Phone
  FROM Students
 WHERE Phone LIKE '42%' AND MiddleName IS NOT NULL
ORDER BY FirstName

--08. Students Teachers
SELECT FirstName, LastName, COUNT(st.StudentId) AS TeachersCount
  FROM Students AS s
  JOIN StudentsTeachers AS st ON st.StudentId = s.Id
GROUP BY s.FirstName, s.LastName

--09. Subjects with Students
SELECT t.FirstName + ' ' + t.LastName AS [Name], 
	   s.Name + '-' + CAST(s.Lessons AS NVARCHAR(5)) AS Subjects,
	   COUNT(st.TeacherId) AS Students
  FROM Teachers AS t
  JOIN Subjects AS s ON s.Id = t.SubjectId
  JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
GROUP BY t.FirstName, t.LastName, s.Name, s.Lessons
ORDER BY COUNT(st.TeacherId) DESC, [Name], Subjects

--10. Students to Go (
SELECT FirstName + ' ' + LastName AS [Full Name]
  FROM Students AS s
FULL JOIN StudentsExams AS se ON se.StudentId = s.Id
 WHERE se.Grade IS NULL
ORDER BY [Full Name]

--11. Busiest Teachers
SELECT TOP(10) FirstName, LastName, COUNT(st.StudentId) AS StudentsCount
  FROM Teachers AS t
  JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
GROUP BY FirstName, LastName
ORDER BY StudentsCount DESC, FirstName, LastName

--12. Top Students
SELECT TOP(10) FirstName, LastName, FORMAT(AVG(se.Grade), 'N2') AS [Grade]
  FROM Students AS s
  JOIN StudentsExams AS se ON se.StudentId = s.Id
GROUP BY FirstName, LastName
ORDER BY [Grade] DESC, FirstName, LastName

--13. Second Highest Grade
SELECT k.FirstName, k.LastName, k.Grade
  FROM (
       SELECT FirstName, LastName, Grade,
			ROW_NUMBER() OVER (PARTITION BY FirstName, LastName ORDER BY Grade DESC) AS RowNumber
		 FROM Students AS s
		 JOIN StudentsSubjects AS ss ON ss.StudentId = s.Id
	   ) AS k
WHERE k.RowNumber = 2
ORDER BY FirstName, LastName

--14. Not So In The Studying
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS [Full Name]
  FROM Students AS st
LEFT JOIN StudentsSubjects AS ss ON ss.StudentId = st.Id
LEFT JOIN Subjects AS s ON s.Id = ss.SubjectId
WHERE ss.SubjectId IS NULL
ORDER BY [Full Name]

--15. Top Student per Teacher
SELECT j.[Teacher Full Name], j.SubjectName ,j.[Student Full Name], FORMAT(j.TopGrade, 'N2') AS Grade
  FROM (
SELECT k.[Teacher Full Name],k.SubjectName, k.[Student Full Name], k.AverageGrade  AS TopGrade,
	   ROW_NUMBER() OVER (PARTITION BY k.[Teacher Full Name] ORDER BY k.AverageGrade DESC) AS RowNumber
  FROM (
  SELECT t.FirstName + ' ' + t.LastName AS [Teacher Full Name],
  	   s.FirstName + ' ' + s.LastName AS [Student Full Name],
  	   AVG(ss.Grade) AS AverageGrade,
  	   su.Name AS SubjectName
    FROM Teachers AS t 
    JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
    JOIN Students AS s ON s.Id = st.StudentId
    JOIN StudentsSubjects AS ss ON ss.StudentId = s.Id
    JOIN Subjects AS su ON su.Id = ss.SubjectId AND su.Id = t.SubjectId
GROUP BY t.FirstName, t.LastName, s.FirstName, s.LastName, su.Name
) AS k
) AS j
   WHERE j.RowNumber = 1 
ORDER BY j.SubjectName,j.[Teacher Full Name], TopGrade DESC

--16. Average Grade per Subject
SELECT s.Name, AVG(ss.Grade) AS AverageGrade
  FROM Subjects AS s
  JOIN StudentsSubjects AS ss ON ss.SubjectId = s.Id
GROUP BY s.Name, s.Id
ORDER BY s.Id

--17. Exams Information
SELECT  k.Quarter, k.SubjectName, COUNT(k.StudentId) AS StudentsCount
  FROM (
  SELECT s.Name AS SubjectName,
		 se.StudentId,
		 CASE
		 WHEN DATEPART(MONTH, Date) BETWEEN 1 AND 3 THEN 'Q1'
		 WHEN DATEPART(MONTH, Date) BETWEEN 4 AND 6 THEN 'Q2'
		 WHEN DATEPART(MONTH, Date) BETWEEN 7 AND 9 THEN 'Q3'
		 WHEN DATEPART(MONTH, Date) BETWEEN 10 AND 12 THEN 'Q4'
		 WHEN Date IS NULL THEN 'TBA'
		 END AS [Quarter]
    FROM Exams AS e
	JOIN Subjects AS s ON s.Id = e.SubjectId 
	JOIN StudentsExams AS se ON se.ExamId = e.Id
	WHERE se.Grade >= 4
) AS k
GROUP BY k.Quarter, k.SubjectName
ORDER BY k.Quarter

--18. Exam Grades
GO
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(15,2))
RETURNS VARCHAR(MAX)
AS
BEGIN

DECLARE @studentExist INT = (SELECT TOP(1) StudentId 
									 FROM StudentsExams  
									 WHERE StudentId = @studentId);

IF @studentExist IS NULL
BEGIN
RETURN ('The student with provided id does not exist in the school!')
END

IF @grade > 6.00
BEGIN
RETURN ('Grade cannot be above 6.00!')
END

DECLARE @studentFirstName NVARCHAR(20) = (SELECT TOP(1) FirstName 
												  FROM Students 
												  WHERE Id = @studentId);
DECLARE @biggestGrade DECIMAL(15,2) = @grade + 0.50;
DECLARE @count INT = (SELECT Count(Grade) 
						FROM StudentsExams
					   WHERE StudentId = @studentId AND Grade >= @grade AND Grade <= @biggestGrade)

RETURN ('You have to update ' + CAST(@count AS nvarchar(10)) + ' grades for the student ' + @studentFirstName)
END

--19. Exclude from school
GO
CREATE PROC usp_ExcludeFromSchool @StudentId INT
AS
DECLARE @TargetStudentId INT = (SELECT Id FROM Students WHERE @StudentId = Id)

IF (@TargetStudentId IS NULL)
BEGIN
	RAISERROR('This school has no student with the provided id!', 16, 1)
	RETURN
END

DELETE FROM StudentsExams
WHERE StudentId = @StudentId

DELETE FROM StudentsSubjects
WHERE StudentId = @StudentId

DELETE FROM StudentsTeachers
WHERE StudentId = @StudentId

DELETE FROM Students
WHERE Id = @StudentId

--20. Deleted Student
CREATE TABLE ExcludedStudents
(
StudentId INT, 
StudentName VARCHAR(30)
)

GO
CREATE TRIGGER tr_StudentsDelete ON Students
INSTEAD OF DELETE
AS
INSERT INTO ExcludedStudents(StudentId, StudentName)
		SELECT Id, FirstName + ' ' + LastName FROM deleted