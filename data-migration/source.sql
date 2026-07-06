create table legacy_orders (
    order_ref text,
    customer_name text,
    customer_email text,
    city text,
    product_name text,
    unit_price numeric(10,2),
    quantity int,
    order_date text
);

insert into legacy_orders values
('ORD-1001', 'Ravi Kumar',  'RAVI@example.com',  'Chennai', 'Wireless Mouse',      799.00, 1, '2024-01-05'),
('ORD-1001', 'Ravi Kumar',  'ravi@example.com',  'Chennai', 'USB-C Cable',         299.00, 2, '2024-01-05'),
('ORD-1002', 'Anita Shah ', 'anita@example.com', 'Mumbai',  'Mechanical Keyboard', 2499.00, 1, '2024-01-08'),
('ORD-1003', 'John Miller', 'john@example.com',  'London',  'Laptop Stand',        1899.00, 1, '2024-01-11'),
('ORD-1003', 'John Miller', 'JOHN@example.com',  'London',  'Wireless Mouse',      799.00, 2, '2024-01-11'),
('ORD-1004', 'Anita Shah',  'anita@example.com', 'Mumbai',  'USB-C Cable',         299.00, 3, '2024-01-15');
