create trigger trg_log_stock
after update on products
for each row
execute function log_stock_change();
