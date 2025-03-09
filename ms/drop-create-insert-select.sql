-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-12-27 00:41:30.894

-- foreign keys
ALTER TABLE AlbumGenre DROP CONSTRAINT AlbumGenre_Album;

ALTER TABLE AlbumGenre DROP CONSTRAINT AlbumGenre_Genre;

ALTER TABLE ArtistAlbum DROP CONSTRAINT ArtistAlbum_Album;

ALTER TABLE ArtistAlbum DROP CONSTRAINT ArtistAlbum_Artist;

ALTER TABLE ArtistSong DROP CONSTRAINT ArtistSong_Artist;

ALTER TABLE ArtistSong DROP CONSTRAINT ArtistSong_Song;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Album;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Order;

ALTER TABLE "Order" DROP CONSTRAINT Order_Customer;

ALTER TABLE Song DROP CONSTRAINT Song_Album;

ALTER TABLE Stock DROP CONSTRAINT Stock_Album;

-- tables
DROP TABLE Album;

DROP TABLE AlbumGenre;

DROP TABLE Artist;

DROP TABLE ArtistAlbum;

DROP TABLE ArtistSong;

DROP TABLE Customer;

DROP TABLE Genre;

DROP TABLE "Order";

DROP TABLE OrderDetails;

DROP TABLE Song;

DROP TABLE Stock;



-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-12-27 00:41:30.894

-- tables
-- Table: Album
CREATE TABLE Album (
                       ID int IDENTITY(1,1) NOT NULL,
                       Title varchar(50)  NOT NULL,
                       ReleaseDate date  NOT NULL,
                       CONSTRAINT Album_pk PRIMARY KEY  (ID)
);

-- Table: AlbumGenre
CREATE TABLE AlbumGenre (
                            Genre_ID int  NOT NULL,
                            Album_ID int  NOT NULL,
                            CONSTRAINT AlbumGenre_pk PRIMARY KEY  (Genre_ID,Album_ID)
);

-- Table: Artist
CREATE TABLE Artist (
                        ID int IDENTITY(1,1) NOT NULL,
                        Name varchar(30)  NOT NULL,
                        CONSTRAINT Artist_pk PRIMARY KEY  (ID)
);

-- Table: ArtistAlbum
CREATE TABLE ArtistAlbum (
                             Artist_ID int  NOT NULL,
                             Album_ID int  NOT NULL,
                             CONSTRAINT ArtistAlbum_pk PRIMARY KEY  (Artist_ID,Album_ID)
);

-- Table: ArtistSong
CREATE TABLE ArtistSong (
                            Artist_ID int  NOT NULL,
                            Song_ID int  NOT NULL,
                            CONSTRAINT ArtistSong_pk PRIMARY KEY  (Artist_ID,Song_ID)
);

-- Table: Customer
CREATE TABLE Customer (
                          ID int IDENTITY(1,1) NOT NULL,
                          FirstName varchar(30)  NOT NULL,
                          LastName varchar(30)  NOT NULL,
                          Email varchar(30)  NOT NULL,
                          Phone varchar(11)  NOT NULL,
                          Address varchar(50)  NOT NULL,
                          CONSTRAINT Customer_pk PRIMARY KEY  (ID)
);

-- Table: Genre
CREATE TABLE Genre (
                       ID int IDENTITY(1,1) NOT NULL,
                       Genre varchar(30)  NOT NULL,
                       CONSTRAINT Genre_pk PRIMARY KEY  (ID)
);

-- Table: Order
CREATE TABLE "Order" (
                         ID int IDENTITY(1,1) NOT NULL,
                         Date datetime  NOT NULL,
                         Customer_ID int  NOT NULL,
                         CONSTRAINT Order_pk PRIMARY KEY  (ID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
                              Order_ID int  NOT NULL,
                              Album_ID int  NOT NULL,
                              Price money  NOT NULL,
                              Quantity int  NOT NULL,
                              CONSTRAINT OrderDetails_pk PRIMARY KEY  (Order_ID,Album_ID)
);

-- Table: Song
CREATE TABLE Song (
                      ID int IDENTITY(1,1) NOT NULL,
                      Title varchar(30)  NOT NULL,
                      Length int  NOT NULL,
                      Album_ID int  NOT NULL,
                      CONSTRAINT Song_pk PRIMARY KEY  (ID)
);

-- Table: Stock
CREATE TABLE Stock (
                       ID int IDENTITY(1,1) NOT NULL,
                       Album_ID int  NOT NULL,
                       AvailableQuantity int  NOT NULL,
                       Price money  NOT NULL,
                       Price_from datetime  NOT NULL,
                       Price_to datetime  NOT NULL,
                       CONSTRAINT Stock_pk PRIMARY KEY  (ID)
);

-- foreign keys
-- Reference: AlbumGenre_Album (table: AlbumGenre)
ALTER TABLE AlbumGenre ADD CONSTRAINT AlbumGenre_Album
    FOREIGN KEY (Album_ID)
        REFERENCES Album (ID);

-- Reference: AlbumGenre_Genre (table: AlbumGenre)
ALTER TABLE AlbumGenre ADD CONSTRAINT AlbumGenre_Genre
    FOREIGN KEY (Genre_ID)
        REFERENCES Genre (ID);

-- Reference: ArtistAlbum_Album (table: ArtistAlbum)
ALTER TABLE ArtistAlbum ADD CONSTRAINT ArtistAlbum_Album
    FOREIGN KEY (Album_ID)
        REFERENCES Album (ID);

-- Reference: ArtistAlbum_Artist (table: ArtistAlbum)
ALTER TABLE ArtistAlbum ADD CONSTRAINT ArtistAlbum_Artist
    FOREIGN KEY (Artist_ID)
        REFERENCES Artist (ID);

-- Reference: ArtistSong_Artist (table: ArtistSong)
ALTER TABLE ArtistSong ADD CONSTRAINT ArtistSong_Artist
    FOREIGN KEY (Artist_ID)
        REFERENCES Artist (ID);

-- Reference: ArtistSong_Song (table: ArtistSong)
ALTER TABLE ArtistSong ADD CONSTRAINT ArtistSong_Song
    FOREIGN KEY (Song_ID)
        REFERENCES Song (ID);

-- Reference: OrderDetails_Album (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Album
    FOREIGN KEY (Album_ID)
        REFERENCES Album (ID);

-- Reference: OrderDetails_Order (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Order
    FOREIGN KEY (Order_ID)
        REFERENCES "Order" (ID);

-- Reference: Order_Customer (table: Order)
ALTER TABLE "Order" ADD CONSTRAINT Order_Customer
    FOREIGN KEY (Customer_ID)
        REFERENCES Customer (ID);

-- Reference: Song_Album (table: Song)
ALTER TABLE Song ADD CONSTRAINT Song_Album
    FOREIGN KEY (Album_ID)
        REFERENCES Album (ID);

-- Reference: Stock_Album (table: Stock)
ALTER TABLE Stock ADD CONSTRAINT Stock_Album
    FOREIGN KEY (Album_ID)
        REFERENCES Album (ID);



-- Insert Artists
INSERT INTO Artist (Name) VALUES ('Massive Attack');
INSERT INTO Artist (Name) VALUES ('Elizabeth Fraser');
INSERT INTO Artist (Name) VALUES ('Aphex Twin');
INSERT INTO Artist (Name) VALUES ('Brian Eno');
INSERT INTO Artist (Name) VALUES ('David Byrne');

-- Insert Genres
INSERT INTO Genre (Genre) VALUES ('Trip Hop');
INSERT INTO Genre (Genre) VALUES ('Ambient');
INSERT INTO Genre (Genre) VALUES ('Electronic');
INSERT INTO Genre (Genre) VALUES ('Rock');

-- Insert Albums
INSERT INTO Album (Title, ReleaseDate) VALUES ('Selected Ambient Works 85-92', '1992-11-09');
INSERT INTO Album (Title, ReleaseDate) VALUES ('Mezzanine', '1998-04-20');
INSERT INTO Album (Title, ReleaseDate) VALUES ('My Life in the Bush of Ghosts', '1981-02-01');

-- Insert ArtistAlbum
INSERT INTO ArtistAlbum (Artist_ID, Album_ID) VALUES (1, 2);
INSERT INTO ArtistAlbum (Artist_ID, Album_ID) VALUES (3, 1);
INSERT INTO ArtistAlbum (Artist_ID, Album_ID) VALUES (4, 3);
INSERT INTO ArtistAlbum (Artist_ID, Album_ID) VALUES (5, 3);

-- Insert AlbumGenre
INSERT INTO AlbumGenre (Album_ID, Genre_ID) VALUES (1, 2);
INSERT INTO AlbumGenre (Album_ID, Genre_ID) VALUES (1, 3);
INSERT INTO AlbumGenre (Album_ID, Genre_ID) VALUES (2, 1);
INSERT INTO AlbumGenre (Album_ID, Genre_ID) VALUES (3, 4);
INSERT INTO AlbumGenre (Album_ID, Genre_ID) VALUES (3, 2);

-- Insert Songs
INSERT INTO Song (Title, Length, Album_ID) VALUES ('Xtal', 291, 1);
INSERT INTO Song (Title, Length, Album_ID) VALUES ('Tha', 541, 1);
INSERT INTO Song (Title, Length, Album_ID) VALUES ('Risingson', 300, 2);
INSERT INTO Song (Title, Length, Album_ID) VALUES ('Teardrop', 330, 2);
INSERT INTO Song (Title, Length, Album_ID) VALUES ('Regiment', 236, 3);
INSERT INTO Song (Title, Length, Album_ID) VALUES ('The Jezebel Spirit', 295, 3);

-- Insert ArtistSong
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (3, 1);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (3, 2);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (1, 3);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (1, 4);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (2, 4);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (4, 5);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (5, 5);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (4, 6);
INSERT INTO ArtistSong (Artist_ID, Song_ID) VALUES (5, 6);

-- Insert Customers
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address) VALUES ('Adam', 'Fasola', 'adam.fasola@gmail.com', '123456789', 'Koszykowa 12');
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address) VALUES ('Beata', 'Kowalska', 'beata.kowalska@gmail.com', '987654321', 'Grochowska 9');

-- Insert Orders
INSERT INTO [Order] ([Date], Customer_ID) VALUES ('2024-04-01 08:30:24', 1);
INSERT INTO [Order] ([Date], Customer_ID) VALUES ('2024-09-03 12:26:00', 2);

-- Insert Stock of Album 1
INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to) VALUES (1, 14, 131.01, '2024-01-01 09:31:01', '2024-05-01 09:31:01');
INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to) VALUES (1, 59, 110.00, '2024-05-01 09:31:02', '2025-12-24 09:31:01');

-- Insert Stock of Album 2
INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to) VALUES (2, 9, 129.00, '2024-01-01 09:31:01', '2024-08-03 14:36:00');
INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to) VALUES (2, 12, 119.00, '2024-08-03 14:36:01', '2025-12-30 14:36:00');

-- Insert of Stock of Album 3
INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to) VALUES (3, 12, 129.00, '2024-01-01 09:31:01', '2024-08-03 14:36:00');
INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to) VALUES (3, 2, 150.00, '2024-08-03 14:36:01', '2025-12-30 14:36:00');


-- Insert OrderDetails
INSERT INTO OrderDetails (Order_ID, Album_ID, Price, Quantity) VALUES (1, 1, 2 * 131.01, 2);
INSERT INTO OrderDetails (Order_ID, Album_ID, Price, Quantity) VALUES (1, 2, 129.00, 1);
INSERT INTO OrderDetails (Order_ID, Album_ID, Price, Quantity) VALUES (2, 2, 119.00, 1);




-- 1. Nazwy utworów z albumu 'My Life in the Bush of Ghosts' i ich dlugość
SELECT s.Title, CONCAT(s.Length, 's') AS Length
FROM Song s
JOIN Album a ON s.Album_Id = a.ID
WHERE a.Title = 'My Life in the Bush of Ghosts';

-- 2. Nazwy albumów i ich artyści wydanych przed 1990 rokiem
SELECT a.Title, ar.Name
FROM Album a
JOIN ArtistAlbum aa ON a.ID = aa.Album_ID
JOIN Artist ar ON ar.ID = aa.Artist_ID
WHERE a.ReleaseDate < CAST('1990-01-01' AS DATE);

-- 3. Nazwy albumów i ilość utworów
SELECT a.Title, COUNT(1) AS songCount
FROM Album a
JOIN Song s ON a.ID = s.Album_ID
GROUP BY a.Title;

-- 4. Nazwa albumu wraz z iloscią gatunków, dla albumów, które mają więcej niż jeden gatunek
SELECT a.Title, COUNT(ag.Genre_ID) AS GenreCount
FROM Album a
JOIN AlbumGenre ag ON a.ID = ag.Album_ID
JOIN Genre g ON ag.Genre_ID = g.ID GROUP BY a.Title
HAVING COUNT(1) > 1;

-- 5. Średnia cena za płytę, z zaokrągleniem do 2 miejsc po przecinku
SELECT ROUND(AVG(Price), 2) AS AveragePrice
FROM Stock;

-- 6. Nazwy wszystkich albumów zawierające literę a lub A
SELECT Title
FROM Album
WHERE Title LIKE '%a%' or Title LIKE '%A%';

-- 7. Szczegóły zamówień klientów
SELECT c.FirstName, c.LastName, a.Title, od.Quantity, od.Price
FROM Customer c
JOIN "Order" o ON c.ID = o.Customer_ID
JOIN OrderDetails od ON o.ID = od.Order_ID
JOIN Album a ON od.Album_ID = a.ID
ORDER BY o."Date" DESC;

-- 8. Obecne ceny wszystkich albumów
SELECT a.Title, s.AvailableQuantity, s.Price
FROM Album a
JOIN Stock s ON a.ID = s.Album_ID
WHERE GETDATE() BETWEEN s.Price_from AND s.Price_to;

-- 9. Historia cen dla wszystkich albumów
SELECT a.Title,
s1.Price,
s1.price_from AS Od,
s1.price_to AS Do
FROM Album a
JOIN Stock s1 ON a.ID = s1.Album_ID;

-- 10. Albumy które miały zmiany cen
SELECT a.Title, COUNT(1) as PriceChanges
FROM Album a
JOIN Stock s ON a.ID = s.Album_ID
GROUP BY a.Title
HAVING COUNT(1) > 1
ORDER BY PriceChanges DESC;
