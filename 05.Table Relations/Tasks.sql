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

--03. Many-To-Many Relationship 

--04. Self-Referencing 

--05. Online Store Database 

--06. University Database 

--07. SoftUni Design

--08. Geography Design

--09. *Peaks in Rila 