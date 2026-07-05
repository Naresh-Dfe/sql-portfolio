-- best selling products by units
select p.name, sum(oi.quantity) as units_sold
from order_items oi
join products p on p.id = oi.product_id
group by p.name
order by units_sold desc;

-- revenue per customer (completed orders only)
select c.name, sum(oi.quantity * oi.price) as total_spent
from customers c
join orders o on o.customer_id = c.id
join order_items oi on oi.order_id = o.id
where o.status = 'completed'
group by c.name
order by total_spent desc;

-- products running low on stock
select name, stock
from products
where stock < 20
order by stock;

-- monthly sales total
select date_trunc('month', o.created_at) as month,
       sum(oi.quantity * oi.price) as revenue
from orders o
join order_items oi on oi.order_id = o.id
where o.status = 'completed'
group by month
order by month;
