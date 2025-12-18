MotorsportDB
Databasutformning och motivering

Jag har valt att göra en databas innehållande Formel 1-förare och deras respektive team samt alla banor under hela 2025 års säsong och poängställning för varje förare. 
Jag har gjort queries för att representera den verkliga Formel 1-säsongen, t.ex där en förare i ett team blir ersatt av en annan förare, så jag gör en DELETE på honom. Jag har även gjort en UPDATE på sista racet eftersom jag började med denna databasen innan säsongen var helt avslutad. 
Jag har gjort en användarroll som heter fanbase och ger den rättigheter till enbart RaceTracks för att kunna se kalendern och när racen hålls. 
Datan databasen ska hantera är helt enkelt hålla koll på förarna, vilket team de kör för, va de kommer ifrån och hur de har placerats i de olika racen samt poänghållning. 

Tabellerna jag använder är: 
Drivers, där jag lagrar förarna, DriverID(Primary Key), om de kör i F1 eller inte, för- och efternamn, deras startnummer och vilket land de kommer ifrån vilket kopplas till Country med CountryID(Foreign Key). 
Constructors, där jag kopplat DriverID(Primary Key), innehåller om de är aktiva i F1 eller inte,  vad teamet heter, vem som är chef och vilket land deras bas ligger i med CountryID(Foreign Key). 
Country, som innehåller CountryID(Primary Key) och Country, lagrar länder för var förare kommer ifrån, var teamen är baserade och i vilket land banorna ligger i. 
RaceTracks, som lagrar TrackID(Primary Key), som är kopplat till Scores, vad banorna heter, vilket land banorna ligger i CountryID(Foreign Key), vem som vunnit racet med DriverID(Foreign Key) och vilket datum racet hölls. 
Scores, som återigen kopplas till DriverID, innehåller poäng tilldelat förarna för alla race och TrackID(Foreign Key) som håller koll på rätt poäng för rätt bana/race. 

Jag valde att dela upp det såhär efter överläggning med Matthias, vår lärare, om att dela upp datan mer i tabeller för separata funktioner. Först hade jag länder både i Drivers och Constructors, nu har jag en tabell som kan lagra länder för både Drivers, Constructors och RaceTracks. Detta blir mycket enklare och tydligare att ha alla länder på ett ställe, och att man då bara behöver ett “Great Britain” till exempel som både hänvisar till Drivers, Constructors och RaceTracks. På så sätt undviker jag dubbletter och redundant data i databasen, men också om jag skulle vilja lägga till fler team eller förare i framtiden så är det enkelt att lägga till dem i rätt tabell och t.ex koppla rätt länder osv. Med detta säkerställer jag att jag uppfyller 3NF och inte har någon redundant data. 

Datatyperna jag använt är INT och VARCHAR och DATE. VARCHAR() har jag använt för att begränsa antalet tecken som matas in eftersom jag vet exempelvis vad den längsta banan, landet eller teamet heter och behöver därför inte använda TEXT eftersom det suger mer prestanda. INT använder jag för jag matar in mestadels ett eller två tecken i datatabellerna. DATE använder jag för att få ett snyggt format på datumen som är kopplade till alla race under säsongen. 
Jag använder NOT NULL i de flesta kolumner för att säkerställa att de har åtminstone ett värde och går att spåra. 

Om vi snackar lite relationer så kan man se att en One-to-Many-relation finns i till exempel Country, eftersom CountryID kopplas till både Drivers, Constructors och RaceTracks. Ett mer specifikt exempel är “Great Britain” som både går till flera förare, de flesta teamen och även en bana i RaceTracks. 
