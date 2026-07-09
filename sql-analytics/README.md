# sql-analytics

Reporting queries built with window functions — the kind of thing that goes on a sales dashboard.

Most reporting questions aren't just "what's the total" — they're "how does this month compare to last", "what's the running total so far", "which products lead each category". Those need window functions rather than plain `GROUP BY`, and that's what this project covers.

It runs on a single denormalized `sales` table (date, product, category, region, amount), which is close to how a reporting/analytics table usually looks.

## Queries in `analytics.sql`

- **Running total** — monthly revenue plus a cumulative total across the year, using `SUM() OVER (ORDER BY month)`.
- **Month-over-month growth** — this month vs last month as a percentage, using `LAG()`.
- **Top 3 per category** — ranks products within each category with `ROW_NUMBER() OVER (PARTITION BY category ...)` and keeps the top three.
- **Region share** — each region's revenue as a percentage of the whole, dividing by a window total.
- **3-month moving average** — smooths the monthly revenue line with a rolling average over the current and two previous months.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f analytics.sql
```

The seed has about six months of data so the growth and moving-average queries have something to work with.
