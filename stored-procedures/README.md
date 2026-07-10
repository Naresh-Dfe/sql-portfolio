# stored-procedures

Business logic that lives inside the database — functions, a trigger, and a view.

Not every rule belongs in the application layer. Things like "don't sell more stock than you have" are safer enforced in the database, where they can't be skipped by a second app or a manual query. This project shows that with PL/pgSQL.

## What's here

**`place_order(customer, product_id, qty)`** — the main function. It checks the product exists and has enough stock, creates the order and its line item, and decrements stock. Because a function runs as a single transaction, either all of that happens or none of it does — you can't end up with an order but no stock deducted. If stock is short it raises an error and rolls back.

**`log_stock_change()` + `trg_log_stock`** — a trigger that writes to `stock_log` every time a product's stock changes, so there's an audit trail of what moved and when.

**`order_summary`** — a view that rolls each order up to item count and total, so reports can query one clean table instead of repeating the join.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f functions.sql
psql yourdb -f triggers.sql
psql yourdb -f views.sql
psql yourdb -f example.sql
```

`example.sql` places two orders through the function and then shows the order summary and the stock log. The commented-out line shows what happens when you try to over-order — it fails cleanly and leaves the data untouched.
