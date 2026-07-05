create table tasks (
    id serial primary key,
    title text not null,
    done boolean not null default false,
    created_at timestamptz default now()
);
