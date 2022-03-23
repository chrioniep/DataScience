# Quiz for Advanced JOINS & Performance

"
#1 Say you're an analyst at Parch & Posey and you want to see:

- each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
- but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)
"

#A 
SELECT *
FROM accounts a
FULL JOIN sales_reps s
ON a.sales_rep_id = s.id

#B 
SELECT *
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL

"
#Derek's exercise about Inequality Joining
"
SELECT orders_id,
       orders_occurred_at AS order_date,
       events_*
FROM demo.orders orders
LEFT JOIN demo.web_events_full events
  ON events_account_id = orders.account_id
  AND events_occurred_at < orders.occurred_at
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM demo.orders)
ORDER BY orders.account_id, orders.occurred_at 

"
# 2
write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), and the sales representative's name (e.g. Samuel Racine). Then answer the subsequent multiple choice question.
"
SELECT a.name account_name,
	   a.primary_poc,
       s.name sales_name
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name

"
#Derek's exercise about Inequality Joining
"
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

"
# Self Join Quiz
# 1 - change the interval to 1 day to find those web events that occurred after, but not more than 1 day after, another web event
    - add a column for the channel variable in both instances of the table in your query
"
SELECT w1.id AS w1_id,
	   w1.channel AS channel_1,
       w2.channel AS channel_2,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
ORDER BY w1.account_id, w1.occurred_at

# correct -------------------------
SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at
"
# Quiz for UNION statement
"
#1 Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. 
Then inspect the results and answer the subsequent quiz.

SELECT * FROM accounts
UNION ALL
SELECT * FROM accounts

Performing Operations on a Combined Dataset
Perform the union in your first query 
(under the Appending Data via UNION header) in a common table expression and name it double_accounts. 
Then do a COUNT the number of times a name appears in the double_accounts table. 
If you do this correctly, 
your query results should have a count of 2 for each name.

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC
