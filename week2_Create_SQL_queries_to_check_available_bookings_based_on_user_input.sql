USE LittleLemonDM;

####################### Task 1#########################

INSERT INTO Bookings(BOOKINGID, DATE, TABLE_NUMBER, CUSTOMERID)
VALUES
(1,'2022-10-10',5,1),
(2,'2022-11-12',3,3)
(3,'2022-10-11',2,2),
(4,'2022-10-13',2,1)

####################### Task 2#########################

CREATE PROCEDURE CheckBooking(IN d DATE, IN t INT)
SELECT CONCAT('Table ',t,
    IF((SELECT bookingID FROM Bookings WHERE date = d AND table_number = T) IS NOT NULL,
        ' is already booked',
        ' is not booked'))
    AS 'Booking status';

CALL CheckBooking('2022-10-10',3);

####################### Task 3#########################
DELIMITER //

CREATE PROCEDURE AddValidBooking(IN d DATE, IN t INT)
BEGIN
DECLARE id INT DEFAULT 1;
DECLARE avail BOOL DEFAULT 1;
SET id = (SELECT COUNT(bookingID) FROM Bookings) + 1;
SET avail = (SELECT bookingID FROM Bookings  WHERE date = d AND table_number = t) IS NULL;

START TRANSACTION;
INSERT INTO Bookings(bookingID, date, table_number) VALUES (id, d, t);
IF avail THEN
    BEGIN
        SELECT CONCAT('Table ', t, ' is booked successfully') AS 'Booking status';
        COMMIT;
    END;
ELSE
    BEGIN
    SELECT CONCAT('Table ', t, ' is already booked - booking cancelled') AS 'Booking status';
    ROLLBACK;
    END;
END IF;

END//

DELIMITER ;

CALL AddValidBooking('2022-10-10',5)
