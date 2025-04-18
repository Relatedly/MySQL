-- Task 1: Create Views
CREATE VIEW TopSellingBooks AS
SELECT b.book_id, b.title, b.author, SUM(oi.quantity) AS total_sold
FROM books b
JOIN order_items oi ON b.book_id = oi.book_id
GROUP BY b.book_id, b.title, b.author
ORDER BY total_sold DESC;


-- Task 2: Create a Stored Procedure
DELIMITER //

CREATE PROCEDURE AddNewBook(
    IN p_title VARCHAR(255),
    IN p_author VARCHAR(255),
    IN p_price DECIMAL(10,2),
    IN p_stock INT
)
BEGIN
    INSERT INTO books (title, author, price, stock)
    VALUES (p_title, p_author, p_price, p_stock);
END //

DELIMITER ;


-- Task 3: Outline the Use of Transactions
DELIMITER //

CREATE PROCEDURE ProcessOrder(
    IN p_order_id INT
)
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Example operations:
    -- 1. Deduct stock
    -- 2. Update order status
    -- 3. Record payment

    COMMIT;
END //

DELIMITER ;


-- Task 4: Create a Trigger
DELIMITER //

CREATE TRIGGER UpdateInventoryAfterPurchase
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE books
    SET stock = stock - NEW.quantity
    WHERE book_id = NEW.book_id;
END //

DELIMITER ;


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


-- Task 6: Create an Event
SET GLOBAL event_scheduler = ON;

CREATE EVENT UpdateMonthlySalesReport
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-05-01 00:00:00'
DO
BEGIN
    INSERT INTO monthly_sales_report (report_month, total_sales)
    SELECT DATE_FORMAT(NOW(), '%Y-%m-01'), SUM(total_amount)
    FROM orders
    WHERE MONTH(order_date) = MONTH(NOW()) AND YEAR(order_date) = YEAR(NOW());
END;



