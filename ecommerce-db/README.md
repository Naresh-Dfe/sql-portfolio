# ecommerce-db

A relational schema for a small online store, with sample data and reporting queries.

## Tables

- `customers` — who's buying
- `products` — catalogue with price and stock
- `orders` — one row per order, linked to a customer
- `order_items` — line items for each order

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f queries.sql
```

`queries.sql` has the reporting queries — top products, revenue per customer, low stock, and monthly sales.
