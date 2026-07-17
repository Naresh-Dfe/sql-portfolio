-- monthly revenue
select d.year, d.month, d.month_name, sum(f.line_total) as revenue
from fact_sales f
join dim_date d on d.date_key = f.date_key
group by d.year, d.month, d.month_name
order by d.year, d.month;

-- revenue by category
select p.category, sum(f.line_total) as revenue, sum(f.quantity) as units
from fact_sales f
join dim_product p on p.product_key = f.product_key
group by p.category
order by revenue desc;

-- revenue by state
select c.state, sum(f.line_total) as revenue
from fact_sales f
join dim_customer c on c.customer_key = f.customer_key
group by c.state
order by revenue desc;

-- top products by revenue
select p.name, sum(f.line_total) as revenue
from fact_sales f
join dim_product p on p.product_key = f.product_key
group by p.name
order by revenue desc
limit 5;

-- quarterly revenue by category, with subtotals and a grand total
select d.quarter, p.category, sum(f.line_total) as revenue
from fact_sales f
join dim_date d on d.date_key = f.date_key
join dim_product p on p.product_key = f.product_key
group by rollup (d.quarter, p.category)
order by d.quarter nulls last, p.category nulls last;
