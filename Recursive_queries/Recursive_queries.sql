Create database recursive_sql;

Use recursive_sql;

/*
A recursive query in SQL is a query that refers to itself.
It is typically implemented using a Recursive Common Table Expression (CTE) with the WITH clause.
Recursive queries are useful for working with hierarchical or sequential data, where each row is related to another row in a parent-child or step-by-step manner.

SYNTAX:

WITH RECURSIVE cte_name AS (
    -- Base case (anchor member)
    SELECT ...

    UNION ALL

    -- Recursive case (recursive member)
    SELECT ...
    FROM cte_name
    WHERE <termination_condition>
)
SELECT * FROM cte_name;


can be used for :

1. Hierarchical data traversal (e.g., employee → manager relationships, org charts).
2. Finding paths in graphs/networks (e.g., routes, family trees, dependencies).
3. Generating sequences (e.g., numbers, dates).
4. Bill of Materials (BOM) in manufacturing (parts explosion).
*/


-- 1. Display number from 1 to 10, without using any built in function.
With numbers as 
(
SELECT 1 as n
UNION All
SELECT n+1 
from numbers where n<10
)

Select * from numbers;

-- 2. Find the hierarchy of employees under a given manager "Asha".
-- table - emp_details: | id | name | manager_id | salary | designation |

With emp_hierarchy as 
(
SELECT id, name, manager_id, designation, 1 as level
FROM emp_details
WHERE name = 'Asha'
UNION ALL
SELECT E.id, E.name, E.manager_id, E.designation, H.level+1 as level
FROM emp_hierarchy as H
JOIN emp_details as E
ON H.id = E.id
)
Select H2.id as emp_id, H2.name as emp_name, E2.name as manager_name, H2.lvl as level
Join emp_details E2
ON E2.id = H2.manager_id

-- 3. Find the number of mangagers for a given employee "David"
-- table - emp_details: | id | name | manager_id | salary | designation |
-- Return : 

With emp_manager as 
(
Select emp_id, name, manager_id, designation, 1 as lvl
From emp_details
Where name = 'David'
Union All 
Select H.emp_id, E.name, E.manager_id, E.designation, E.lvl+1 as lvl
From emp_manager as H
Join emp_details as E
ON H.manager_id = E.id
)
SELECT H2.emp_id, H2.name as emp_name, h2.manager_id, E2.name as manager_name, H2.lvl as level
From emp_manager as H2
Join  emp_details as E2
on H2.mnager_id = E2.id;

-- 4. list all the dates between 2024-01-01 to 2024-01-10 without using a numbers table.

With dates as
(
Select cast('2024-01-01' as date) as dt
UNION ALL
Select dateadd(day,1,dt)
From dates
where dt< '2024-01-10'
)
Select dt from dates