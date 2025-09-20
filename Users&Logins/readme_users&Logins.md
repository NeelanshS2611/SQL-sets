SQL Practice Project

This project contains a curated set of SQL interview-style questions designed to strengthen understanding of:

Date functions

Window functions

Common Table Expressions (CTEs)

The exercises are based on two sample tables:

Table: User
| USER_ID | USER_NAME | USER_STATUS |

Table: Logins
| USER_ID | LOGIN_TIMESTAMP | SESSION_ID | SESSION_SCORE |

Assumptions:

Current date is set to 28-Jun-2024 for all queries.

Questions

1. Inactive Users (Find all users who have not logged in during the last 5 months).

Return: username

2. Quarterly User & Session Count (For business unit quarterly analysis, calculate the number of users and sessions per quarter).

Return: first_day_of_quarter, user_cnt, session_cnt

Order results by quarter from newest to oldest.

3. Login in Jan 2024 but not in Nov 2023 (Display users who logged in during January 2024 but did not log in during November 2023).

Return: user_id

4. Quarterly Session Growth (Extend Question 2 by calculating the percentage change in sessions compared to the previous quarter).

Return: first_day_of_quarter, session_cnt, session_cnt_previous, session_percentage_change

5. Top User by Session Score (Daily). Find the user with the highest session score for each day.

Return: date, username, score

6. Consistently Active Users (Identify users who had at least one session every single day since their first login).

Return: user_id

7. Dates with No Logins (Find all dates with no login activity between 2023-07-15 and 2024-06-28.)

Return: login_date


Goal:

By solving these questions, you will improve your ability to:

-- Write clean and efficient SQL

-- Apply advanced concepts like window functions and recursive queries

-- Perform business-oriented data analysis
