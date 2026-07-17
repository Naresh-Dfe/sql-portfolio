# data-warehouse

A star schema for sales reporting — the shape you build when the goal is analytics, not transactions.

A transactional (OLTP) schema is normalized to keep writes clean and consistent. Reporting is the opposite problem: you want fast, simple aggregations over lots of rows. So you denormalize into a **star schema** — one central fact table surrounded by descriptive dimension tables.

## The model

- **`fact_sales`** — the facts, one row per product per sale. Holds the measures (quantity, unit price, line total) plus foreign keys into the dimensions. This is the table that grows.
- **`dim_date`** — one row per calendar day, with month, quarter, year, and weekday pre-computed so reports never have to derive them.
- **`dim_product`** — product attributes (name, category, brand).
- **`dim_customer`** — customer attributes (name, city, state).

The **grain** is one row per product per sale. Decide the grain first — everything else follows from it.

## Why the dimensions are denormalized

In a transactional schema you'd split category and brand into their own tables. Here they sit flat on `dim_product`, because a query slicing sales by category shouldn't pay for extra joins, and dimension tables are small and change rarely. That trade — a little redundancy for much simpler, faster reads — is the whole point of the model.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f queries.sql
```

`seed.sql` builds a full 2024 date dimension with `generate_series` and loads sample sales. `queries.sql` covers monthly revenue, revenue by category and by state, top products, and a quarterly rollup with subtotals and a grand total (`group by rollup`).
