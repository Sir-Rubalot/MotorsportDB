CREATE DATABASE FormulaOne;
USE FormulaOne;

-- Skapar tabell för länder, både för förare, konstruktörer och race.
CREATE TABLE Country(
  CountryID INT AUTO_INCREMENT, 
  Country VARCHAR(30) NOT NULL,
  PRIMARY KEY (CountryID)
);

-- Skapar tabell för förare
CREATE TABLE Drivers(
  DriverID INT AUTO_INCREMENT, 
  Category VARCHAR(15), 
  FirstName VARCHAR(20) NOT NULL, 
  LastName VARCHAR(20) NOT NULL, 
  DriverNumber INT NOT NULL,
  CountryID INT NOT NULL,
  PRIMARY KEY (DriverID),
  FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
  );

-- Skapar tabell för konstruktörer
CREATE TABLE Constructors(
  DriverID INT AUTO_INCREMENT, 
  Category VARCHAR(15),
  ConstructorTeam VARCHAR(50) NOT NULL,
  TeamPrincipal VARCHAR(50) NOT NULL,
  CountryID INT NOT NULL,
  FOREIGN KEY (DriverID) REFERENCES Drivers (DriverID),
  FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
  );

-- Skapar tabell för banor/curcuits
CREATE TABLE RaceTracks(
  TrackID INT AUTO_INCREMENT,
  DriverID INT,
  Circuit VARCHAR(35) NOT NULL,
  CountryID INT,
  RaceDate DATE,
  PRIMARY KEY (TrackID),
  FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);

-- Skapar tabell för poängställning.
CREATE TABLE Scores(
  DriverID INT,
  Points INT,
  TrackID INT,
  FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID),
  FOREIGN KEY (TrackID) REFERENCES RaceTracks (TrackID)
);

-- Här visar jag vem vinnaren är för varje race under säsongen med en CASE-query.
SELECT 
  rt.RaceDate,
  rt.Circuit,
  CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
  CASE 
    WHEN s.Points = 25 THEN 'Winner' 
    ELSE 'Classified' 
  END AS Eligibility
FROM drivers AS d
INNER JOIN Scores AS s ON d.DriverID = s.DriverID
INNER JOIN RaceTracks AS rt ON s.TrackID = rt.TrackID
ORDER BY rt.RaceDate;

-- Här skapar jag en stoed procedure för att visa var var och en 
-- förare har fått för poäng i race race. 
DELIMITER //

CREATE PROCEDURE GetDriverInfo(IN driver_id INT)
BEGIN
  SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS FullName,
    s.Points
FROM drivers AS d
INNER JOIN Scores AS s ON d.DriverID = s.DriverID
WHERE d.DriverID = driver_id;
END //

DELIMITER ;

-- Här kallar jag på funktionen, bara att byta DriverID i ( ).
CALL GetDriverInfo(1);


-- Lägger till alla länder för RaceTracks, förare och Constructors.
INSERT INTO Country(CountryID, Country) VALUES
(1, 'Australia'),
(2, 'China'), 
(3, 'Japan'),
(4, 'Bahrain'),
(5, 'Saudi Arabia'),
(6, 'Italy'),
(7, 'Monaco'),
(8, 'Spain'),
(9, 'Canada'),
(10, 'Austria'),
(11, 'Great Britain'),
(12, 'Belgium'),
(13, 'Hungary'),
(14, 'Netherlands'),
(15, 'Azerbaijan'),
(16, 'Singapore'),
(17, 'United States of America'),
(18, 'Mexico'),
(19, 'Brazil'),
(20, 'Qatar'),
(21, 'Abu Dhabi'),
(22, 'Switzerland'),
(23, 'Finland'),
(24, 'Argentina'),
(25, 'France'),
(26, 'Germany'),
(27, 'New Zeeland'),
(28, 'Thailand');

-- Lägger till alla F1-förare.
INSERT INTO Drivers(DriverID, Category, FirstName, LastName, DriverNumber, CountryID) VALUES
(1, "F1", "Max", "Verstappen", 1, 14),
(2, "F1", "Yuki", "Tsunoda", 22, 3),
(3, 'F1', 'Lando', 'Norris', 4, 11),
(4, 'F1', 'Oscar', 'Piastri', 81, 1),
(5, 'F1', 'Charles', 'LeClerc', 16, 7),
(6, 'F1', 'Lewis', 'Hamilton', 44, 11),
(7, 'F1', 'George', 'Russell', 63, 11),
(8, 'F1', 'Kimi', 'Antonelli', 12, 6),
(9, 'F1', 'Fernando', 'Alonso', 14, 8),
(10, 'F1', 'Lance', 'Stroll', 18, 9),
(11, 'F1', 'Alexander', 'Albon', 23, 28),
(12, 'F1', 'Carlos', 'Sainz', 55, 8),
(13, 'F1', 'Isack', 'Hadjar', 6, 25),
(14, 'F1', 'Liam', 'Lawson', 30, 27),
(15, 'F1', 'Oliver', 'Bearman', 87, 11),
(16, 'F1', 'Esteban', 'Ocon', 31, 25),
(17, 'F1', 'Nico', 'Hulkenberg', 27, 26),
(18, 'F1', 'Gabriel', 'Bortoleto', 5, 19),
(19, 'F1', 'Pierre', 'Gasly', 10, 25),
(20, 'F1', 'Franco', 'Colapinto', 43, 24),
(21, '', 'Valtteri', 'Bottas', 77, 23),
(22, '', 'Sergio', 'Pérez', 11, 18),
(23, '', 'Arvid', 'Lindblad', 4, 11),
(24, '', 'Jack', 'Doohan', 7, 1);

-- Lägger till alla F1-konstruktörer.
INSERT INTO Constructors(DriverID, Category, ConstructorTeam, TeamPrincipal, CountryID) VALUES 
(1, 'F1', 'Red Bull Racing', 'Laurent Mekies', 11),
(2, 'F1', 'Red Bull Racing', 'Laurent Mekies', 11),
(3, 'F1', 'McLaren', 'Andrea Stella', 11),
(4, 'F1', 'McLaren', 'Andrea Stella', 11),
(5, 'F1', 'Ferrari', 'Fred Vasseur', 6),
(6, 'F1', 'Ferrari', 'Fred Vasseur', 6),
(7, 'F1', 'Mercedes AMG', 'Toto Wolff', 11),
(8, 'F1', 'Mercedes AMG', 'Toto Wolff', 11),
(9, 'F1', 'Aston Martin', 'Adrian Newey', 11),
(10, 'F1', 'Aston Martin', 'Adrian Newey', 11),
(11, 'F1', 'Williams', 'James Vowles', 11),
(12, 'F1', 'Williams', 'James Vowles', 11),
(13, 'F1', 'Racing Bulls', 'Alan Permaine', 11),
(14, 'F1', 'Racing Bulls', 'Alan Permaine', 11),
(15, 'F1', 'Haas', 'Ayu Komatsu', 17),
(16, 'F1', 'Haas', 'Ayu Komatsu', 17),
(17, 'F1', 'Sauber', 'Jonathan Wheatley', 22),
(18, 'F1', 'Sauber', 'Jonathan Wheatley', 22),
(19, 'F1', 'Alpine', 'Flavio Briatore', 11),
(20, 'F1', 'Alpine', 'Flavio Briatore', 11),
(21, 'F1', 'Cadillac', 'Graeme Lowdon', 17),
(22, 'F1', 'Cadillac', 'Graeme Lowdon', 17);

-- Skapar data för RaceTracks, här är hela F1-säsongen 2025.
INSERT INTO RaceTracks(TrackID, Circuit, CountryID, DriverID, RaceDate) VALUES 
(1, 'Albert Park Circuit', 1, 3, '2025-03-16'),
(2, 'Shanghai International Circuit', 2, 4, '2025-03-23'),
(3, 'Suzuka International Racing Course', 3, 1, '2025-04-06'),
(4, 'Bahrain International Circuit', 4, 4, '2025-04-13'),
(5, 'Jeddah Cornich Circuit', 5, 4, '2025-04-20'),
(6, 'Miami International Autodrome', 17, 4, '2025-05-04'),
(7, 'Imola Circuit', 6, 1, '2025-05-18'),
(8, 'Circuit de Monaco', 7, 3, '2025-05-25'),
(9, 'Circuit de Barcelona-Calalunya', 8, 4, '2025-06-01'),
(10, 'Circuit Gilles-Villeneuve', 9, 7, '2025-06-15'),
(11, 'Red Bull Ring', 10, 3, '2025-06-29'),
(12, 'Silverstone Circuit', 11, 3, '2025-07-06'),
(13, 'Circuit de Spa-Francorchamps', 12, 4, '2025-07-27'),
(14, 'Hungaroring', 13, 3, '2025-08-03'),
(15, 'Circuit Zandvoort', 14, 4, '2025-08-31'),
(16, 'Autodromo Nazionale di Monza', 6, 1, '2025-09-07'),
(17, 'Baku City Circuit', 15, 1, '2025-09-21'),
(18, 'Marina Bay Street Circuit', 16, 7, '2025-10-05'),
(19, 'Circuit Of The Americas', 17, 1, '2025-10-19'),
(20, 'Autódromo Hermanos Rodríguez', 18, 3, '2025-10-26'),
(21, 'Autodromo José Carlos Pace', 19, 3, '2025-11-09'),
(22, 'Las Vegas Strip Circuit', 17, 1, '2025-11-22'),
(23, 'Lusail International Circuit', 20, 1, '2025-11-30'),
(24, 'Yas Marina Circuit', 21, 0, '2025-12-07');

-- Importerar Google Sheets med poängställning  för alla race under säsongen.
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/F1_Points_talley.csv'
INTO TABLE scores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
