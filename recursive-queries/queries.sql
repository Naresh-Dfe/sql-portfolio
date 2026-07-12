-- full org chart from the top, with depth and an indented name
with recursive org as (
    select id, name, title, manager_id, 0 as depth
    from employees
    where manager_id is null
    union all
    select e.id, e.name, e.title, e.manager_id, org.depth + 1
    from employees e
    join org on e.manager_id = org.id
)
select depth,
       repeat('    ', depth) || name as chart,
       title
from org
order by depth, name;

-- everyone under a given manager (the whole subtree), here Ravi in engineering
with recursive reports as (
    select id, name, title, manager_id
    from employees
    where id = 2
    union all
    select e.id, e.name, e.title, e.manager_id
    from employees e
    join reports on e.manager_id = reports.id
)
select id, name, title
from reports
where id <> 2
order by id;

-- management chain from one employee up to the CEO
with recursive chain as (
    select id, name, title, manager_id, 1 as level
    from employees
    where id = 7
    union all
    select e.id, e.name, e.title, e.manager_id, chain.level + 1
    from employees e
    join chain on e.id = chain.manager_id
)
select level, name, title
from chain
order by level;

-- how many people report up through each manager, directly or indirectly
with recursive reports as (
    select id as manager_id, id as report_id
    from employees
    union all
    select r.manager_id, e.id
    from employees e
    join reports r on e.manager_id = r.report_id
)
select m.name as manager,
       count(*) - 1 as total_reports
from reports r
join employees m on m.id = r.manager_id
group by m.id, m.name
having count(*) - 1 > 0
order by total_reports desc, manager;

-- full path (breadcrumb) for every category, e.g. Electronics > Computers > Laptops
with recursive tree as (
    select id, name, parent_id, name as path, 0 as depth
    from categories
    where parent_id is null
    union all
    select c.id, c.name, c.parent_id, tree.path || ' > ' || c.name, tree.depth + 1
    from categories c
    join tree on c.parent_id = tree.id
)
select depth, path
from tree
order by path;

-- leaf categories only (the ones with no children), with their full path
with recursive tree as (
    select id, name, parent_id, name as path
    from categories
    where parent_id is null
    union all
    select c.id, c.name, c.parent_id, tree.path || ' > ' || c.name
    from categories c
    join tree on c.parent_id = tree.id
)
select path
from tree t
where not exists (select 1 from categories c where c.parent_id = t.id)
order by path;
