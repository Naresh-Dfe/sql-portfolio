-- org chart: Asha at the top, managers under her, individual contributors below them
insert into employees (id, name, title, manager_id) values
(1,  'Asha Menon',     'CEO',                 null),
(2,  'Ravi Kumar',     'VP Engineering',      1),
(3,  'Priya Nair',     'VP Sales',            1),
(4,  'Karthik Rao',    'Engineering Manager', 2),
(5,  'Sneha Iyer',     'Engineering Manager', 2),
(6,  'Arjun Das',      'Senior Engineer',     4),
(7,  'Meera Pillai',   'Engineer',            4),
(8,  'Vikram Shetty',  'Engineer',            5),
(9,  'Divya Reddy',    'Engineer',            5),
(10, 'Rahul Verma',    'Sales Manager',       3),
(11, 'Anjali Gupta',   'Account Executive',   10),
(12, 'Suresh Babu',    'Account Executive',   10);

select setval('employees_id_seq', (select max(id) from employees));

-- product categories nested a few levels deep
insert into categories (id, name, parent_id) values
(1,  'Electronics',      null),
(2,  'Computers',        1),
(3,  'Laptops',          2),
(4,  'Gaming Laptops',   3),
(5,  'Ultrabooks',       3),
(6,  'Accessories',      2),
(7,  'Keyboards',        6),
(8,  'Mice',             6),
(9,  'Audio',            1),
(10, 'Headphones',       9),
(11, 'Speakers',         9);

select setval('categories_id_seq', (select max(id) from categories));
