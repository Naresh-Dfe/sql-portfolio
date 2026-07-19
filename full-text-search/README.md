# full-text-search

Search built into PostgreSQL — no Elasticsearch, no extra service to run and keep in sync.

`LIKE '%term%'` falls apart quickly: it can't rank results, can't match word variations, and can't use a normal index. PostgreSQL's text search fixes all three by converting text into a `tsvector` — a sorted list of normalized words with their positions — and matching it against a `tsquery`.

## The model

`articles` keeps its normal columns, plus a **generated `search_vector`** that PostgreSQL maintains itself on every insert and update:

```sql
setweight(to_tsvector('english', title), 'A') ||
setweight(to_tsvector('english', body),  'B')
```

Two things are happening here:

- **Stemming.** The `english` config reduces words to their root, so a search for `transactions` matches an article about a `transaction`, and `running` matches `run`. Stop words like *the* and *of* are dropped.
- **Weighting.** `setweight` labels title words `A` and body words `B`. `ts_rank` scores `A` matches higher, so an article *titled* "Indexing strategies" outranks one that merely mentions indexing in passing.

A **GIN index** on the vector is what makes `@@` fast — without it, every search reads the whole table.

## Writing the query

There are three ways to build a `tsquery`, and the right one depends on where the input comes from:

- `plainto_tsquery('english', 'index scan')` — treats the input as plain words, ANDs them together. Safe for arbitrary user input.
- `websearch_to_tsquery(...)` — accepts the syntax people already know from search engines: `"quoted phrases"`, `or`, and `-excluded`. This is usually the one you want for a search box.
- `to_tsquery(...)` — full control with `&`, `|`, and the `:*` prefix operator for as-you-type search. It errors on malformed input, so never hand it raw user text.

`ts_headline` returns the matching snippet with the terms wrapped in tags, which is what you show under each result.

## Handling typos

Full-text search matches whole (stemmed) words, so a misspelling like `postgersql` returns nothing at all. The fix is a second index using `pg_trgm`, which breaks text into three-character slices and scores how many they share.

Use `word_similarity` and the `<%` operator rather than plain `similarity` / `%`. `similarity` compares the two strings *as a whole*, so a short search term scored against a long title always falls below the threshold; `word_similarity` scores the best matching word inside the title instead. The usual pattern is to run the text search first and fall back to trigram matching only when it returns no rows.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f queries.sql
```

`pg_trgm` ships with PostgreSQL but needs `CREATE EXTENSION`, which `schema.sql` does. That requires a superuser or a role with the right privilege.
