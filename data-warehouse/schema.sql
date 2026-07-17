create table dim_date (
  date_key   int primary key,
  full_date  date not null,
  day        int not null,
  month      int not null,
  month_name text not null,
  quarter    int not null,
  year       int not null,
  weekday    text not null
);

create table dim_product (
  product_key serial primary key,
  sku         text unique not null,
  name        text not null,
  category    text not null,
  brand       text
);

create table dim_customer (
  customer_key serial primary key,
  email        text unique not null,
  name         text not null,
  city         text,
  state        text
);

create table fact_sales (
  sale_id      bigserial primary key,
  date_key     int not null references dim_date(date_key),
  product_key  int not null references dim_product(product_key),
  customer_key int not null references dim_customer(customer_key),
  quantity     int not null,
  unit_price   numeric(10, 2) not null,
  line_total   numeric(12, 2) not null
);

create index idx_fact_date on fact_sales(date_key);
create index idx_fact_product on fact_sales(product_key);
create index idx_fact_customer on fact_sales(customer_key);
