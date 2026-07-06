# data-migration

Moving a messy legacy export into a clean, normalized schema.

A lot of clients start with everything in one wide table — a spreadsheet dump where the customer name, email, and city repeat on every order line. This project takes that kind of flat table and splits it into proper `customers`, `products`, `orders`, and `order_items` tables.

## The source

`source.sql` is the old flat table. It has the usual problems:

- The same customer appears with different email casing (`RAVI@example.com` vs `ravi@example.com`)
- Extra whitespace in some names
- Order references repeated across line items
- Dates stored as text

## The migration

`migrate.sql` handles it in four inserts:

1. **Customers** — deduplicated on a lowercased email, names trimmed. `distinct on` keeps one row per real person instead of one per order line.
2. **Products** — pulled out as distinct name/price pairs.
3. **Orders** — one row per order reference. The old `order_ref` is kept in a `ref` column so records can be traced back to the source if anything looks off later.
4. **Order items** — line items linked back to the right order and product.

## Running it

```
psql yourdb -f source.sql
psql yourdb -f target-schema.sql
psql yourdb -f migrate.sql
```

## Note

Keeping the original reference during a migration is worth the extra column — if a client spots a wrong total after go-live, you can trace any row straight back to the legacy data instead of guessing.
