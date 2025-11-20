-- Module 2/Create a virtual table to summarize data -- 
-- Task 1 --
DROP VIEW IF EXISTS OrdersView;
CREATE VIEW OrdersView AS 
SELECT OrderID, SUM(Quantity) AS Quantity, SUM(TotalCost) AS Cost FROM order_menus WHERE Quantity > 2 GROUP BY OrderID;

-- Task 2 --
SELECT customers.CustomersID AS CustomerID, customers.CustomerName AS FullName, subq.OrderID, subq.TotalCost AS Cost, menus.MenuName, menu_types.Type AS MenuType
FROM customers 
JOIN bookings ON customers.CustomersID = bookings.CustomerID 
JOIN orders ON bookings.BookingID = orders.BookingID
JOIN (
SELECT OrderID, MenuID, SUM(TotalCost) AS TotalCost FROM order_menus GROUP BY OrderID, MenuID
) AS subq ON subq.OrderID = orders.OrderID
JOIN menus ON subq.MenuID = menus.MenuID
JOIN menu_types ON menus.TypeID = menu_types.TypeID
WHERE TotalCost > 150 ORDER BY TotalCost;

-- Task 3 --
SELECT MenuName FROM menus WHERE MenuID = ANY(SELECT MenuID FROM order_menus WHERE Quantity > 2)

-- Module 2/Create optimized queries to manage and analyze data --
-- Task 1 -- 
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
	SELECT MAX(Quantity) AS 'Max Quantity in Order' FROM order_menus;
END//

-- Task 2 -- 
PREPARE GetOrderDetail FROM '
SELECT order_menus.OrderID, SUM(order_menus.Quantity) AS Quantity, SUM(order_menus.TotalCost) AS Cost 
FROM order_menus 
JOIN orders ON order_menus.OrderID = orders.OrderID
JOIN bookings ON orders.BookingID = bookings.BookingID
JOIN customers ON bookings.CustomerID = customers.CustomersID WHERE bookings.CustomerID = ?
GROUP BY order_menus.OrderID, order_menus.MenuID
';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Task 3 -- 
DELIMITER //
DROP PROCEDURE CancelOrder;
CREATE PROCEDURE CancelOrder(IN ID INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT CONCAT('Error cancelling order ', ID) AS ErrorMsg;
    END;

	DELETE FROM orders WHERE OrderID = ID;
    
    IF ROW_COUNT() > 0 THEN
		SELECT CONCAT('Order ', ID, ' is cancelled') AS Confirmation;
	ELSE
		SELECT CONCAT('Order ', ID, ' not found') AS Confirmation;
	END IF;
END //

CALL CancelOrder(2);

