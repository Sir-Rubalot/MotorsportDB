CREATE USER 'User1'@'localhost'
  IDENTIFIED WITH caching_sha2_password BY 'MySuperSecurePassword-1';


-- Visar F1-förare JOINad med Constructors som visar örarnummber, namn, vilket land de kommer ifrån, 
--  Konstruktörteam och team principal.
SELECT d.DriverNumber, CONCAT(d.FirstName, " ", d.LastName) AS Driver, d.CountryOfOrigin, 
c.ConstructorTeam, c.TeamPrincipal
FROM Drivers AS d
INNER JOIN Constructors AS c ON d.DriverID = c.DriverID
ORDER BY ConstructorTeam;

-- Förlänger Circuit för att få plats med hela namnet på vissa banor.
ALTER TABLE RaceTracks 
MODIFY Circuit VARCHAR(50) NOT NULL;

-- Visar alla banor och vem som har vunnit på dem. Jag hämtar namn från Drivers och JOINar med RaceTracks.
SELECT rt.Circuit, rt.Country, CONCAT(d.FirstName, ' ', d.LastName) AS Winner
FROM RaceTracks as rt 
INNER JOIN Drivers AS d ON d.DriverID = rt.DriverID
ORDER BY TrackID;

-- Här hämtar jag ut alla race från före sommaruppehållet vilket kan ses som halvlek av F1-säsongen.
SELECT rt.Circuit, rt.Country, CONCAT(d.FirstName, ' ', d.LastName) AS Winner
FROM RaceTracks as rt 
INNER JOIN Drivers AS d ON d.DriverID = rt.DriverID
ORDER BY TrackID
LIMIT 14;

-- Här hämtar jag ut resterande race efter sommaruppehållet, 
-- i skrivande stund har inte sista racet körts än, därför står det som null.
SELECT rt.Circuit, rt.Country, CONCAT(d.FirstName, ' ', d.LastName) AS Winner
FROM RaceTracks as rt 
LEFT JOIN Drivers AS d ON d.DriverID = rt.DriverID
ORDER BY TrackID
LIMIT 10 OFFSET 14;

-- Tar bort "Jack Doohan" från Drivers, eftersom han blev ersatt av "Franco Colapinto" under säsongen. 
DELETE FROM Drivers 
WHERE DriverID = 24;

-- Hämtar ut datum, vinnare och konstruktörer för varje bara, en JOIN från 3 tabeller.
SELECT 
  rt.RaceDate,
  rt.Circuit, 
  rt.Country, 
  CONCAT(d.FirstName, ' ', d.LastName) AS Winner,
  c.ConstructorTeam
FROM RaceTracks as rt 
LEFT JOIN Drivers AS d ON d.DriverID = rt.DriverID
LEFT JOIN Constructors AS c ON c.DriverID = d.DriverID
ORDER BY rt.TrackID;

-- Uppdaterar vinnaren för sista rundan på kalendern efter finalen.
UPDATE RaceTracks 
SET DriverID = 1
WHERE TrackID = 24;

SELECT 
  rt.Circuit, 
  d.CountryID AS Country, 
  CONCAT(d.FirstName, ' ', d.LastName) AS Winner,
  c.ConstructorTeam
FROM RaceTracks as rt 
LEFT JOIN Drivers AS d ON d.DriverID = rt.DriverID
LEFT JOIN Constructors AS c ON c.DriverID = d.DriverID
ORDER BY rt.TrackID;

-- Visar förare, förarnummer och vilket land de kommer ifrån.
SELECT 
d.DriverID, 
CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
c.Country
FROM Drivers AS d
INNER JOIN Country AS c ON d.CountryID = c.CountryID;

-- Visar datum, bana, land, vinnare och konstruktör.
SELECT 
rt.RaceDate,
rt.Circuit, 
c.Country AS Country,
CONCAT(d.FirstName, ' ', d.LastName) AS Winner,
ct.ConstructorTeam
FROM RaceTracks AS rt 
INNER JOIN Drivers AS d ON d.DriverID = rt.DriverID
INNER JOIN constructors AS ct ON rt.DriverID = ct.DriverID
INNER JOIN Country AS c ON rt.CountryID = c.CountryID


LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.4\Uploads\F1 Points talley - Blad1.csv'
INTO TABLE scores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;