CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(100) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear INT NOT NULL,
	[Length] TIME,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating DECIMAL(2, 1),
	Notes NVARCHAR(MAX)
)

INSERT INTO Directors VALUES
('Ivan Ivanov', 'Golden boot Winner'),
('Stan Petrov', 'Multiple international awards'),
('James Cameron', 'FC Liverpool legend'),
('Sam Mayor', 'MK3 World Champion'),
('Dany De La Hoya', 'Very talented')

INSERT INTO Genres VALUES
('Comedy', 'Very funny...'),
('Action', 'Weapons mepons'),
('Horror', 'Not for children'),
('SciFi', 'Space and aliens'),
('Drama', 'OMG')

INSERT INTO Categories VALUES
('1', NULL),
('2', NULL),
('3', NULL),
('4', NULL),
('5', NULL)

INSERT INTO Movies VALUES
('Captain America', 1, 1988, '1:22:00', 1, 5, 9.5, 'Superhero'),
('Mean Machine', 1, 1998, '1:40:00', 2, 4, 8.0, 'Prison'),
('Little Cow', 2, 2007, '1:35:55', 3, 3, 2.3, 'Agro'),
('Smoked Almonds', 5, 2013, '2:22:25', 4, 2, 7.8, 'Whiskey in the Jar'),
('I''m very mad!', 4, 2018, '1:30:02', 5, 1, 9.9, 'Rating 10 not supported') 