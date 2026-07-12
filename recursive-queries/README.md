# recursive-queries

Walking hierarchical data with recursive CTEs — org charts and nested category trees.

Some data is naturally a tree: an employee reports to a manager who reports to another manager, a category sits inside a parent category. You store that with a row that points at its own parent (`manager_id`, `parent_id`), but then a plain query can only see one level at a time. Recursive CTEs let you walk the whole tree in a single statement.

There are two tables, both self-referencing:

- `employees` — an org chart, each person pointing at their manager.
- `categories` — a product category tree a few levels deep.

## Queries in `queries.sql`

- **Org chart** — walks down from the CEO, tracking depth and indenting each name so the output reads like an actual chart.
- **Subtree** — everyone under a given manager, direct and indirect reports.
- **Management chain** — walks *up* from one employee to the CEO by following `manager_id`.
- **Report counts** — how many people roll up under each manager across all levels.
- **Category breadcrumbs** — builds the full `Electronics > Computers > Laptops` path for every category.
- **Leaf categories** — the categories with no children, with their full path.

## Running it

```
psql yourdb -f schema.sql
psql yourdb -f seed.sql
psql yourdb -f queries.sql
```
