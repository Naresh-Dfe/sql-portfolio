-- one row per customer, matched on a cleaned-up email
insert into customers (name, email, city)
select distinct on (lower(customer_email))
       trim(customer_name), lower(customer_email), city
from legacy_orders
order by lower(customer_email);

insert into products (name, price)
select distinct product_name, unit_price
from legacy_orders;

-- one order per reference, keeping the old ref for traceability
insert into orders (ref, customer_id, status, order_date)
select distinct l.order_ref, c.id, 'completed', l.order_date::date
from legacy_orders l
join customers c on c.email = lower(l.customer_email);

insert into order_items (order_id, product_id, quantity, price)
select o.id, p.id, l.quantity, l.unit_price
from legacy_orders l
join orders o on o.ref = l.order_ref
join products p on p.name = l.product_name;
