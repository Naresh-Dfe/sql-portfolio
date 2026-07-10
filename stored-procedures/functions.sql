-- places an order and adjusts stock in one transaction
-- returns the new order id, or raises if the product is missing or short on stock
create or replace function place_order(p_customer text, p_product_id int, p_qty int)
returns int as $$
declare
    v_order_id int;
    v_price numeric(10,2);
    v_stock int;
begin
    select price, stock into v_price, v_stock
    from products
    where id = p_product_id;

    if not found then
        raise exception 'Product % does not exist', p_product_id;
    end if;

    if v_stock < p_qty then
        raise exception 'Not enough stock for product % (have %, need %)', p_product_id, v_stock, p_qty;
    end if;

    insert into orders (customer) values (p_customer) returning id into v_order_id;

    insert into order_items (order_id, product_id, quantity, price)
    values (v_order_id, p_product_id, p_qty, v_price);

    update products set stock = stock - p_qty where id = p_product_id;

    return v_order_id;
end;
$$ language plpgsql;

-- writes a row to stock_log whenever a product's stock changes
create or replace function log_stock_change()
returns trigger as $$
begin
    if new.stock <> old.stock then
        insert into stock_log (product_id, change, reason)
        values (new.id, new.stock - old.stock, 'stock updated');
    end if;
    return new;
end;
$$ language plpgsql;
