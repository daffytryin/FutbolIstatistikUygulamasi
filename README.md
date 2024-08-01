# Futbol İstatistik Uygulamasi

Futbol İstatistik Uygulaması
Country: id, name
Lig: id, adı, id_country(hangi ülkenin ligi)
Takim: id, adı, id_leauge, kuruluş yılı, attığı gol, yediği gol, puan, seviye(1=en üst lig, 2, onun bir
alt ligi gibi)
Oyuncu: id, adı, soyadı, id_team, id_country(nereli), attığı gol
1. Yukarıdaki tabloların create scriptlerini oluşturunuz.
2. Bu tabloları dolduran insert scriptler yazınız. Ligi olmayan takım
3. İsmi “Türkiye” olan ülkenin liglerinin listesini getiren scripti yazınız.
4. İsmi “Türkiye” olan ülkenin takımların listesini getiren scripti yazınız.
5. İsmi “Türkiye” olan en üst seviyeli ligdeki puan tablosunu getiren scripti yazınız.
6. Türkiye liglerindeki puan ortalamalarını gösteren scrpiti yazınız.
7. Bir ligin Gol kralını getiren scprit yazınız. (oyuncu adı, soyadı, takım adı, nereli olduğu)
8. Tüm liglerde attığı gol yediği golden daha küçük olan takımları getiren scripti yazınız.
9. Bir takımın oyuncularının toplam gol sayısını ve takımın gol sayısını yan yana getiren bir
scprit yazınız. (kontrol sorgusu gibi, birisi takım verisi, diğeri oyuncuların toplamı olacak)


Futbol İstatistik Uygulaması (using SQL)
Assignment from Garanti Teknoloji & Patika.dev
Author: Sümeyye Saban


Country: id, name
Lig: id, adı, id_country(hangi ülkenin ligi)
Takim: id, adı, id_leauge, kuruluş yılı, attığı gol, yediği gol, puan, seviye(1=en üst lig, 2, onun bir
alt ligi gibi)
Oyuncu: id, adı, soyadı, id_team, id_country(nereli), attığı gol
1.	Yukarıdaki tabloların create scriptlerini oluşturunuz.
CREATE TABLE Country(
id int PRIMARY KEY,
name varchar NOT NULL
);

CREATE TABLE Lig(
id INT PRIMARY KEY,
adı varchar(255) NOT NULL,
id_country INT
	FOREIGN KEY (id_country) REFERENCES Country (id)
);

CREATE TABLE Takim (
  id INT PRIMARY KEY,
  adı VARCHAR(255) NOT NULL,
  id_league INT,
  kurulus_yili INT NOT NULL,
  attigi_gol INT NOT NULL,
  yedigi_gol INT NOT NULL,
  puan INT NOT NULL,
  seviye INT NOT NULL,
  FOREIGN KEY (id_league) REFERENCES Lig (id)
);
CREATE TABLE Oyuncu (
  id INT PRIMARY KEY,
  adı VARCHAR(255) NOT NULL,
  soyadı VARCHAR(255) NOT NULL,
  id_team INT,
  id_country INT,
  attigi_gol INT NOT NULL,
  FOREIGN KEY (id_team) REFERENCES Takim (id),
  FOREIGN KEY (id_country) REFERENCES Country (id)
);
 
2.	Bu tabloları dolduran insert scriptler yazınız. Ligi olmayan takım
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
  (3, 'Cristiano', 'Ronaldo', 3, 3, 22),
  (4, 'Robin', 'van Persie', 3, 3, 15),
  (5, 'Nani', 'Gomes', 4, 1, 10);

 
3.	İsmi “Türkiye” olan ülkenin liglerinin listesini getiren scripti yazınız.
SELECT Lig.adı AS LigAdı FROM lig
WHERE lig.id_country = 1;
or 
SELECT * FROM Lig WHERE id_country = (SELECT id FROM Country WHERE name = 'Turkey');
 



4.	İsmi “Türkiye” olan ülkenin takımların listesini getiren scripti yazınız.
SELECT takim.adı AS TakımAdı
FROM takim
WHERE takim.id_league = 1;


 


5.	İsmi “Türkiye” olan en üst seviyeli ligdeki puan tablosunu getiren scripti yazınız.

SELECT Takim.adı AS TakimAdı, Takim.puan AS Puan
FROM Takim
INNER JOIN Lig ON Takim.id_league = Lig.id
WHERE Lig.id_country = 1 AND Takim.seviye = 1
ORDER BY Takim.puan DESC;


 
6.	Türkiye liglerindeki puan ortalamalarını gösteren scrpiti yazınız

SELECT AVG(puan) AS PuanOrtalaması
FROM Takim
WHERE id_league IN (SELECT id FROM Lig WHERE id_country = 1);
 


7.	Bir ligin Gol kralını getiren scprit yazınız. (oyuncu adı, soyadı, takım adı, nereli olduğu)

SELECT Oyuncu.adı, Oyuncu.soyadı, Takim.adı, Country.name AS Nereli, Oyuncu.attigi_gol FROM Oyuncu
INNER JOIN Takim ON Oyuncu.id_team = Takim.id
INNER JOIN Country ON Oyuncu.id_country = Country.id
ORDER BY Oyuncu.attigi_gol DESC
LIMIT 1;

 

8.	Tüm liglerde attığı gol yediği golden daha küçük olan takımları getiren scripti yazınız.
İlk verilenler arasında yedigi_gol isimli column oluşturulmadığından herhangi bir sonuç alamadım ve error ile karşılaştım. Çözümü için ( https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-alter-table/ ) ALTER TABLE table_name action; komutu ile yeni bir column oluşturuldu,  ardından UPDATE  komutu ile (https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/ ) kolon içerisinde veriler null yerine int değer olarak güncellendi.
1. ALTER TABLE Oyuncu ADD yedigi_gol INT;

2. UPDATE Oyuncu
SET yedigi_gol = 10 WHERE adı = 'Arda';

UPDATE Oyuncu
SET yedigi_gol = 12 WHERE adı = 'Lionel';

UPDATE Oyuncu
SET yedigi_gol = 10 WHERE adı = 'Cristiano';

UPDATE Oyuncu
SET yedigi_gol = 8 WHERE adı = 'Robin';

UPDATE Oyuncu
SET yedigi_gol = 6 WHERE adı = 'Nani';

Ardından istenilen bilgi ekranda çağırıldı.

SELECT Oyuncu.adı AS OyuncuAdı, oyuncu.attigi_gol AS AttığıGol, oyuncu.yedigi_gol AS YediğiGol FROM Oyuncu
INNER JOIN Takim ON Oyuncu.id_team = Takim.id
WHERE oyuncu.attigi_gol < Oyuncu.yedigi_gol;

 
9.	Bir takımın oyuncularının toplam gol sayısını ve takımın gol sayısını yan yana getiren bir scprit yazınız. (kontrol sorgusu gibi, birisi takım verisi, diğeri oyuncuların toplamı olacak)


SELECT Takim.adı AS TakımAdı, Takim.attigi_gol AS TakımGol, SUM(Oyuncu.attigi_gol) AS OyuncuToplamGol
FROM Takim
LEFT JOIN Oyuncu ON Takim.id = Oyuncu.id_team
GROUP BY Takim.adı, Takim.attigi_gol;
 

REFERENCES:
•	https://www.w3schools.com/sql/default.asp for commands/scripts
•	https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-select/ for commands/scripts


