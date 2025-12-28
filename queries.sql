CREATE USER 'User1'@'localhost'
  IDENTIFIED WITH caching_sha2_password BY 'MySuperSecurePassword-1';


-- Visar F1-förare JOINad med Constructors som visar förarnummber, namn, vilket land de kommer ifrån, 
--  Konstruktörteam och team principal.
SELECT 
  d.DriverNumber, 
  CONCAT(d.FirstName, " ", d.LastName) AS Driver, 
  c.Country,
  ct.ConstructorTeam, 
  ct.TeamPrincipal
FROM Drivers AS d
INNER JOIN Constructors AS ct ON d.DriverID = ct.DriverID
INNER JOIN Country AS c ON d.CountryID = c.CountryID
ORDER BY ConstructorTeam;

-- Förlänger Circuit för att få plats med hela namnet på vissa banor.
ALTER TABLE RaceTracks 
MODIFY Circuit VARCHAR(40) NOT NULL;

-- Använder LIKE för att hitta det eller de team som heter "...Racing"
SELECT * FROM constructors
WHERE ConstructorTeam LIKE '%Racing'

-- Här hämtar jag ut alla race från före sommaruppehållet vilket kan ses som halvlek av F1-säsongen.
SELECT 
  rt.Circuit, 
  c.Country, 
  CONCAT(d.FirstName, ' ', d.LastName) AS Winner
FROM RaceTracks as rt 
LEFT JOIN Drivers AS d ON d.DriverID = rt.DriverID
INNER JOIN Country AS c ON c.CountryID = rt.CountryID
ORDER BY TrackID
LIMIT 14

-- Här hämtar jag ut resterande race efter sommaruppehållet, 
-- i skrivande stund har inte sista racet körts än, därför står det som null.
SELECT 
  rt.Circuit, 
  c.Country, 
  CONCAT(d.FirstName, ' ', d.LastName) AS Winner
FROM RaceTracks as rt 
LEFT JOIN Drivers AS d ON d.DriverID = rt.DriverID
INNER JOIN Country AS c ON c.CountryID = rt.CountryID
ORDER BY TrackID
LIMIT 10 OFFSET 14;

-- Uppdaterar vinnaren för sista rundan på kalendern efter finalen.
UPDATE RaceTracks 
SET DriverID = 1
WHERE TrackID = 24;

-- Tar bort "Jack Doohan" från Drivers, eftersom han blev ersatt 
-- av "Franco Colapinto" under säsongen. 
DELETE FROM Drivers 
WHERE DriverID = 24;

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

-- Visar förare, förarnummer och vilket land de kommer ifrån.
SELECT 
d.DriverID, 
CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
c.Country
FROM Drivers AS d
INNER JOIN Country AS c ON d.CountryID = c.CountryID;

-- Skapar ny användare.
CREATE USER 'fanbase'@'localhost'
IDENTIFIED WITH caching_sha2_password BY 'ILoveF1';

-- Ger SELECT-rättigheter åt fanbase-användaren.
GRANT SELECT ON RaceTracks TO 'fanbase'@'localhost';

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
ORDER BY Standings DESC;

-- Visar VIEWn för DriverStandings.
SELECT * FROM DriverStandings;

-- Visar poäng för en specifik förare över hela säsongen.
SELECT 
rt.Circuit,
CONCAT(d.FirstName, ' ', d.LastName) AS Driver,
s.Points,
c.ConstructorTeam
FROM Scores AS s
INNER JOIN Drivers AS d ON s.DriverID = d.DriverID
INNER JOIN Constructors AS c ON d.DriverID = c.DriverID
INNER JOIN RaceTracks AS rt ON s.TrackID = rt.TrackID
WHERE d.DriverID = 1;

-- Visar top 3 förare över säsongen och poäng med en HAVING.
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS Driver, 
    SUM(s.Points) AS TotalPoints
FROM drivers AS d
INNER JOIN Scores AS s ON d.DriverID = s.DriverID
WHERE d.DriverID BETWEEN 1 AND 10
GROUP BY d.DriverID
HAVING SUM(s.Points) > 300
ORDER BY d.DriverID DESC;

- Här visar jag vem vinnaren är för varje race under säsongen med en CASE-query.
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
