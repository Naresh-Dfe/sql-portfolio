create table events (
  id         bigserial primary key,
  user_id    int not null,
  event_type text not null,
  created_at timestamptz not null default now(),
  payload    jsonb not null
);

-- gin index so containment (@>) and key lookups on payload stay fast
create index idx_events_payload on events using gin (payload);

-- btree index on a value pulled out of the json, for range/sort queries
create index idx_events_amount on events (((payload->>'amount')::numeric));
