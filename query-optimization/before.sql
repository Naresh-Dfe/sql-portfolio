select *
from orders o
where o.customer_id in (
    select id from customers where city = 'Chennai'
)
and o.status = 'completed';
