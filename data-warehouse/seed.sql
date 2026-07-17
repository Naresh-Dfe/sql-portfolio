insert into dim_date (date_key, full_date, day, month, month_name, quarter, year, weekday)
select to_char(d, 'YYYYMMDD')::int,
       d,
       extract(day from d)::int,
       extract(month from d)::int,
       trim(to_char(d, 'Month')),
       extract(quarter from d)::int,
       extract(year from d)::int,
       trim(to_char(d, 'Day'))
from generate_series('2024-01-01'::date, '2024-12-31'::date, interval '1 day') as d;

insert into dim_product (sku, name, category, brand) values
('WM-001', 'Wireless Mouse',              'Accessories', 'Logi'),
('KB-002', 'Mechanical Keyboard',         'Accessories', 'Keychron'),
('MN-003', '27in Monitor',                'Electronics', 'Dell'),
('HP-004', 'Noise Cancelling Headphones', 'Electronics', 'Sony'),
('CB-005', 'USB-C Cable',                 'Accessories', 'Anker');

insert into dim_customer (email, name, city, state) values
('ravi@example.com',  'Ravi Kumar',  'Chennai',   'Tamil Nadu'),
('anita@example.com', 'Anita Shah',  'Mumbai',    'Maharashtra'),
('john@example.com',  'John Miller', 'Bengaluru', 'Karnataka'),
('meera@example.com', 'Meera Nair',  'Kochi',     'Kerala');

insert into fact_sales (date_key, product_key, customer_key, quantity, unit_price, line_total)
select f.date_key, p.product_key, c.customer_key, f.quantity, f.unit_price,
       f.quantity * f.unit_price
from (values
  (20240112, 'WM-001', 'ravi@example.com',  2,   799.00),
  (20240118, 'MN-003', 'anita@example.com', 1, 14999.00),
  (20240205, 'KB-002', 'john@example.com',  1,  2499.00),
  (20240221, 'CB-005', 'ravi@example.com',  3,   299.00),
  (20240309, 'HP-004', 'meera@example.com', 1,  8999.00),
  (20240317, 'MN-003', 'john@example.com',  2, 14999.00),
  (20240402, 'WM-001', 'anita@example.com', 1,   799.00),
  (20240419, 'KB-002', 'meera@example.com', 1,  2499.00),
  (20240508, 'HP-004', 'ravi@example.com',  1,  8999.00),
  (20240523, 'CB-005', 'john@example.com',  4,   299.00),
  (20240611, 'MN-003', 'meera@example.com', 1, 14999.00),
  (20240625, 'WM-001', 'john@example.com',  2,   799.00),
  (20240708, 'KB-002', 'anita@example.com', 1,  2499.00),
  (20240722, 'HP-004', 'john@example.com',  1,  8999.00),
  (20240815, 'MN-003', 'ravi@example.com',  1, 14999.00)
) as f(date_key, sku, email, quantity, unit_price)
join dim_product p on p.sku = f.sku
join dim_customer c on c.email = f.email;
