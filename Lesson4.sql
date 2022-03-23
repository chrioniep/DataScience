# Quiz about Subquery concept

# 1 First, we needed to group by the day and channel. Then ordering by the number of events (the third column) gave us a quick way to answer the first question.
SELECT DATE_TRUNC('day',occurred_at) AS day,
   channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;

# 2 Here you can see that to get the entire table in question 1 back, we included an * in our SELECT statement. You will need to be sure to alias your table
SELECT DATE_TRUNC('day', occurred_at),
channel,
COUNT(*) event_count
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC

# 3 Finally, here we are able to get a table that shows the average number of events a day for each channel.
SELECT channel,
	AVG(event_count) AS avg_event_count
FROM 
(SELECT DATE_TRUNC('day', occurred_at),
channel,
COUNT(*) event_count
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC
 ) sub
 GROUP BY 1
 ORDER BY 2 DESC;

  #Quiz serie 2 for Subquery
  # 1 Use DATE_TRUNC to pull month level information about the first order ever placed in the orders table.
  SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders

# 2 Use the result of the previous query to find only the orders that took
# place in the same month and year as the first order, and then pull the
# average for each type of paper qty in this month

SELECT AVG(standard_qty) avg_standard,
	AVG(gloss_qty) avg_gloss,
    AVG(poster_qty) avg_poster,
    SUM(total_amt_usd) total_amt
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders)

# Quiz Subquery series 2
# 1 Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT s.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE o.total_amt_usd = (SELECT MAX(total_amt_usd)
FROM orders)

# 2 For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT MAX(total_amt)
FROM 
(SELECT r.name, SUM(o.total_amt_usd) total_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1) sub

# 3 How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

SELECT COUNT(*)
FROM(SELECT a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total
      FROM (SELECT a.name account_name, SUM(o.standard_qty) qty_std,          SUM(o.total) total
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1) sub)
     ) inner_tab;

# 4 For the customer that spent the most (in total over their lifetime as a customer) 
# total_amt_usd, how many web_events did they have for each channel?
SELECT COUNT(*)
FROM
(SELECT w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE w.account_id = (SELECT customer_id FROM (SELECT a.id customer_id, a.name customer, SUM(o.total_amt_usd) total_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1)sub)
 ) inner_tab;

# 5 What is the lifetime average amount spent in terms of total_amt_usd 
# for the top 10 total spending accounts?
SELECT AVG(total_amt)
FROM (SELECT a.id, a.name account_name, SUM(o.total_amt_usd) total_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10)sub;

# 6 What is the lifetime average amount spent in terms of total_amt_usd, 
# including only the companies that spent more per order, on average, 
# than the average of all orders.

SELECT AVG(avg_amt)
FROM 
(SELECT a.name companie, AVG(o.total_amt_usd) avg_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(total_amt_usd)
FROM orders))sub

# Quizz for WITH statement 
# Test Quiz : You need to find the average number of events for each channel per day.
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) as events
FROM web_events
GROUP BY 1, 2) sub
GROUP BY channel
ORDER BY 2 DESC

# 1 Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC), 
t2 AS (
   SELECT region_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

# 2
WITH t1 AS (
   SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY r.name), 
t2 AS (
   SELECT MAX(total_amt)
   FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);


# 3
WITH t1 AS (
  SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1), 
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;
# 4
WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1,
# 5
WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;
# 6
WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;


