CREATE DATABASE Motorsport;
USE Motorsport;

-- Skapar tabell för förare
CREATE TABLE Drivers(
  DriverID INT PRIMARY KEY AUTO_INCREMENT, 
  Category VARCHAR(15), 
  FirstName VARCHAR(20) NOT NULL, 
  LastName VARCHAR(20) NOT NULL, 
  DriverNumber INT NOT NULL,
  CountryID INT FOREIGN KEY
  );

-- Skapar tabell för konstruktörer
CREATE TABLE Constructors(
  DriverID INT PRIMARY KEY AUTO_INCREMENT, 
  Category VARCHAR(15),
  ConstructorTeam VARCHAR(50) NOT NULL,
  TeamPrincipal VARCHAR(50) NOT NULL,
  TrackID INT NOT NULL,
  CountryID INT FOREIGN KEY
  );

-- Skapar tabell för banor/curcuits
CREATE TABLE RaceTracks(
  TrackID INT PRIMARY KEY AUTO_INCREMENT,
  DriverID INT,
  Circuit VARCHAR(30) NOT NULL,
  CountryID INT FOREIGN KEY,
  Winner VARCHAR(30) NOT NULL,
  RaceDate DATE
);

-- Skapar tabell för poängställning.
CREATE TABLE Scores(
  DriverID INT,
  Points INT,
  TrackID INT
);

-- Skapar tabell för länder, både för förare, konstruktörer och race.
CREATE TABLE Country(
  CountryID INT PRIMARY KEY AUTO_INCREMENT, 
  Country VARCHAR(30) NOT NULL 
);


