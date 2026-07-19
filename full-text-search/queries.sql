-- basic match. @@ tests the vector against the query, uses the gin index
select id, title, author
from articles
where search_vector @@ plainto_tsquery('english', 'index scan')
order by published_at desc;

-- ranked results. ts_rank scores by term frequency and the A/B field weights
select title,
       round(ts_rank(search_vector, q)::numeric, 4) as rank
from articles, plainto_tsquery('english', 'postgresql index') as q
where search_vector @@ q
order by rank desc;

-- websearch_to_tsquery accepts what people actually type:
-- quoted phrases, OR, and - to exclude
select title
from articles
where search_vector @@ websearch_to_tsquery('english', '"query plans" or indexing -json');

-- highlight the matching words for display in the results list
select title,
       ts_headline('english', body, q,
                   'StartSel=<b>, StopSel=</b>, MaxWords=25, MinWords=10') as snippet
from articles, plainto_tsquery('english', 'index') as q
where search_vector @@ q;

-- as-you-type search: match a partial last word with the :* prefix operator
select title
from articles
where search_vector @@ to_tsquery('english', 'normal:*');

-- stemming is automatic: 'running' also finds 'run', 'transactions' finds 'transaction'
select title
from articles
where search_vector @@ plainto_tsquery('english', 'transactions');

-- typo fallback. full text search needs whole words, so trigram matching
-- catches misspellings that tsquery would miss entirely.
-- word_similarity scores the best matching word inside the title rather than
-- the title as a whole, which is what you want when the title is long
select title, round(word_similarity('postgersql', title)::numeric, 3) as score
from articles
where 'postgersql' <% title
order by score desc;
