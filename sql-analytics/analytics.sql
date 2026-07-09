-- monthly revenue with a running total across the year
select date_trunc('month', sale_date)::date as month,
       sum(amount) as revenue,
       sum(sum(amount)) over (order by date_trunc('month', sale_date)) as running_total
from sales
group by month
order by month;

-- month-over-month growth
with monthly as (
    select date_trunc('month', sale_date)::date as month, sum(amount) as revenue
    from sales
    group by 1
)
select month,
       revenue,
       lag(revenue) over (order by month) as prev_month,
       round((revenue - lag(revenue) over (order by month))
             / lag(revenue) over (order by month) * 100, 1) as growth_pct
from monthly
order by month;

-- top 3 products by revenue within each category
with ranked as (
    select category,
           product,
           sum(amount) as revenue,
           row_number() over (partition by category order by sum(amount) desc) as rn
    from sales
    group by category, product
)
select category, product, revenue
from ranked
where rn <= 3
order by category, revenue desc;

-- each region's share of total revenue
select region,
       sum(amount) as revenue,
       round(sum(amount) / sum(sum(amount)) over () * 100, 1) as pct_of_total
from sales
group by region
order by revenue desc;

-- 3-month moving average of revenue
with monthly as (
    select date_trunc('month', sale_date)::date as month, sum(amount) as revenue
    from sales
    group by 1
)
select month,
       revenue,
       round(avg(revenue) over (order by month rows between 2 preceding and current row), 2) as moving_avg_3m
from monthly
order by month;
