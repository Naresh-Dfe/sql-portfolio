-- These scenarios need two psql sessions side by side. Run the steps in the
-- numbered order, switching windows where the comment says to.


-- scenario 1: lost update
--
-- both sessions read the same stock, decide there is enough, then write back a
-- number they worked out themselves. two keyboards get sold but stock only
-- drops by one.

-- session A, step 1
begin;
select stock from inventory where sku = 'KB-002';  -- reads 10

-- session B, step 2
begin;
select stock from inventory where sku = 'KB-002';  -- also reads 10, A has not committed

-- session A, step 3
update inventory set stock = 9 where sku = 'KB-002';
commit;

-- session B, step 4
update inventory set stock = 9 where sku = 'KB-002';  -- blocks until A commits, then overwrites
commit;

-- either session, step 5
select stock from inventory where sku = 'KB-002';  -- 9, but two were sold


-- scenario 2: overselling the last item
--
-- same shape, but now the check constraint on stock is the only thing standing
-- between you and negative inventory.

-- reset
update inventory set stock = 1 where sku = 'MN-003';

-- session A, step 1
begin;
select stock from inventory where sku = 'MN-003';  -- 1, looks available

-- session B, step 2
begin;
select stock from inventory where sku = 'MN-003';  -- 1, also looks available

-- session A, step 3
update inventory set stock = stock - 1 where sku = 'MN-003';
commit;

-- session B, step 4
update inventory set stock = stock - 1 where sku = 'MN-003';
-- fails: new row for relation "inventory" violates check constraint
-- "inventory_stock_check". without that constraint stock would now be -1
rollback;


-- scenario 3: deadlock
--
-- two transfers touching the same two accounts in opposite order. postgres
-- detects the cycle and kills one of them with SQLSTATE 40P01.

-- session A, step 1
begin;
update accounts set balance = balance - 100 where owner = 'Ravi';

-- session B, step 2
begin;
update accounts set balance = balance - 50 where owner = 'Anita';

-- session A, step 3 (waits on B)
update accounts set balance = balance + 100 where owner = 'Anita';

-- session B, step 4 (waits on A, completing the cycle)
update accounts set balance = balance + 50 where owner = 'Ravi';
-- one session now fails: deadlock detected

-- whichever survived
commit;
-- the other
rollback;
