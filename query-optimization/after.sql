create index idx_orders_customer_status on orders(customer_id, status);
create index idx_customers_city on customers(city);

select o.*
from orders o
join customers c on c.id = o.customer_id
where c.city = 'Chennai'
and o.status = 'completed';
