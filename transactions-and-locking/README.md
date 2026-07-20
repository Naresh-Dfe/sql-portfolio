# transactions-and-locking

What goes wrong when two people hit the same row at the same time, and the patterns that prevent it.

Most of the bugs I've had to fix in production weren't wrong queries — they were correct queries running concurrently. Two customers buy the last monitor, both requests read `stock = 1`, both decide it's available, and the store sells something it doesn't have. The SQL is fine in isolation; the problem is the isolation.

## The scenarios

`race-conditions.sql` reproduces three failures. They need **two psql sessions side by side**, running the steps in the order the comments give:

- **Lost update** — both sessions read stock, both compute the new value themselves, and the second write silently overwrites the first. Two sold, stock down by one.
- **Overselling** — the same race against the last item in stock. Here the `check (stock >= 0)` constraint is the only thing preventing negative inventory, which is a good reason to write the constraint even when the application "already checks".
- **Deadlock** — two transfers touching the same two accounts in opposite order. PostgreSQL detects the cycle and kills one transaction with SQLSTATE `40P01`.

## The fixes

`safe-patterns.sql` has the counterparts:

**Let the database do the arithmetic.** `set stock = stock - 1 where stock >= 1` cannot lose an update, because the second writer re-reads the row after the first commits. Check the affected row count — `0` means out of stock, not a failed query. This handles the majority of cases and needs no explicit locking.

**`SELECT ... FOR UPDATE`** when you genuinely have to read, run some logic, then write. It holds the row for the rest of the transaction, so a competing session waits at the `select` rather than reading a value that's about to be stale.

**One transaction for related writes.** Debit and credit both apply or neither does.

**Consistent lock ordering** to avoid deadlocks. The cycle only forms because two transactions take the same rows in opposite order — sorting the keys before locking turns a deadlock into a queue.

**`SERIALIZABLE`** for rules that span rows, like "total reserved may not exceed stock". No single-row lock can enforce that, because the total is spread across many rows. Serializable makes PostgreSQL detect the conflict and abort one transaction with SQLSTATE `40001` — which means **the application must be prepared to retry**. That retry loop is part of the design, not an afterthought.

## Isolation levels, briefly

PostgreSQL defaults to **read committed**: every statement sees rows committed before that statement began. It prevents dirty reads but not the lost update above, because the two sessions read before either wrote.

**Repeatable read** gives a stable snapshot for the whole transaction and will abort a transaction that tries to update a row someone else changed. **Serializable** adds detection of the multi-row anomalies. Both trade a retry burden for correctness, so reach for them when a rule can't be expressed as a single-row update or constraint.

Worth knowing for job queues: `SELECT ... FOR UPDATE SKIP LOCKED` hands each worker a different row instead of making them queue, which is how you build a work queue on a plain table.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f safe-patterns.sql
```

`race-conditions.sql` is deliberately **not** a script you run start to finish — open two sessions and follow the numbered steps, or nothing interesting happens.
