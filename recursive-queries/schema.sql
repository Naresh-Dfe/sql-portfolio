-- self-referencing tables: each row points at its parent in the same table

create table employees (
    id serial primary key,
    name text not null,
    title text not null,
    manager_id integer references employees(id)
);

create table categories (
    id serial primary key,
    name text not null,
    parent_id integer references categories(id)
);
