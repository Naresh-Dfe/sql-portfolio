# jsonb

Storing and querying semi-structured data in PostgreSQL with `jsonb`.

Not everything fits neatly into columns. Analytics events, webhook payloads, and API responses all have a shifting set of fields — you don't want a migration every time a new one shows up. Postgres lets you keep that flexibility in a `jsonb` column while still querying and indexing it like real data.

Here it's an `events` table: the fixed things (user, event type, timestamp) are proper columns, and the variable per-event detail lives in a `payload` jsonb column.

## The operators worth knowing

- `payload->>'plan'` — get a field as **text**. `->` keeps it as json (chain it for nested access: `payload->'device'->>'os'`).
- `payload @> '{"coupon": "SPRING"}'` — **containment**: does the json contain this shape? This is the one to reach for, because a GIN index makes it fast.
- `payload ? 'coupon'` — does this top-level **key exist**?
- `jsonb_array_elements_text(payload->'items')` — **unnest** a json array into rows so you can group and count.

## Indexing

Two strategies, both in `schema.sql`:

- A **GIN index** on the whole column powers containment (`@>`) and key-existence checks without scanning every row.
- A **btree index on an extracted expression** — `((payload->>'amount')::numeric)` — is what you add when you filter or sort on one specific field a lot. GIN doesn't help with ranges; this does.

The trade-off to be honest about: jsonb buys flexibility, but a value you query constantly is usually better promoted to its own column. Use jsonb for the genuinely variable part, not as an excuse to skip schema design.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f queries.sql
```
