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
	Email VARCHAR(100) NOT NULL UNIQUE
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


--03. Update 


--04. Delete 


--05. Bulgarian Cities 


--06. People Born After 1991 


--07. EEE-Mails 


--08. City Statistics 


--09. Expensive First Class Rooms 


--10. Longest and Shortest Trips 


--11. Metropolis 


--12. Romantic Getaways 


--13. Lucrative Destinations 


--14. Trip Revenues 


--15. Top Travelers 


--16. Luggage Fees 


--17. GDPR Violation 


--18. Available Room 


--19. Switch Room 


--20. Cancel Trip 