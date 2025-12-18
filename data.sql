CREATE DATABASE Motorsport;
USE Motorsport;

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
