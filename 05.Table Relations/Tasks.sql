--01. One-To-One Relationship
CREATE DATABASE MyDemoDb
USE MyDemoDb

CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
	Salary DECIMAL(15, 2),
	PassportID INT NOT NULL
)

CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY,
	PassportNumber CHAR(8) NOT NULL
)

ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

--exec sp_changedbowner 'sa'

ALTER TABLE Persons
ADD UNIQUE(PassportID)

ALTER TABLE Passports
ADD UNIQUE(PassportID)

INSERT INTO Passports(PassportID, PassportNumber) VALUES
(102, 'N34FG21B'),
(103, 'K65LO4R7'),
(101, 'ZE657QP2')

INSERT INTO Persons(PersonID, FirstName, Salary, PassportID) VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101)

--02. One-To-Many Relationship 
CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(15) NOT NULL,
	EstablishedOn DATE NOT NULL
)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	Name VARCHAR(15) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)

)

INSERT INTO Manufacturers (Name, EstablishedOn) VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')


INSERT INTO Models (Name, ManufacturerID) VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

SELECT * FROM Models

--03. Many-To-Many Relationship 
CREATE TABLE Students
(
	StudentID INT,
	Name VARCHAR(20)
)

CREATE TABLE Exams
(
	ExamID INT,
	Name VARCHAR(20),
)

CREATE TABLE StudentsExams
(
	StudentID INT,
	ExamID INT,
)

ALTER TABLE Students
ALTER COLUMN StudentID INT NOT NULL

ALTER TABLE Students
ADD CONSTRAINT PK_Students PRIMARY KEY (StudentID)

ALTER TABLE Exams
ALTER COLUMN ExamID INT NOT NULL

ALTER TABLE Exams
ADD CONSTRAINT PK_Exams PRIMARY KEY (ExamID)


ALTER TABLE StudentsExams
ALTER COLUMN ExamID INT NOT NULL

ALTER TABLE StudentsExams
ALTER COLUMN StudentID INT NOT NULL

ALTER TABLE StudentsExams
ADD CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID, ExamID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)

--04. Self-Referencing 
CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101,1),
	[Name] VARCHAR(30),
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers ([Name], ManagerID) VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

--05. Online Store Database 
CREATE TABLE Cities(
	CityID INT PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Birthday DATE,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID) NOT NULL
)

CREATE TABLE Orders(
	OrderID INT PRIMARY KEY NOT NULL,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) NOT NULL
)

CREATE TABLE ItemTypes(
	ItemTypeID INT PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Items (
	ItemID INT PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID) NOT NULL
)

CREATE TABLE OrderItems (
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID) NOT NULL
	CONSTRAINT PK_Order_Items PRIMARY KEY (OrderID, ItemID)
)

--06. University Database 
CREATE DATABASE Example6


USE Example6

CREATE TABLE Majors (
	MajorID INT PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Students (
	StudentID INT PRIMARY KEY NOT NULL,
	StudentNumber VARCHAR(15) NOT NULL,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments (
	PaymentID INT PRIMARY KEY NOT NULL,
	PaymentDate DATETIME NOT NULL,
	PaymentAmount DECIMAL(6, 2) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects (
	SubjectID INT PRIMARY KEY NOT NULL,
	SubjectName VARCHAR(35) NOT NULL
)

CREATE TABLE Agenda (
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID)
	CONSTRAINT PK_Agenda PRIMARY KEY (StudentID, SubjectID)
)
--07. SoftUni Design

--08. Geography Design

--09. *Peaks in Rila 
USE Geography
SELECT m.MountainRange, p.PeakName, p.Elevation FROM Mountains AS m
JOIN Peaks AS p ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC
