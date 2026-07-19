-- trigram matching, used for the misspelling fallback
create extension if not exists pg_trgm;

create table articles (
  id           serial primary key,
  title        text not null,
  author       text not null,
  body         text not null,
  published_at date not null,
  -- title matches count for more than body matches, so each field is weighted
  search_vector tsvector generated always as (
    setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(body, '')), 'B')
  ) stored
);

create index idx_articles_search on articles using gin (search_vector);
create index idx_articles_title_trgm on articles using gin (title gin_trgm_ops);
