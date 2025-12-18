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

-- Använder LIKE för att hitta det eller de team som heter "...Racing"
SELECT * FROM constructors
WHERE ConstructorTeam LIKE '%Racing'

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
INNER JOIN Country AS c ON rt.CountryID = c.CountryID;

-- Visar datum, race, vinnare, poäng och team
SELECT DISTINCT
rt.RaceDate,
rt.Circuit, 
c.Country AS Country,
CONCAT(d.FirstName, ' ', d.LastName) AS Winner,
s.Points,
ct.ConstructorTeam
FROM RaceTracks AS rt 
INNER JOIN Drivers AS d ON d.DriverID = rt.DriverID
INNER JOIN Constructors AS ct ON rt.DriverID = ct.DriverID
INNER JOIN Country AS c ON rt.CountryID = c.CountryID
INNER JOIN Scores AS s ON s.DriverID = d.DriverID
Where s.Points = (
  SELECT MAX(s2.Points)
  FROM Scores AS s2
  WHERE s2.DriverID = d.DriverID
  AND s2.TrackID = rt.TrackID
)
ORDER BY RaceDate;

-- Skapar ny användare.
CREATE USER 'fanbase'@'localhost'
IDENTIFIED WITH caching_sha2_password BY 'ILoveF1';

-- Ger SELECT-rättigheter åt fanbase-användaren.
GRANT SELECT ON RaceTracks TO 'fanbase'@'localhost'

-- Hämtar ut bana, förare, poäng och team för varje race.
SELECT 
rt.Circuit,
rt.TrackID,
d.DriverID,
CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
s.Points,
c.ConstructorTeam
FROM Scores AS s
INNER JOIN Drivers AS d ON s.DriverID = d.DriverID
INNER JOIN Constructors AS c ON d.DriverID = c.DriverID
INNER JOIN RaceTracks AS rt ON s.TrackID = rt.TrackID
ORDER BY TrackID;

-- Skapar en view for Standings.
CREATE VIEW DriverStandings AS
SELECT 
  d.DriverID,
  CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
  c.ConstructorTeam,
  SUM(s.Points) AS Standings
FROM Scores AS s
INNER JOIN Drivers AS d ON s.DriverID = d.DriverID 
INNER JOIN constructors AS c ON d.DriverID = c.DriverID
GROUP BY d.DriverID, d.FirstName, d.LastName, c.ConstructorTeam
ORDER BY Standings DESC

-- Visar VIEWn för DriverStandings.
SELECT * FROM DriverStandings;

SELECT DISTINCT
  rt.RaceDate,
  rt.Circuit, 
  c.Country AS Country,
  CONCAT(d.FirstName, ' ', d.LastName) AS Winner,
  SUM(s.Points) AS TotalPoints,
  ct.ConstructorTeam
FROM RaceTracks AS rt 
INNER JOIN Drivers AS d ON d.DriverID = rt.DriverID
INNER JOIN Constructors AS ct ON rt.DriverID = ct.DriverID
INNER JOIN Country AS c ON rt.CountryID = c.CountryID
INNER JOIN Scores AS s ON s.DriverID = d.DriverID
WHERE rt.RaceDate = '2025-12-07'
GROUP BY 
  d.DriverID,
  rt.RaceDate,
  rt.Circuit,
  c.Country,
  ct.ConstructorTeam
ORDER BY TotalPoints DESC;

SELECT 
    rt.RaceDate,
    rt.Circuit, 
    c.Country AS Country,
    CONCAT(d.FirstName, ' ', d.LastName) AS DriverName,
    s.Points,
    ct.ConstructorTeam
FROM Drivers AS d
INNER JOIN Scores AS s ON s.DriverID = d.DriverID
INNER JOIN RaceTracks AS rt ON rt.DriverID = d.DriverID
INNER JOIN Constructors AS ct ON ct.DriverID = d.DriverID
INNER JOIN Country AS c ON rt.CountryID = c.CountryID
WHERE rt.RaceDate = '2025-12-07'
GROUP BY 
    d.DriverID, 
    rt.RaceDate, 
    rt.Circuit, 
    c.Country,
    ct.ConstructorTeam,
    s.Points
ORDER BY s.Points DESC;

SELECT 
rt.Circuit,
CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
s.Points,
c.ConstructorTeam
FROM Scores AS s
INNER JOIN Drivers AS d ON s.DriverID = d.DriverID
INNER JOIN Constructors AS c ON d.DriverID = c.DriverID
INNER JOIN RaceTracks AS rt ON s.TrackID = rt.TrackID
WHERE d.DriverID = 1