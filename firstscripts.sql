-1. Yukarıdaki tabloların create scriptlerini oluşturunuz.

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

SELECT * FROM takim WHERE takim.id_league = 1;

--5. İsmi “Türkiye” olan en üst seviyeli ligdeki puan tablosunu getiren scripti yazınız.

SELECT Takim.adı AS TakimAdı, Takim.puan AS Puan FROM Takim
INNER JOIN Lig ON Takim.id_league = Lig.id WHERE Lig.id_country = 1 AND Takim.seviye = 1
ORDER BY Takim.puan DESC;

--6. Türkiye liglerindeki puan ortalamalarını gösteren scrpiti yazınız.

SELECT AVG(puan) AS PuanOrtalaması FROM Takim WHERE id_league IN (SELECT id FROM Lig WHERE id_country = 1);

--7. Bir ligin Gol kralını getiren scprit yazınız. (oyuncu adı, soyadı, takım adı, nereli olduğu)

SELECT Oyuncu.adı, Oyuncu.soyadı, Takim.adı, Country.name AS Nereli, Oyuncu.attigi_gol FROM Oyuncu
INNER JOIN Takim ON Oyuncu.id_team = Takim.id
INNER JOIN Country ON Oyuncu.id_country = Country.id
ORDER BY Oyuncu.attigi_gol DESC
LIMIT 1;

--8. Tüm liglerde attığı gol yediği golden daha küçük olan takımları getiren scripti yazınız.

--Bunun için yedigi_gol olarak bir column aşağıdaki gibi eklendi;
ALTER TABLE Oyuncu ADD yedigi_gol INT;

--Ardından tablodaki kolona veriler UPDATE ile işlendi

UPDATE Oyuncu
SET yedigi_gol = 10 WHERE adı = 'Arda';

UPDATE Oyuncu
SET yedigi_gol = 12 WHERE adı = 'Lionel';

UPDATE Oyuncu
SET yedigi_gol = 10 WHERE adı = 'Cristiano';

UPDATE Oyuncu
SET yedigi_gol = 8 WHERE adı = 'Robin';

UPDATE Oyuncu
SET yedigi_gol = 6 WHERE adı = 'Nani';

-- Ardından sorgulama yapıldı

SELECT Oyuncu.adı AS OyuncuAdı, oyuncu.attigi_gol AS AttığıGol, oyuncu.yedigi_gol AS YediğiGol FROM Oyuncu
INNER JOIN Takim ON Oyuncu.id_team = Takim.id WHERE oyuncu.attigi_gol < Oyuncu.yedigi_gol;

--9. Bir takımın oyuncularının toplam gol sayısını ve takımın gol sayısını yan yana getiren bir
--scprit yazınız. (kontrol sorgusu gibi, birisi takım verisi, diğeri oyuncuların toplamı olacak)

SELECT Takim.adı AS TakımAdı, Takim.attigi_gol AS TakımGol, SUM(Oyuncu.attigi_gol) AS OyuncuToplamGol FROM Takim
LEFT JOIN Oyuncu ON Takim.id = Oyuncu.id_team GROUP BY Takim.adı, Takim.attigi_gol;
