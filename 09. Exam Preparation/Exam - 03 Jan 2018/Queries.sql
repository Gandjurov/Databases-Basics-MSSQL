CREATE DATABASE RentACar

USE RentACar
--DDL Part
CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Gender CHAR(1),
	BirthDate DATETIME,
	CreditCard NVARCHAR(30) NOT NULL,
	CardValidity DATETIME,
	Email NVARCHAR(50) NOT NULL,
	CONSTRAINT CH_Clients_Gender CHECK(Gender IN('M', 'F'))
)

CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE Offices
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(40),
	ParkingPlaces INT,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL,
)

CREATE TABLE Models
(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	ProductionYear DATETIME,
	Seats INT,
	Class NVARCHAR(10),
	Consumption DECIMAL(14,2)
)

CREATE TABLE Vehicles
(
	Id INT PRIMARY KEY IDENTITY,
	ModelId INT FOREIGN KEY REFERENCES Models(Id) NOT NULL,
	OfficeId INT FOREIGN KEY REFERENCES Offices(Id) NOT NULL,
	Mileage INT
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY,
	ClientId INT FOREIGN KEY REFERENCES Clients(Id) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL,
	VehicleId INT FOREIGN KEY REFERENCES Vehicles(Id) NOT NULL,
	CollectionDate DATETIME NOT NULL,
	CollectionOfficeId INT FOREIGN KEY REFERENCES Offices(Id) NOT NULL,
	ReturnDate DATETIME NOT NULL, 
	ReturnOfficeId INT FOREIGN KEY REFERENCES Offices(Id) NOT NULL,
	Bill DECIMAL(14,2),
	TotalMileage INT
)

--DML Part
INSERT INTO Models (Manufacturer, Model, ProductionYear, Seats, Class, Consumption) VALUES
('Chevrolet', 'Astro', '2005-07-27 00:00:00.000', 4, 'Economy', 12.60),
('Toyota', 'Solara', '2009-10-15 00:00:00.000', 7, 'Family', 13.80),
('Volvo', 'S40', '2010-10-12 00:00:00.000', 3, 'Average', 11.30),
('Suzuki', 'Swift', '2000-02-03 00:00:00.000', 7, 'Economy', 16.20)

INSERT INTO Orders (ClientId, TownId, VehicleId, CollectionDate, CollectionOfficeId, ReturnDate, ReturnOfficeId, Bill, TotalMileage) VALUES
(17, 2, 52, '2017-08-08', 30, '2017-09-04', 42, 2360.00, 7434),
(78, 17, 50, '2017-04-22', 10, '2017-05-09', 12, 2360.00, 7326),
(27, 13, 58, '2017-04-25', 21, '2017-05-09', 34, 597.00, 1880)

--03.Update 
UPDATE Models
   SET Class = 'Luxury'
 WHERE Consumption > 20

--04.Delete 
DELETE FROM Orders
 WHERE ReturnDate IS NULL

--5.Showroom
SELECT Manufacturer, Model
  FROM Models
ORDER BY Manufacturer, Id DESC

--6.Y Generation
SELECT FirstName, LastName
  FROM Clients
 WHERE DATEPART(YEAR, BirthDate) BETWEEN '1977' AND '1994'
ORDER BY FirstName, LastName, Id

--7.Spacious Office
SELECT t.Name AS [Town Name], o.Name AS [OfficeName], o.ParkingPlaces AS [ParkingPlaces]
  FROM Offices AS o
  JOIN Towns AS t ON t.Id = o.TownId
 WHERE o.ParkingPlaces > 25
ORDER BY t.Name, o.Name

--8.Available Vehicles
SELECT m.Model, m.Seats, v.Mileage
  FROM Vehicles AS v
  JOIN Models AS m ON m.Id = v.ModelId
 WHERE v.Id != ALL(
					SELECT VehicleId FROM Orders WHERE ReturnDate IS NULL
				  )
ORDER BY v.Mileage, m.Seats DESC, v.ModelId

--9.Offices per Town
SELECT t.Name AS TownName, COUNT(t.Id) AS OfficesNumber 
  FROM Towns AS t
  JOIN Offices AS o ON o.TownId = t.Id
GROUP BY t.Name, t.Id
ORDER BY OfficesNumber DESC, TownName

--10.Buyers Best Choice 
SELECT m.Manufacturer AS [Manufacturer], m.Model AS [Model], COUNT(o.VehicleId) AS [TimesOrdered]
  FROM Vehicles AS v
  JOIN Models AS m ON v.ModelId = m.Id 
LEFT JOIN Orders AS o ON v.Id = o.VehicleId
GROUP BY m.Manufacturer, m.Model
ORDER BY TimesOrdered DESC, Manufacturer DESC, Model ASC

--11.Kinda Person
WITH chp AS
(SELECT c.FirstName + ' ' + c.LastName AS [Name],
	   m.Class AS [Class],
	   DENSE_RANK() OVER (PARTITION BY c.FirstName + ' ' + c.LastName 
			ORDER BY COUNT(m.Class) DESC ) AS rn
  FROM Clients AS c
  JOIN Orders AS o ON o.ClientId = c.Id
  JOIN Vehicles AS v ON v.Id = o.VehicleId
  JOIN Models AS m ON m.Id = v.ModelId
GROUP BY c.FirstName + ' ' + c.LastName, m.Class)

SELECT chp.Name AS [Name], chp.Class AS [Class]
  FROM chp
 WHERE rn = 1 AND chp.Class IS NOT NULL
 ORDER BY chp.Name, chp.Class

--12.Age Groups Revenue

--13.Consumption in Mind

--14. Debt Hunter

--15. Town Statistics

--16. Home Sweet Home

--17. Find My Ride

--18. Move a Vehicle

--19. Move the Tally
