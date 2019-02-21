CREATE DATABASE ColonialJourney

USE ColonialJourney

--DDL Part
CREATE TABLE Planets
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PlanetId INT FOREIGN KEY REFERENCES Planets(Id) NOT NULL
)

CREATE TABLE Spaceships
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(30) NOT NULL,
	LightSpeedRate INT DEFAULT(0)
)

CREATE TABLE Colonists
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Ucn VARCHAR(10) UNIQUE NOT NULL,
	BirthDate DATE NOT NULL
)

CREATE TABLE Journeys
(
	Id INT PRIMARY KEY IDENTITY,
	JourneyStart DATETIME NOT NULL,
	JourneyEnd DATETIME NOT NULL,
	Purpose VARCHAR(11) CHECK (Purpose = 'Medical' OR 
							   Purpose = 'Technical' OR 
							   Purpose =  'Educational' OR 
							   Purpose =  'Military'),
	DestinationSpaceportId INT FOREIGN KEY REFERENCES Spaceports(Id) NOT NULL,
	SpaceshipId INT FOREIGN KEY REFERENCES Spaceships(Id) NOT NULL
)

CREATE TABLE TravelCards
(
	Id INT PRIMARY KEY IDENTITY,
	CardNumber VARCHAR(10) UNIQUE NOT NULL,
	JobDuringJourney VARCHAR(8) CHECK (JobDuringJourney = 'Pilot' OR 
										JobDuringJourney = 'Engineer' OR 
										JobDuringJourney =  'Trooper' OR 
										JobDuringJourney =  'Cleaner' OR 
										JobDuringJourney =  'Cook'),
	ColonistId INT FOREIGN KEY REFERENCES Colonists(Id) NOT NULL,
	JourneyId INT FOREIGN KEY REFERENCES Journeys(Id) NOT NULL
)

--DML Part

--02.Insert
INSERT INTO Planets VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO Spaceships VALUES
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda', 4),
('Falcon9', 'SpaceX', 1),
('Bed', 'Vidolov', 6)

--03. Update
UPDATE Spaceships
   SET LightSpeedRate += 1
 WHERE Id BETWEEN 8 AND 12

--04. Delete
DELETE FROM TravelCards 
WHERE JourneyId IN (1,2,3)

DELETE FROM Journeys 
WHERE Id IN (1,2,3)

--05. Select all travel cards
SELECT CardNumber, JobDuringJourney
  FROM TravelCards
ORDER BY CardNumber

--06. Select All Colonists
SELECT Id, FirstName + ' ' + LastName AS FullName, Ucn
  FROM Colonists
ORDER BY FirstName, LastName, Id

--07. Select All Military Journeys 
SELECT Id, FORMAT(JourneyStart, 'dd/MM/yyyy') AS JourneyStart, FORMAT(JourneyEnd, 'dd/MM/yyyy') AS JourneyEnd
  FROM Journeys
 WHERE Purpose = 'Military'
ORDER BY JourneyStart

--08. Select All Pilots 
SELECT c.Id, c.FirstName + ' ' + c.LastName AS full_name
  FROM Colonists AS c
  JOIN TravelCards AS t ON t.ColonistId = c.Id
 WHERE t.JobDuringJourney = 'Pilot'
ORDER BY c.Id 

--09. Count Colonists 
SELECT COUNT(c.Id) AS [Count]
  FROM TravelCards AS t
  JOIN Colonists AS c ON c.Id = t.ColonistId
  JOIN Journeys AS j ON j.Id = t.JourneyId
 WHERE j.Purpose = 'Technical'

--10. Select The Fastest Spaceship 
SELECT TOP(1) ss.Name AS SpaceshipName, sp.Name AS SpaceportName
  FROM Journeys AS j
  JOIN Spaceships AS ss ON ss.Id = j.SpaceshipId
  JOIN Spaceports AS sp ON sp.Id = j.DestinationSpaceportId
ORDER BY ss.LightSpeedRate DESC

--11. Select Spaceships With Pilots 
SELECT ss.Name AS [Name], ss.Manufacturer
  FROM TravelCards AS t
  JOIN Journeys AS j ON j.Id = t.JourneyId
  JOIN Spaceships AS ss ON ss.Id = j.SpaceshipId
  JOIN Colonists AS c ON c.Id = t.ColonistId
 WHERE t.JobDuringJourney = 'Pilot' AND c.BirthDate >= '01/01/1989'
ORDER BY [Name]

--12. Select All Educational Mission 
SELECT p.Name AS PlanetName, sp.Name AS SpaceportName
  FROM Journeys AS j
  JOIN Spaceports AS sp ON sp.Id = j.DestinationSpaceportId
  JOIN Planets AS p ON p.Id = sp.PlanetId
 WHERE j.Purpose = 'Educational'
ORDER BY sp.Name DESC

--13. Planets And Journeys 
SELECT p.Name AS PlanetName, COUNT(j.Id) AS JourneysCount
  FROM Journeys AS j
  JOIN Spaceports AS sp ON sp.Id = j.DestinationSpaceportId
  JOIN Planets AS p ON p.Id = sp.PlanetId
GROUP BY p.Name
ORDER BY JourneysCount DESC, PlanetName 

--14. Extract The Shortest Journey 
SELECT TOP(1)
	   j.Id,
	   p.Name AS PlanetName,
	   sp.Name AS SpaceportName,
	   j.Purpose AS JourneyPurpose
  FROM Journeys AS j
  JOIN Spaceports AS sp ON sp.Id = j.DestinationSpaceportId
  JOIN Planets AS p ON p.Id = sp.PlanetId
GROUP BY j.Id, p.Name, sp.Name, j.Purpose
ORDER BY MIN(j.JourneyEnd - j.JourneyStart)

--15. Select The Less Popular Job 
SELECT TOP(1) j.Id AS JourneyId, t.JobDuringJourney AS JobName
  FROM TravelCards AS t
  JOIN Journeys AS j ON j.Id = t.JourneyId
  JOIN Colonists AS c ON c.Id = t.ColonistId
 WHERE t.JourneyId = (
					    SELECT TOP(1) j.Id 
						  FROM Journeys AS j 
					  ORDER BY DATEDIFF(MINUTE, j.JourneyStart, j.JourneyEnd) DESC
					 )
GROUP BY j.Id, t.JobDuringJourney
ORDER BY COUNT(t.JobDuringJourney)

--16. Select Special Colonists 


--17. Planets and Spaceports 
SELECT p.Name AS Name, COUNT(sp.Id) AS [Count]
  FROM Spaceports AS sp
RIGHT JOIN Planets AS p ON p.Id = sp.PlanetId
GROUP BY p.Name
ORDER BY [Count] DESC, p.Name
GO

--18. Get Colonists Count 
CREATE FUNCTION dbo.udf_GetColonistsCount(@PlanetName VARCHAR(30))
RETURNS INT
AS 
BEGIN
DECLARE @CountAllColonists INT = (SELECT COUNT(sp.Id) AS [Count]
									FROM TravelCards AS t
									JOIN Colonists AS c ON c.Id = t.ColonistId
									JOIN Journeys AS j ON j.Id = t.JourneyId
									JOIN Spaceports AS sp ON sp.Id = j.DestinationSpaceportId
									JOIN Planets AS p ON p.Id = sp.PlanetId
								   WHERE p.Name = @PlanetName
							     )


RETURN @CountAllColonists
END
GO

SELECT dbo.udf_GetColonistsCount('Otroyphus')
GO

--19. Change Journey Purpose 
CREATE PROCEDURE usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(30))
AS
BEGIN
	DECLARE @CheckJourneyId INT = ( SELECT Id
									  FROM Journeys
									 WHERE Id = @JourneyId
								  ) 

	DECLARE @CheckPurpose VARCHAR(30) = (SELECT Purpose FROM Journeys WHERE Id = @JourneyId)

	IF (@CheckJourneyId IS NULL)
	BEGIN
		RAISERROR ('The journey does not exist!', 16, 1)
		RETURN
	END

	IF (@CheckPurpose = @NewPurpose)
	BEGIN
		RAISERROR ('You cannot change the purpose!', 16, 2)
		RETURN
	END

	UPDATE Journeys
	SET Purpose = @NewPurpose
	WHERE Id = @CheckJourneyId
END
GO

EXEC usp_ChangeJourneyPurpose 1, 'Technical'
SELECT * FROM Journeys

EXEC usp_ChangeJourneyPurpose 2, 'Educational'

EXEC usp_ChangeJourneyPurpose 196, 'Technical'

--20. Deleted Journeys 
CREATE TABLE DeletedJourneys
(
	Id INT,
	JourneyStart DATETIME,
	JourneyEnd DATETIME,
	Purpose VARCHAR(11),
	DestinationSpaceportId INT,
	SpaceshipId INT
)
GO

CREATE TRIGGER tr_DeletedJourneys ON Journeys AFTER DELETE
AS
INSERT INTO DeletedJourneys (Id, JourneyStart, JourneyEnd, Purpose, DestinationSpaceportId, SpaceshipId)
	SELECT Id, JourneyStart, JourneyEnd, Purpose, DestinationSpaceportId, SpaceshipId FROM deleted

DELETE FROM TravelCards
WHERE JourneyId = 1

DELETE FROM Journeys
WHERE Id =  1
