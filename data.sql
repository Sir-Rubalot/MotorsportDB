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
