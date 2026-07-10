insert into products (name, price, stock) values
('Wireless Mouse', 799.00, 5),
('USB-C Cable', 299.00, 20);

select place_order('Ravi Kumar', 1, 2);
select place_order('Anita Shah', 2, 3);

-- trying to over-order raises an error and changes nothing:
-- select place_order('Test', 1, 100);

select * from order_summary;
select * from stock_log order by id;
