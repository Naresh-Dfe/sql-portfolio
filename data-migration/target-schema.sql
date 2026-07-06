create table customers (
    id serial primary key,
    name text not null,
    email text unique not null,
    city text
);

create table products (
    id serial primary key,
    name text not null,
    price numeric(10,2) not null
);

create table orders (
    id serial primary key,
    ref text unique,
    customer_id int not null references customers(id),
    status text not null default 'pending',
    order_date date
);

create table order_items (
    id serial primary key,
    order_id int not null references orders(id) on delete cascade,
    product_id int not null references products(id),
    quantity int not null,
    price numeric(10,2) not null
);
