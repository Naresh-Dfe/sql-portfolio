-- Fixes for the races in race-conditions.sql. These all run in a single
-- session, but each one stays correct when several run at once.


-- 1. let the database do the arithmetic
--
-- never read a number, change it in application code, then write it back. an
-- update that reads and writes in one statement cannot lose a concurrent
-- change, because the second writer re-reads the row after the first commits.
update inventory
set stock = stock - 1
where sku = 'KB-002'
  and stock >= 1;
-- check the affected row count: 0 means it was out of stock, not that the
-- query failed. this is the guard that stops overselling.


-- 2. lock the row when you must read, decide, then write
--
-- for update holds the row until the transaction ends, so a second session
-- waits at the select instead of reading a value that is about to go stale.
begin;

select stock
from inventory
where sku = 'MN-003'
for update;

-- application logic can run here safely
insert into reservations (sku, customer, quantity)
values ('MN-003', 'Ravi', 1);

update inventory set stock = stock - 1 where sku = 'MN-003';

commit;


-- 3. move money atomically
--
-- both updates live in one transaction, so the pair either both apply or
-- neither does. the check constraint rejects an overdraft and rolls the whole
-- transfer back.
begin;

update accounts set balance = balance - 500 where owner = 'Ravi';
update accounts set balance = balance + 500 where owner = 'Anita';

commit;


-- 4. always lock in the same order
--
-- the deadlock in scenario 3 happens because two transactions grab the same
-- rows in opposite order. sorting the keys first means every transaction
-- queues behind the other rather than blocking it.
begin;

select id
from accounts
where owner in ('Ravi', 'Anita')
order by id
for update;

update accounts set balance = balance - 100 where owner = 'Ravi';
update accounts set balance = balance + 100 where owner = 'Anita';

commit;


-- 5. serializable when the rule spans rows
--
-- a constraint like "this sku may not be reserved more than its stock" cannot
-- be enforced by locking one row, because the total is spread across many.
-- serializable makes postgres detect the conflict and fail one transaction
-- with SQLSTATE 40001, which the application retries.
begin isolation level serializable;

select coalesce(sum(quantity), 0)
from reservations
where sku = 'CB-005';

insert into reservations (sku, customer, quantity)
values ('CB-005', 'Anita', 2);

commit;
