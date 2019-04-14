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

--08. Students Teachers

--09. Subjects with Students

--10. Students to Go

--11. Busiest Teachers

--12. Top Students

--13. Second Highest Grade

--14. Not So In The Studying

--15. Top Student per Teacher

--16. Average Grade per Subject

--17. Exams Information

--18. Exam Grades

--19. Exclude from school

--20. Deleted Student
