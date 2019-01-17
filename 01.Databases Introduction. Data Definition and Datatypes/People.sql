-- CREATE DATABASE PEOPLE

CREATE DATABASE People

USE People

--ADD TABLE PEOPLE

CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX),
	Height DECIMAL(15, 2),
	[Weight] DECIMAL(15, 2),
	Gender CHAR(1) CHECK (Gender = 'm' OR Gender = 'f') NOT NULL,
	BirthDate DATE NOT NULL,
	Biography NVARCHAR(MAX)
)

ALTER TABLE dbo.People ADD CONSTRAINT CHK_People_Picture__2MB CHECK (DATALENGTH(Picture) <= 2097152);

INSERT INTO People (Name, Picture, Height, [Weight], Gender, Birthdate, Biography) 
VALUES
('Pesho Marinov', NULL, 1.80, 55.23, 'm', Convert(DateTime,'19820626',112), 'Skilled worker'),
('Ivan Dimov', NULL, 1.75, 75.55, 'm', Convert(DateTime,'19850608',112), 'Basketball player'),
('Todorka Peneva', NULL, 1.66, 48.55, 'f', Convert(DateTime,'19900606',112), 'Model'),
('Dilyana Ivanova', NULL, 1.77, 52.22, 'f', Convert(DateTime,'19920705',112), 'Fashion guru'),
('Todor Stamatov', NULL, 1.88, 98.25, 'm', Convert(DateTime,'19870706',112), 'Master')

--ADD TABLE USERS

CREATE TABLE Users(
	Id BIGINT UNIQUE IDENTITY,
	UserName VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX) CHECK (DATALENGTH(ProfilePicture) <= 900 * 1024),
	LastLoginTime DATETIME,
	IsDeleted BIT,
	CONSTRAINT PK_Users PRIMARY KEY(Id)
)

INSERT INTO Users
VALUES
('Pesho', '12345', NULL, NULL, 0),
('Gosho', '12345', NULL, NULL, 1),
('Stamat', '12345', NULL, NULL, 0),
('Jivko', '12345', NULL, NULL, 0),
('Dancho', '12345', NULL, NULL, 1)

-- CHANGE PRIMARY KEY

ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY(Id, Username)

--ADD CHECK CONSTRAINT PASSWORD HAS ATLEAST 5 SYMBOLS

ALTER TABLE Users
ADD CONSTRAINT PasswordLength CHECK (LEN(Password) >= 5)

--SET DEFAULT VALUE OF A FIELD

ALTER TABLE Users
ADD DEFAULT CURRENT_TIMESTAMP FOR LastLoginTime

--SET UNIQUE FIELD
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT uq_Username
UNIQUE(Username)

