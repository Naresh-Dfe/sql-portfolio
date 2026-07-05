create table customers (
    id serial primary key,
    name text not null,
    email text unique not null,
    city text,
    created_at timestamptz default now()
);

create table products (
    id serial primary key,
    name text not null,
    price numeric(10,2) not null,
    stock int not null default 0
);

create table orders (
    id serial primary key,
    customer_id int not null references customers(id),
    status text not null default 'pending',
    created_at timestamptz default now()
);

create table order_items (
    id serial primary key,
    order_id int not null references orders(id) on delete cascade,
    product_id int not null references products(id),
    quantity int not null,
    price numeric(10,2) not null
);

create index idx_orders_customer on orders(customer_id);
create index idx_order_items_order on order_items(order_id);
