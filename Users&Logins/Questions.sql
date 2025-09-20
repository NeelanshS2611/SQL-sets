Use test;
SELECT * from users;

Select * from logins;

-- Currnt date - 28-Jun-2024

-- 1. Find all the users that did not login in last 5 months.
-- return: username

-- using Group by and Having
Select u.user_name
from logins l inner join users u
ON l.USER_ID = u.USER_ID
group by u.user_name
Having  max(login_timestamp)< DATEADD(MONTH,-5,'2024-06-28')

-- Using subqueries
Select distinct user_id from logins 
where user_id not in 
(Select user_id 
from logins 
where LOGIN_TIMESTAMP > DATEADD(MONTH,-5,'2024-06-28'))

-- 2. For the business unit's quaterly analysis, Calculate the how many users and how many sessions were at each quarter
-- Order By Quarter from newest to oldest, return : first day of quarter, user_cnt, session_cnt

Select datetrunc(quarter,Min(login_timestamp)) as first_quarter_date,
		Count(distinct user_id) as user_cnt,
		Count(distinct SESSION_ID) as session_cnt
From logins
group by datepart(quarter, login_timestamp)
order by first_quarter_date

-- 3. Display users that have logged in in Jan 2024 and did not login in November 2023
Select distinct User_id 
from Logins 
Where login_timestamp between '2024-01-01' AND '2024-01-31'
AND User_id not in (
Select distinct User_id 
from Logins 
Where login_timestamp between '2023-11-01' AND '2023-11-30')

-- 4. Add to the question 2, Find the percentage chnage in sessions from last quarter.
--  Return: First day of the quarter, session_cnt, session_cnt_previous, session_percentage_chnage

With user_session_cnt as 
(
Select datetrunc(quarter,Min(login_timestamp)) as first_quarter_date,
		Count(distinct user_id) as user_cnt,
		Count(distinct SESSION_ID) as session_cnt
From logins
group by datepart(quarter, login_timestamp)
)
Select *,
		Lag(session_cnt,1) OVER(Order By first_quarter_date) as session_cnt_previous,
		round((session_cnt - (Lag(session_cnt,1) OVER(Order By first_quarter_date)))*100/Lag(session_cnt,1) OVER(Order By first_quarter_date),2) as session_percentage_chnage
From user_session_cnt

-- 5. Find the user that has hihest session score for each day
-- Return: date, username, score

with grouped_score as
(
SELeCT user_id, cast(login_timestamp as date) as login_date, sum(session_score) as score,
DENSE_RANK() Over(Partition by cast(login_timestamp as date) order by sum(session_score) desc) as rnk
From logins
group by user_id, cast(login_timestamp as date)
)
Select login_date, user_id, score
from grouped_score
where rnk = 1
order by login_date, score

-- 6. Find the best users (users that had session on every single day since their first login)
-- Return: User_id

SELECT USER_ID, min(cast(login_timestamp as date)) as first_login,
datediff(day, min(cast(login_timestamp as date)),  '2024-06-28')+1 as no_of_login_required,
Count(login_timestamp) as total_logins
from logins
Group by USER_ID
having Count(distinct login_timestamp) = datediff(day, min(cast(login_timestamp as date)),  '2024-06-28')+1

--7. On what dates there was no logins
-- return: Login_dates
-- starting date (2023-07-15) && end date (2024-06-28)

With cte as
(
Select cast(Min(login_timestamp) as date ) as start_date , '2024-06-28' as end_date
from logins
Union all
select dateadd(day,1,start_date) as start_date, end_date from cte
Where start_date<end_date
)
Select * from cte
where start_date not in (select distinct cast(Login_timestamp as date) from logins)
option(maxrecursion 500)