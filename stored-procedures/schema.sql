create table products (
    id serial primary key,
    name text not null,
    price numeric(10,2) not null,
    stock int not null default 0
);

create table orders (
    id serial primary key,
    customer text not null,
    created_at timestamptz default now()
);

create table order_items (
    id serial primary key,
    order_id int not null references orders(id) on delete cascade,
    product_id int not null references products(id),
    quantity int not null,
    price numeric(10,2) not null
);

create table stock_log (
    id serial primary key,
    product_id int not null references products(id),
    change int not null,
    reason text,
    logged_at timestamptz default now()
);
