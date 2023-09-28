--          Drop Tables         --
-- DROP TABLE IF EXISTS Lesson;
-- DROP TABLE IF EXISTS Test;
-- DROP TABLE IF EXISTS Client;
-- DROP TABLE IF EXISTS AdminStaff;
-- DROP TABLE IF EXISTS Instructor;
-- DROP TABLE IF EXISTS Centre; 
-- DROP TABLE IF EXISTS Car; 
-- DROP TABLE IF EXISTS School;

----------  Task 1       ----------
--          Create Tables        --
CREATE TABLE Centre (
    CentreID CHAR(4) PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    PhoneNo VARCHAR(30)
);
CREATE TABLE Car (
    CarID CHAR(4) PRIMARY KEY,
    RegNo VARCHAR(8),
    Model VARCHAR(255),
    UNIQUE(RegNo)
);
CREATE TABLE School (
    SchoolID CHAR(4) PRIMARY KEY,
    Address VARCHAR(255)
);
CREATE TABLE AdminStaff(
    EmpID CHAR(4) PRIMARY KEY,
	Forename VARCHAR(255),
    Surname VARCHAR(255),
    Gender CHAR(1) CHECK ( Gender IN ('F','M','O')),
    PhoneNo VARCHAR(30),
    Address VARCHAR (255),
	Role VARCHAR(255),
    SchoolID CHAR(4),
    FOREIGN KEY (SchoolID) REFERENCES School (SchoolID)
);
CREATE TABLE Instructor (
    EmpID CHAR(4) PRIMARY KEY,
	Forename VARCHAR(255),
    Surname VARCHAR(255),
    Gender CHAR(1) CHECK ( Gender IN ('F','M','O')),
    PhoneNo VARCHAR(30),
    Address VARCHAR (255),
	LicenceNo VARCHAR(255),
    SchoolID CHAR(4),
    CarID CHAR(4),
    UNIQUE (LicenceNo),
	FOREIGN KEY (SchoolID) REFERENCES School (SchoolID),
    FOREIGN KEY (CarID) REFERENCES Car (CarID)
);
CREATE TABLE Client (
    ClientID CHAR(4) PRIMARY KEY,
    Forename VARCHAR(255),
    Surname VARCHAR(255),
    Gender CHAR(1) CHECK (Gender IN('F','M','O')),
    DoB DATE,
    PhoneNo VARCHAR(30),
    Address VARCHAR(255),
    ProvLicenceNo VARCHAR(255),
    UNIQUE(ProvLicenceNo)
);

CREATE TABLE Lesson (
    OnDate Date,
    OnTime Time,
    ClientID CHAR(4),
    EmpID CHAR(4),
    PRIMARY KEY (OnDate,OnTime,ClientID),
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
    FOREIGN KEY (EmpID) REFERENCES Instructor (EmpID)
);
CREATE TABLE Test (
    OnDate Date,
    OnTime Time,
    ClientID CHAR(4),
    EmpID CHAR(4),
    CentreID CHAR(4),
    Status CHAR(10) CHECK (Status IN ('Not Taken','Passed','Failed')),
    Reason VARCHAR(255) NULL,
    PRIMARY KEY (OnDate,OnTime,ClientID),
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
    FOREIGN KEY (EmpID) REFERENCES Instructor (EmpID),
    FOREIGN KEY (CentreID) REFERENCES Centre (CentreID)
);

--        Insert Data            --
-- Centre
INSERT INTO Centre VALUES ('1','Canterbury','12 Meryl Street','+44 1227-968-5287');
INSERT INTO Centre VALUES ('2','Whitstable','5 The Strand, Whitstable','01227457012');
INSERT INTO Centre VALUES ('3','Faversham','1 High Street','01795 865129');

-- Car
INSERT INTO Car VALUES('124','BD51 SMR','VW Polo');
INSERT INTO Car VALUES('653','WS62 QWE','Ford Focus');
INSERT INTO Car VALUES('912','FD52 TGF','VW Polo');
INSERT INTO Car VALUES('167','FD52 YTR','VW Polo');

-- School
INSERT INTO School VALUES('1','12 Whitechapel, Canterbury');
INSERT INTO School VALUES('2','9 Middle Wall, Whitstable');

-- AdminStaff
INSERT INTO AdminStaff VALUES('1006','Fred','Grimes','M','012275435665','27 Cherry Street','assistant','2');
INSERT INTO AdminStaff VALUES('1009','Jill','Joffries','F','+44776618645','27 Cherry Street','manager','1');
INSERT INTO AdminStaff VALUES('1019','Justine','Joffries','F','(01227) 812035','19 Creosote Road','assistant','1');

-- Instructor
INSERT INTO Instructor VALUES('2009','James','Joffries','M','012275435665','27 Cherry Street','FTR76398','1','124');
INSERT INTO Instructor VALUES('2011','Jim','Adams','M','065490125674','4 The Vale','TGY98555a','2','912');
INSERT INTO Instructor VALUES('2013','Trinny','Vair','F','0044587208725','17 High Street, Chartham','YHF7665467','1','653');

-- Client
INSERT INTO Client VALUES('1','Andy','Twill','M','1998-02-01','0044678412349876','27 Cherry Street, CT4 7NF','TYH7890');
INSERT INTO Client VALUES('2','Sue','Adams','F','1989-06-14','0841-234-876','45 Eggy Lane','CIO67891');
INSERT INTO Client VALUES('3','Jean','Adams','F','2001-11-19','01227765329','4 Harkness Lane, Canterbury','RTY678923');

-- Lesson
INSERT INTO Lesson VALUES('2017-06-24','10:00:00','1','2011');
INSERT INTO Lesson VALUES('2019-06-07','10:00:00','2','2009');
INSERT INTO Lesson VALUES('2017-07-12','14:00:00','1','2011');
INSERT INTO Lesson VALUES('2017-08-19','16:00:00','1','2011');
INSERT INTO Lesson VALUES('2020-08-17','16:00:00','2','2011');
INSERT INTO Lesson VALUES('2020-08-01','14:00:00','1','2009');

-- Test
INSERT INTO Test VALUES('2018-03-01','11:00:00','1','2009','2','Passed',null);
INSERT INTO Test VALUES('2019-08-13','13:00:00','2','2011','3','Failed','Lack of Observation');
INSERT INTO Test VALUES('2019-10-21','11:00:00','2','2011','2','Failed','Speeding');
INSERT INTO Test VALUES('2020-08-19','10:00:00','2','2009','2','Not Taken',null);


----------  Task 2       ----------
--          Queries              --
             
-- 2.1 - Select Lessons Taught by Instructors on Cherry Street
-- This query retrieves lessons taught by instructors whose address contains 'Cherry Street'.
SELECT  Lesson.OnDate, Lesson.OnTime, Instructor.Surname
FROM    Lesson 
INNER JOIN Instructor ON Lesson.EmpID=Instructor.EmpID
WHERE   Instructor.Address LIKE '%Cherry Street%';

-- 2.2 - Count of Test Status for Female Clients
-- This query counts the test status for female clients and labels the count as "num".
SELECT Test.Status, COUNT(*) AS "num"
FROM Test
INNER JOIN Client ON Test.ClientID=Client.ClientID
WHERE Client.Gender='F'
GROUP BY Status;

-- 2.3 - Union of AdminStaff and Instructor with Surname 'Joffries'
-- This query combines the results of AdminStaff and Instructor tables for employees with the surname 'Joffries'.
SELECT	EmpID, Forename, Surname
FROM	AdminStaff
WHERE	Surname='Joffries'
UNION
SELECT	EmpID, Forename, Surname
FROM 	Instructor
WHERE 	Surname='Joffries';

--	2.4  Instructors Without Any Lessons
-- This query retrieves instructors who have no associated lessons taught.
SELECT 	School.Address, School.SchoolID, Instructor.Forename, Instructor.Surname
FROM	Instructor
INNER JOIN School ON Instructor.SchoolID=School.SchoolID
WHERE	NOT EXISTS (SELECT *
					FROM Lesson
					WHERE EmpID=Instructor.EmpID
					);

-- 2.5 - Details of Clients, Tests, and Instructors in Whitstable Centre
-- This query retrieves details of clients, tests, and instructors associated with the 'Whitstable' centre.
SELECT	Centre.Name, Test.OnDate, Test.OnTime, Test.Status, Client.Forename, 
        Client.Surname, School.Address, Car.Model
FROM 	Test
INNER JOIN Centre ON Test.CentreID=Centre.CentreID
INNER JOIN Client ON Test.ClientID=Client.ClientID
INNER JOIN Instructor ON Test.EmpID=Instructor.EmpID
INNER JOIN School ON Instructor.SchoolID=School.SchoolID
INNER JOIN Car ON Instructor.CarID=Car.CarID
WHERE Centre.Name='Whitstable'
ORDER BY Client.Surname ASC, Client.Forename ASC;


-- 2.6 - Update Lesson Instructor Based on Criteria
-- This query updates the instructor for lessons taught by James Joffries on or after '2020-12-06' to Jim Adams.
UPDATE Lesson
INNER JOIN Instructor ON Lesson.EmpID = Instructor.EmpID
SET Lesson.EmpID = (
	SELECT 	EmpID
	FROM 	Instructor
	WHERE 	Surname = 'Adams'
		AND Forename='Jim'
)
WHERE 	Lesson.OnDate > '2020-12-06' 
	AND Instructor.Surname = 'Joffries'
	AND Instructor.Forename = 'James';



----------  Further Queries (Not part of the assignment brief)    ----------

-- New Query 1: Find Clients with No Test Records
-- This query retrieves clients who do not have any associated test records.
SELECT Client.ClientID, Client.Forename, Client.Surname
FROM Client
WHERE NOT EXISTS (
    SELECT *
    FROM Test
    WHERE Test.ClientID = Client.ClientID
);

-- New Query 2: Calculate the Average Age of Clients
-- This query calculates the average age of clients.
SELECT AVG(DATEDIFF(CURRENT_DATE, Client.DoB) / 365) AS "Average Age"
FROM Client;

-- New Query 3: List Instructors with Multiple License Numbers
-- This query lists instructors who have multiple license numbers.
SELECT Instructor.EmpID, Instructor.Forename, Instructor.Surname
FROM Instructor
GROUP BY Instructor.EmpID, Instructor.Forename, Instructor.Surname
HAVING COUNT(DISTINCT Instructor.LicenceNo) > 1;





















