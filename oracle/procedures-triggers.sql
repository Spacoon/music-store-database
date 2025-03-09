DROP PROCEDURE batch_price_update;
DROP PROCEDURE delete_stock_data;
DROP PROCEDURE insert_if_low_inventory;

DROP TRIGGER NO_ALBUM_DELETE_WITH_ORDERS;
DROP TRIGGER VALIDATEALBUMRELEASEDATE;
DROP TRIGGER NO_NEGATIVE_STOCK_VALUES;

/*
Updates album prices between v_minPrice and v_maxPrice by v_increasePercent percent. Cuts the timestamp of the previous price to the current date
and inserts new records with the new price, starting with the current timestamp + one second and sets the current price to 6 months.
*/
create PROCEDURE batch_price_update (v_increasePercent INTEGER,
                                                v_minPrice NUMBER := 0,
                                                v_maxPrice NUMBER := 300)
AS
    CURSOR current_prices IS
        SELECT ID, Album_ID, AvailableQuantity, Price, Price_to
        FROM Stock
        WHERE CURRENT_TIMESTAMP BETWEEN Price_from AND Price_to
          AND Price BETWEEN v_minPrice AND v_maxPrice;

    v_new_price NUMBER;
    v_date_from TIMESTAMP;
    v_date_to TIMESTAMP;
BEGIN
    FOR item IN current_prices
        LOOP
            v_date_from := CURRENT_TIMESTAMP;

            UPDATE Stock SET Price_to = v_date_from WHERE ID = item.ID;

            v_new_price := ROUND(item.Price * (1 + v_increasePercent/100), 2);
            v_date_to := ADD_MONTHS(v_date_from, 6);

            INSERT INTO Stock (Album_ID, AvailableQuantity, Price, Price_from, Price_to)
            VALUES (item.Album_ID, item.AvailableQuantity, v_new_price, v_date_from + INTERVAL '1' SECOND, v_date_to);
        END LOOP;
    COMMIT;
END;

-- CALL batch_price_update(1, 150, 300);

/*
Removes the plate state history before the timestamp specified in the parameter. We also check if the parameter is not from the future.
*/
create PROCEDURE delete_stock_data(v_time TIMESTAMP)
AS
BEGIN
    IF v_time > CURRENT_TIMESTAMP THEN
        DBMS_OUTPUT.PUT_LINE('You can only delete past data');
    ELSE
        DELETE FROM STOCK WHERE STOCK.PRICE_TO < v_time;
        COMMIT;
    END IF;
END;

-- CALL delete_stock_data (TO_TIMESTAMP('2024-12-30 23:59:59', 'YYYY-MM-DD HH24:MI:SS'));

/*
Adds the number of albums to v_items if they are below or equal to the ceiling (v_low). We also check if this ceiling is not greater than 
the quantity we want to add then, we do not want to decrease the number of available albums.
*/
create PROCEDURE insert_if_low_inventory (v_low integer := 5, v_items integer := 6)
AS
    CURSOR lowCursor IS SELECT a.ID, a.Title, s.AvailableQuantity
                        FROM Album a
                                 JOIN Stock s ON a.ID = s.Album_ID
                        WHERE s.AvailableQuantity <= v_low AND SYSDATE BETWEEN s.Price_from AND s.Price_to;
BEGIN
    IF v_low > v_items THEN
        dbms_output.put_line('You can''t lower the amount of inventory using this procedure');
        RETURN;
    END IF;

    FOR item IN lowCursor
        LOOP
            dbms_output.put_line('There''s only ' || item.AvailableQuantity || ' items of ' || item.Title || ', updating quantity to ' || v_items);
            UPDATE STOCK SET AvailableQuantity = v_items WHERE album_id = item.id AND SYSDATE BETWEEN price_from AND price_to;
            COMMIT;
        END LOOP;

END;

-- CALL insert_if_low_inventory(6, 8);

/*
Prevents albums that have been ordered from being deleted.
*/
create trigger NO_ALBUM_DELETE_WITH_ORDERS
    before delete
    on ALBUM
    for each row
DECLARE
    v_ordersNumber integer;
BEGIN
    SELECT COUNT(1) INTO v_ordersNumber FROM OrderDetails WHERE Album_ID = :OLD.ID;

    IF v_ordersNumber > 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Cannot delete album with ID ' || :OLD.ID || ' as it''s already associated with orders.');
    END IF;
END;

-- DELETE FROM ALBUM WHERE ID = 1;

/*
Prevents inserting or modifying albums with a release date in the future or before 1900.
*/
create trigger VALIDATEALBUMRELEASEDATE
    before insert or update
    on ALBUM
    for each row
BEGIN
    IF :NEW.releasedate > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Release date set in a feature, can''t be added');
    END IF;

    IF :NEW.releasedate < TO_DATE('1900-01-01', 'YYYY-MM-DD') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Release date can''t be set before 1900 year');
    END IF;
END;

-- INSERT INTO ALBUM (Title, ReleaseDate) VALUES ('Album1898', TO_DATE('1889-01-01', 'YYYY-MM-DD'));

/*
Prevents inserting and updating the state of plates if their number will be negative after the operation.
*/
create trigger NO_NEGATIVE_STOCK_VALUES
    before insert or update of AVAILABLEQUANTITY
    on STOCK
    for each row
BEGIN
    IF :NEW.AVAILABLEQUANTITY < 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Stock value cannot be negative');
    END IF;
END;

-- UPDATE STOCK SET AVAILABLEQUANTITY = -1 WHERE ALBUM_ID = 1 AND SYSDATE BETWEEN PRICE_FROM AND PRICE_TO;
COMMIT;
