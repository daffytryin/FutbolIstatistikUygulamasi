--1. Yukarıdaki tabloların create scriptlerini oluşturunuz.

CREATE TABLE Country(
id int,
name varchar
);

CREATE TABLE Lig(
id INT,
adı varchar,
id_country INT,
FOREIGN KEY (id_country) REFERENCES Country (id)
);

CREATE TABLE Takim (
  id INT PRIMARY KEY,
  adı VARCHAR,
  id_league INT,
  kurulus_yili INT,
  attigi_gol INT,
  yedigi_gol INT,
  puan INT,
  seviye INT,
  FOREIGN KEY (id_league) REFERENCES Lig (id)
);
CREATE TABLE Oyuncu (
  id INT PRIMARY KEY,
  adı VARCHAR,
  soyadı VARCHAR,
  id_team INT,
  id_country INT,
  attigi_gol INT,
  FOREIGN KEY (id_team) REFERENCES Takim (id),
  FOREIGN KEY (id_country) REFERENCES Country (id)
);

--2. Bu tabloları dolduran insert scriptler yazınız. Ligi olmayan takım

INSERT INTO Country (id, name)
VALUES
  (1, 'Turkey'),
  (2, 'Spain'),
  (3, 'England');
INSERT INTO Lig (id, adı, id_country)
VALUES
  (1, 'Türkiye Ligi', 1),
  (2, 'La Liga', 2),
  (3, 'Premier League', 3);
INSERT INTO Takim (id, adı, id_league, kurulus_yili, attigi_gol, yedigi_gol, puan, seviye)
VALUES
  (1, 'Galatasaray', 1, 1905, 60, 30, 75, 1),
  (2, 'Barcelona', 2, 1899, 80, 20, 85, 1),
  (3, 'Manchester United', 3, 1878, 70, 40, 70, 1),
  (4, 'Fenerbahçe', 1, 1907, 55, 35, 70, 1);
INSERT INTO Oyuncu (id, adı, soyadı, id_team, id_country, attigi_gol)
VALUES
  (1, 'Arda', 'Turan', 1, 1, 8),
  (2, 'Lionel', 'Messi', 2, 2, 25),
  (3, 'Cristiano', 'Ronaldo', 3, 3, 22)
);

--3. İsmi “Türkiye” olan ülkenin liglerinin listesini getiren scripti yazınız.

SELECT * FROM Lig WHERE id_country = (SELECT id FROM Country WHERE name = 'Turkey');
--or
SELECT * FROM lig WHERE lig.id_country = 1;

--4. İsmi “Türkiye” olan ülkenin takımların listesini getiren scripti yazınız

SELECT * FROM takim
WHERE takim.id_league = 1;
