DROP PROCEDURE add_song;
DROP PROCEDURE add_artist;
DROP PROCEDURE add_artist_to_song;

DROP TRIGGER print_artist_changes;
DROP TRIGGER update_stock_after_order;
DROP TRIGGER customer_email_validation;

-- procedures

/*
Adds a song to the Song table, looks for the album id by name, if not found it will return a message and the operation will not be performed.
We do not add the song's author in this procedure, because we can have more than one author for one song, so
the add_artist_to_song procedure is for this. We assume that songs and albums have unique names.
 */
create procedure add_song @title varchar(30), @length int, @album_name varchar(50) as
begin
    DECLARE @album_id int;
    SELECT @album_id = id FROM album WHERE Title = @album_name;
    IF @album_id IS NULL
        BEGIN
            PRINT 'Album ' + @album_name + ' does not exist';
            RETURN;
        END
    INSERT INTO song (Title, Length, Album_id)
    VALUES (@title, @length, @album_id);
end;
    ;

--         exec add_song 'Song1', 100, 'Selected Ambient Works 85-92';

/*
Adds an author to the Artist table. If an author with the given name already exists, it will not be added. We assume that authors have unique names.
 */
    create procedure add_artist @name varchar(30) as
    begin
        if exists(SELECT (1) FROM artist WHERE Name = @name)
            begin
                PRINT @name + ' already exists';
                RETURN;
            end
        INSERT INTO artist(Name) VALUES (@name);
    end;
        ;
--         exec add_artist 'New artist';

/*
Adds an author to a track. The author will not be added if it does not exist in the Artist table or if it is already assigned to this track. 
We assume that authors have unique names. We can add more than one author by calling the procedure multiple times for different artists for the same track.
 */
        create procedure add_artist_to_song @artist_name varchar(30), @song_name varchar(30) as
        begin
            DECLARE @artist_id int, @song_id int;
            SELECT @artist_id = id FROM artist WHERE Name = @artist_name;
            SELECT @song_id = id FROM song WHERE Title = @song_name;
            IF @artist_id IS NULL
                BEGIN
                    PRINT 'Artist ' + @artist_name + ' does not exist';
                    RETURN;
                END
            IF @song_id IS NULL
                BEGIN
                    PRINT 'Song ' + @song_name + ' does not exist';
                    RETURN;
                END
            IF EXISTS(SELECT (1) FROM ArtistSong WHERE Artist_id = @artist_id AND Song_id = @song_id)
                BEGIN
                    PRINT 'Artist ' + @artist_name + ' already associated with ' + @song_name;
                    RETURN;
                END

            INSERT INTO ArtistSong(Artist_id, Song_id)
            VALUES (@artist_id, @song_id);
        end;
            ;
--     exec add_artist_to_song 'Aphex Twin', 'Song1';


-- triggers


/*
Displays information about changes in the Artist table. Informs about the addition and removal of an artist. 
Assuming we are using the add_artist procedure, which allows adding one artist with one command.
 */
CREATE TRIGGER print_artist_changes
    ON Artist
    FOR INSERT, UPDATE, DELETE
    AS
BEGIN
    IF EXISTS (SELECT (1) FROM inserted)
        BEGIN
            DECLARE @name_inserted varchar(30);
            SET @name_inserted = (SELECT Name FROM inserted);
            PRINT 'Inserted artist: ' + @name_inserted;
        END

    IF EXISTS (SELECT (1) FROM deleted)
        BEGIN
            DECLARE @name_deleted varchar(30);
            SET @name_deleted = (SELECT Name FROM deleted);
            PRINT 'Deleted artist: ' + @name_deleted;
        END
END;
    ;

/*
Updates the stock of albums after placing an order (using the cursor, we can order multiple albums at once and check if there is the right number of them in stock).
This does not work on quantity updates, we do not assume that we are modifying orders.
 */

create trigger update_stock_after_order
    on OrderDetails
    for insert
    as
BEGIN
    DECLARE kursor CURSOR FOR
        SELECT Album_ID, Quantity FROM inserted;
    DECLARE @Album_ID int, @Quantity int, @insertQuantity int;
    OPEN kursor;
    FETCH NEXT FROM kursor INTO @Album_ID, @Quantity;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @insertQuantity = AvailableQuantity - @Quantity FROM Stock WHERE Album_ID = @Album_ID AND GETDATE() BETWEEN Price_from AND Price_to;
            IF @insertQuantity < 0
                BEGIN
                    DECLARE @title varchar(50);
                    SELECT @title = Title FROM Album WHERE ID = @Album_ID;
                    PRINT 'Album ' + @title + 'can''t be added to order as there are' +
                            ' not as many available quantity in the stock. Reverting the transaction';
                    ROLLBACK;
                    CLOSE kursor;
                    DEALLOCATE kursor;

                    RETURN;
                END

            UPDATE Stock
            SET AvailableQuantity = @insertQuantity
            WHERE Album_ID = @Album_ID AND GETDATE() BETWEEN Price_from AND Price_to;

            FETCH NEXT FROM kursor INTO @Album_ID, @Quantity;
        END

    CLOSE kursor;
    DEALLOCATE kursor;

end;
    ;

-- INSERT INTO OrderDetails (Order_ID, Album_ID, Price, Quantity) VALUES
--    (2, 1, (SELECT Price FROM Stock WHERE Stock.Album_ID = 1 AND GETDATE() BETWEEN Price_from AND Price_to) * 2, 2),
--    (2, 3, (SELECT Price FROM Stock WHERE Stock.Album_ID = 3 AND GETDATE() BETWEEN Price_from AND Price_to) * 3, 3);

/*
Makes sure that customer emails contain the "@" sign. Checks the condition when updating and inserting new customers
*/
CREATE TRIGGER customer_email_validation
    ON Customer
    FOR INSERT, UPDATE
    AS
    BEGIN
        DECLARE @mail varchar(30);

        DECLARE kursor CURSOR FOR
            SELECT email FROM inserted;
        OPEN kursor;
        FETCH NEXT FROM kursor INTO @mail;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                IF @mail NOT LIKE '%@%'
                    BEGIN
                        PRINT 'Email address is not valid, it needs to have @ symbol';
                        ROLLBACK;
                        CLOSE kursor;
                        DEALLOCATE kursor;
                        RETURN;
                    END
                FETCH NEXT FROM kursor INTO @mail;
            END
        CLOSE kursor;
        DEALLOCATE kursor;
    END;
    ;

-- UPDATE Customer SET Email = 'jascdcd' WHERE ID = 1;