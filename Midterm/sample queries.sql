SELECT * FROM Book;
SELECT * FROM Customer WHERE email = 'cbickerdickeq@apple.com';

SELECT Order.order_id, Customer.first_name, Customer.last_name, Book.title, OrderItem.quantity
FROM Order
JOIN Customer ON Order.customer_id = Customer.customer_id
JOIN OrderItem ON Order.order_id = OrderItem.order_id
JOIN Book ON OrderItem.book_id = Book.book_id;

SELECT genre, AVG(price) AS average_price
FROM Book
GROUP BY genre;

SELECT COUNT(order_id) AS total_orders
FROM Order;
