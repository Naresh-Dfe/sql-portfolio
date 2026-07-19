insert into articles (title, author, body, published_at) values
('Indexing strategies in PostgreSQL',
 'Ravi Kumar',
 'A btree index handles equality and range lookups. A GIN index suits containment and full text search. Picking the wrong one leaves the planner scanning every row.',
 '2024-02-11'),

('Understanding query plans',
 'Anita Shah',
 'EXPLAIN ANALYZE shows what the planner actually did. Look for sequential scans on large tables and nested loops running far more times than you expected.',
 '2024-03-04'),

('Normalizing a messy legacy table',
 'Ravi Kumar',
 'Splitting one wide table into customers, orders and items removes duplication. Foreign keys then stop the bad data from coming back.',
 '2024-03-22'),

('When to denormalize for reporting',
 'John Miller',
 'Reporting reads a lot and writes rarely. A star schema trades some duplication for far simpler and faster aggregate queries.',
 '2024-04-15'),

('Window functions for running totals',
 'Meera Nair',
 'A running total is a sum over an ordered window. Unlike GROUP BY, window functions keep every row while adding the aggregate alongside it.',
 '2024-05-02'),

('Full text search without a search engine',
 'Anita Shah',
 'For most small applications PostgreSQL text search is enough. You avoid running and syncing a separate Elasticsearch cluster.',
 '2024-06-18'),

('Transactions and isolation levels',
 'John Miller',
 'Read committed is the PostgreSQL default. Serializable prevents anomalies but you have to be ready to retry a failed transaction.',
 '2024-07-09'),

('Storing JSON in a relational database',
 'Meera Nair',
 'A jsonb column keeps the flexible part of your data queryable. Fields you filter on constantly still belong in real columns.',
 '2024-08-01');
