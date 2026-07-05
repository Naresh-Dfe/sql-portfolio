# Query optimization

A reporting query that pulls completed orders for customers in a given city. On a test set of around 300k orders it was slow — roughly 480ms per run.

## The problem

The original query (`before.sql`) used an `IN (subquery)` and had no useful indexes, so the planner fell back to sequential scans on both tables and a hash join over the full order set.

```
Seq Scan on orders  (cost=... rows=300000)
  Filter: (status = 'completed')
SubPlan
  Seq Scan on customers ...
```

## The fix

`after.sql` rewrites it as a plain join and adds two indexes — one on `orders(customer_id, status)` and one on `customers(city)`. The planner now uses an index scan to find the Chennai customers and an index lookup for their orders.

Runtime dropped from ~480ms to ~12ms.

## Takeaway

The rewrite from subquery to join helped readability, but the real win was the composite index on `(customer_id, status)` — it covered both the join and the filter in one scan.
