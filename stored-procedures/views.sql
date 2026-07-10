create view order_summary as
select o.id as order_id,
       o.customer,
       sum(oi.quantity) as items,
       sum(oi.quantity * oi.price) as total
from orders o
join order_items oi on oi.order_id = o.id
group by o.id, o.customer;
