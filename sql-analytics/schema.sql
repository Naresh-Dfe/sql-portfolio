create table sales (
    id serial primary key,
    sale_date date not null,
    product text not null,
    category text not null,
    region text not null,
    amount numeric(10,2) not null
);
