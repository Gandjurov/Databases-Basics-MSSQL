--01. DDL
CREATE DATABASE TripService

USE TripService

CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
	EmployeeCount INT NOT NULL,
	BaseRate DECIMAL(15,2)
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(15,2) NOT NULL,
	Type NVARCHAR(20) NOT NULL,
	Beds INT NOT NULL,
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL
)

CREATE TABLE Trips
(
	Id INT PRIMARY KEY IDENTITY,
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
	BookDate DATETIME NOT NULL, --must be before ArrivalDate
	ArrivalDate DATETIME NOT NULL,  -- must be before ReturnDate
	ReturnDate DATETIME NOT NULL,
	CancelDate DATETIME,
	CONSTRAINT CH_BookDateBeforeArrivalDate CHECK(BookDate < ArrivalDate),
	CONSTRAINT CH_ArrivalDateBeforeReturnDate CHECK(ArrivalDate < ReturnDate)
)

CREATE TABLE Accounts
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(20),
	LastName NVARCHAR(50) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
	BirthDate DATETIME NOT NULL,
	Email NVARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE AccountsTrips
(
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
	TripId INT FOREIGN KEY REFERENCES Trips(Id),
	Luggage INT NOT NULL CHECK(Luggage >= 0),
	PRIMARY KEY (AccountId, TripId)
)

--ALTER TABLE Trips
--ADD CONSTRAINT CH_BookDateBeforeArrivalDate CHECK(BookDate < ArrivalDate)

--ALTER TABLE Trips
--ADD CONSTRAINT CH_ArrivalDateBeforeReturnDate CHECK(ArrivalDate < ReturnDate)


--02. Insert 
INSERT INTO Accounts VALUES
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')


INSERT INTO Trips VALUES
(101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
(103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
(104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
(109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)


--03. Update 
--Make all rooms’ prices 14% more expensive where the hotel ID is either 5, 7 or 9.

UPDATE Rooms
   SET Price *= 1.14
 WHERE HotelId IN(5,7,9)

--04. Delete 
--Delete all of Account ID 47’s account’s trips from the mapping table.
DELETE FROM AccountsTrips
WHERE AccountId = 47



--05. Bulgarian Cities 
SELECT Id, Name
  FROM Cities
 WHERE CountryCode = 'BG'
ORDER BY Name

--06. People Born After 1991 
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS [Full Name]
       ,YEAR(BirthDate) AS BirthYear
  FROM Accounts
 WHERE YEAR(BirthDate) > 1991
ORDER BY YEAR(BirthDate) DESC, FirstName

--07. EEE-Mails 
SELECT a.FirstName, a.LastName, FORMAT(a.BirthDate, 'MM-dd-yyyy'), c.Name, a.Email 
  FROM Accounts AS a
  JOIN Cities AS c ON c.Id = a.CityId 
 WHERE Email LIKE 'e%'
ORDER BY c.Name DESC

--08. City Statistics 
--EXEC sp_changedbowner 'sa'

SELECT c.Name, COUNT(h.Id) AS Hotels
  FROM Cities AS c
LEFT JOIN Hotels AS h ON h.CityId = c.Id
GROUP BY c.Name
ORDER BY Hotels DESC, c.Name

--09. Expensive First Class Rooms 
SELECT r.Id
	   ,r.Price
	   ,h.Name AS Hotel
	   ,c.Name AS City
  FROM Rooms AS r
  JOIN Hotels AS h ON h.Id = r.HotelId
  JOIN Cities AS c ON c.Id = h.CityId
WHERE r.Type = 'First Class'
ORDER BY r.Price DESC, r.Id

--10. Longest and Shortest Trips 
SELECT a.Id AS AccountId
	   ,a.FirstName + ' ' + a.LastName AS FullName
	   ,MAX(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) AS LongestTrip
	   ,MIN(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) AS ShortestTrip
  FROM Accounts AS a
  JOIN AccountsTrips AS at ON at.AccountId = a.Id
  JOIN Trips AS t ON t.Id = at.TripId
 WHERE a.MiddleName IS NULL AND t.CancelDate IS NULL
GROUP BY a.Id, a.FirstName, a.LastName
ORDER BY LongestTrip DESC, a.Id

--11. Metropolis 
SELECT TOP(5) c.Id
	   ,c.Name
	   ,c.CountryCode
	   ,COUNT(a.Id) AS Accounts
  FROM Cities AS c
  JOIN Accounts AS a ON c.Id = a.CityId
GROUP BY c.Id, c.Name, c.CountryCode 
ORDER BY Accounts DESC

--12. Romantic Getaways 
SELECT a.Id AS Id
       ,a.Email AS Email
	   ,c.Name AS City
	   ,COUNT(t.Id) AS Trips
  FROM Accounts AS a
  JOIN AccountsTrips AS at ON at.AccountId = a.Id
  JOIN Trips AS t ON t.Id = at.TripId
  JOIN Rooms AS r ON r.Id = t.RoomId
  JOIN Hotels AS h ON h.Id = r.HotelId
  JOIN Cities AS c ON c.Id = h.CityId
 WHERE a.CityId = h.CityId
GROUP BY a.Id, a.Email, c.Name
ORDER BY Trips DESC, Id

--13. Lucrative Destinations 


--14. Trip Revenues 


--15. Top Travelers 


--16. Luggage Fees 


--17. GDPR Violation 


--18. Available Room 


--19. Switch Room 


--20. Cancel Trip 