insert into customers (name, email, city) values
('Ravi Kumar', 'ravi@example.com', 'Chennai'),
('Anita Shah', 'anita@example.com', 'Mumbai'),
('John Miller', 'john@example.com', 'London');

insert into products (name, price, stock) values
('Wireless Mouse', 799.00, 40),
('Mechanical Keyboard', 2499.00, 25),
('USB-C Cable', 299.00, 100),
('Laptop Stand', 1899.00, 12);

insert into orders (customer_id, status) values
(1, 'completed'),
(1, 'pending'),
(2, 'completed'),
(3, 'completed');

insert into order_items (order_id, product_id, quantity, price) values
(1, 1, 1, 799.00),
(1, 3, 2, 299.00),
(2, 2, 1, 2499.00),
(3, 4, 1, 1899.00),
(4, 1, 2, 799.00),
(4, 3, 3, 299.00);
