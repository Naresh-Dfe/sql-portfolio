create table accounts (
  id      serial primary key,
  owner   text not null,
  balance numeric(12, 2) not null check (balance >= 0)
);

create table inventory (
  sku   text primary key,
  name  text not null,
  stock int not null check (stock >= 0)
);

create table reservations (
  id         serial primary key,
  sku        text not null references inventory(sku),
  customer   text not null,
  quantity   int not null check (quantity > 0),
  created_at timestamptz not null default now()
);

create index idx_reservations_sku on reservations(sku);
