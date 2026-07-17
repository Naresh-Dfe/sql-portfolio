-- pull scalar fields out of the json (->> gives text, cast when you need a number)
select id, user_id,
       payload->>'plan'     as plan,
       payload->>'referrer' as referrer
from events
where event_type = 'signup';

-- reach into a nested object with ->
select id, payload->'device'->>'os' as os
from events
where event_type = 'signup';

-- containment: rows whose payload includes this shape. uses the gin index
select id, user_id, payload->>'amount' as amount
from events
where payload @> '{"coupon": "SPRING"}';

-- does a top-level key exist? (? operator)
select count(*) as with_coupon
from events
where event_type = 'purchase' and payload ? 'coupon';

-- revenue by signup referrer: join purchases back to each user's signup
select s.payload->>'referrer' as referrer,
       sum((p.payload->>'amount')::numeric) as revenue
from events s
join events p on p.user_id = s.user_id and p.event_type = 'purchase'
where s.event_type = 'signup'
group by s.payload->>'referrer'
order by revenue desc;

-- unnest a json array: one row per purchased item, then count
select item, count(*) as times_bought
from events, jsonb_array_elements_text(payload->'items') as item
where event_type = 'purchase'
group by item
order by times_bought desc;
