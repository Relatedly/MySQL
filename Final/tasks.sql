-- Task 1: Create Views
CREATE VIEW TopSellingBooks AS
SELECT b.book_id, b.title, SUM(oi.quantity) AS total_sold
FROM book b
JOIN orderitem oi ON b.book_id = oi.book_id
GROUP BY b.book_id, b.title
ORDER BY total_sold DESC;

-- Explanation: This view aggregates sales data to identify top-selling books. 
-- It simplifies reporting and can be used to generate bestseller lists or inform inventory decisions.

-- Task 2: Create a Stored Procedure
DELIMITER //

CREATE PROCEDURE AddNewBook(
    IN p_title VARCHAR(255),
    IN p_author VARCHAR(255),
    IN p_price DECIMAL(10,2),
    IN p_stock INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM books WHERE title = p_title AND author = p_author) THEN
        INSERT INTO books (title, author, price, stock)
        VALUES (p_title, p_author, p_price, p_stock);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book already exists';
    END IF;
END //

DELIMITER ;

-- Explanation: This stored procedure encapsulates the logic for adding a new book, ensuring consistent data entry 
-- and reducing the risk of errors. It can be called from application code or other stored routines.

-- Task 3: Outline the Use of Transactions
DELIMITER //

CREATE PROCEDURE ProcessOrder(
    IN p_order_id INT
)
BEGIN
    DECLARE book_id INT;
    DECLARE quantity INT;

    DECLARE cur CURSOR FOR 
        SELECT oi.book_id, oi.quantity 
        FROM order_items oi
        WHERE oi.order_id = p_order_id;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    OPEN cur;

    FETCH cur INTO book_id, quantity;

    WHILE (SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = p_order_id AND oi.book_id = book_id) > 0 DO
        UPDATE books
        SET stock = stock - quantity
        WHERE book_id = book_id;

        FETCH cur INTO book_id, quantity;
    END WHILE;

    CLOSE cur;

    UPDATE orders 
    SET status = 'Processed'
    WHERE order_id = p_order_id;

    COMMIT;
END //

DELIMITER ;

-- Explanation: In this procedure, a transaction ensures that all steps of processing an order are completed successfully. 
-- The transaction is rolled back if any step fails, preventing partial updates.​

-- Task 4: Create a Trigger
DELIMITER //

CREATE TRIGGER UpdateInventoryAfterPurchase
AFTER INSERT ON orderitem
FOR EACH ROW
BEGIN
    UPDATE book
    SET stock = stock - NEW.quantity
    WHERE book_id = NEW.book_id;
END //

DELIMITER ;

-- Explanation: This trigger automatically adjusts the stock level of a book when a new order item is inserted, 
-- ensuring real-time inventory accuracy without manual intervention.

-- Task 5: User-Defined Function
DELIMITER //

CREATE FUNCTION CalculateInventoryCost(p_book_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_cost DECIMAL(10,2);
    SELECT stock * price INTO total_cost
    FROM books
    WHERE book_id = p_book_id;
    RETURN total_cost;
END //

DELIMITER ;

-- Explanation: This function computes the total value of the inventory for a given book, 
-- aiding in financial analysis and inventory management decisions.

-- Task 6: Create an Event
SET GLOBAL event_scheduler = ON;

CREATE EVENT UpdateMonthlySalesReport
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-05-01 00:00:00'
DO
    INSERT INTO monthly_sales_report (report_month, total_sales)
    SELECT DATE_FORMAT(NOW(), '%Y-%m-01'), SUM(total_amount)
    FROM orders
    WHERE MONTH(order_date) = MONTH(NOW()) 
    AND YEAR(order_date) = YEAR(NOW());

-- Explanation: This event automates the generation of monthly sales reports, 
-- ensuring timely and consistent reporting without manual effort.
