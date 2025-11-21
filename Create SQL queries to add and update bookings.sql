-- Module 2/Create SQL queries to add and update bookings --
-- Task 1 --
DELIMITER //
CREATE PROCEDURE AddBooking(IN book_id INT, IN cust_id INT, IN the_date DATE, IN the_table INT)
BEGIN
	INSERT INTO bookings (BookingID, BookingDate, TableNo, CustomerID) VALUES (book_id, the_date, the_table, cust_id);
    SELECT 'New booking added' AS Confirmation;
END //
DELIMITER ;

CALL AddBooking(9, 3, '2022-12-30', 4);

-- Task 2 --


-- Task 3 --

