## Quiz question of aggragations ##

# 1 Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) AS total_poster_sales FROM orders;

# 2 Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) AS total_ FROM orders;

# 3 Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) AS total
FROM orders

# 4 Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT SUM(standard_amt_usd) AS standard_amt, 
	   SUM(gloss_amt_usd) AS gloss_amt
FROM orders;

### Correction ------------------
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;
### -----------------------------

# 5 Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

## MIN, MAX, & AVERAGE QUESTION
 # 1 When was the earliest order ever placed? You only need to return the date.
 SELECT MAX(occurred_at) AS date FROM orders;
  ## correction---------------
  SELECT MIN(occurred_at) FROM orders;

 # 2 Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at FROM orders
ORDER BY occurred_at
LIMIT 1;

 # 3 When did the most recent (latest) web_event occur?
 SELECT MAX(occurred_at) FROM web_events;

 # 4 Try to perform the result of the previous query without using an aggregation function.
 SELECT occurred_at FROM web_events
 ORDER BY occurred_at DESC
 LIMIT 1;

  # 5 Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

# 6 Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders? Note, this is more advanced than the topics we have covered thus far to build a general solution, but we can hard code a solution in the following way.


# ---> Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. This is the average of 2483.16 and 2482.55. This gives the median of 2482.855. This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. SQL didn't even calculate the median for us. The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them.
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

## GROUP BY statement question

# 1 Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name account, o.occurred_at order_date
FROM orders o JOIN accounts a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

# 2 Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name company, o.total_amt_usd total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id;
# Correction ------------------------------------
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;


# 3 Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT a.name account, w.channel channel, w.occurred_at date
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

# 4 Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT COUNT(w.channel) AS total_number, w.channel AS channel 
FROM web_events w
GROUP BY w.channel;

# 5 Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc account
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

# 6 What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name account, MIN(o.total_amt_usd) total_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

# 7 Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT COUNT(s.name) sale_rep, r.name region
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name;

# QUIZ PART II GROUP BY
# 1 For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name account, AVG(o.standard_qty) standard_avg, AVG(o.gloss_qty) gloss_avg, AVG(o.poster_qty) poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

# 2 For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name account, AVG(o.standard_amt_usd) standard_avg, AVG(o.standard_amt_usd) gloss_avg, AVG(o.standard_amt_usd) poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

# 3 Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT COUNT(w.channel) occurence, s.name sales_name, w.channel channel
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY occurence DESC;

# 4 Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT COUNT(w.channel) occurrences, r.name region,
w.channel channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY occurrences DESC;

# QUIZ FOR DISTINCT
# 1 Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT DISTINCT a.name 
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id;

# 2 Have any sales reps worked on more than one account?
SELECT DISTINCT s.name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id;

#----------------------------------------------------------------------------------|

# Quiz for HAVING statement
# 1 How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) number_count
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY number_count

# 2 How many accounts have more than 20 orders?
SELECT a.id, a.name, COUNT(*) order_number
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY order_number;

# 3 Which account has the most orders?
SELECT a.id, a.name, COUNT(*) order_number
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY order_number DESC
LIMIT 1;


# 4 Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, o.total_amt_usd usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name, o.total_amt_usd
HAVING o.total_amt_usd > 30000
ORDER BY usd_amt;

# Correction------------
SELECT a.id, a.name, SUM(o.total_amt_usd) usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name, o.total_amt_usd
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY usd_amt;
#--------------------------------------

# 5 Which accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, o.total_amt_usd usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name, o.total_amt_usd
HAVING o.total_amt_usd < 1000
ORDER BY usd_amt DESC;
# Correction------------
SELECT a.id, a.name, SUM(o.total_amt_usd) usd_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY usd_amt DESC;
#-----------------------------------------

# 6 Which account has spent the most with us?
SELECT a.id, a.name account, o.total_amt_usd usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name, o.total_amt_usd
ORDER BY usd_amt DESC
LIMIT 1;

# Correction-------------------------------------
SELECT a.id, a.name account, SUM(o.total_amt_usd) usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY usd_amt DESC
LIMIT 1;
#--------------------------------------------------

# 7 Which account has spent the least with us?
SELECT a.id, a.name account, o.total_amt_usd usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name, o.total_amt_usd
ORDER BY usd_amt
LIMIT 1;


# Correction-----------------------------
SELECT a.id, a.name account, SUM(o.total_amt_usd) usd_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY usd_amt DESC
LIMIT 1;
#--------------------------------------------------

# 8 Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name, w.channel, COUNT(*) number_count
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(*) > 6
ORDER BY number_count;
# Correction-----------------------------
SELECT a.name, w.channel, COUNT(*) number_count
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY number_count;
#-------------------------------------------------

# 9 Which account used facebook most as a channel?
SELECT a.name account, w.channel, COUNT(*) face_count
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
ORDER BY face_count DESC
LIMIT 1;

# 10 Which channel was most frequently used by most accounts?
SELECT w.channel, COUNT(*) channel_count
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY w.channel
ORDER BY channel_count DESC
LIMIT 1;

# Correction-------------------------------------
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

# Quiz DATE statement
# 1 Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
 SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

 # 2 Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd) total_amt
FROM orders
WHERE occurred_at BETWEEN '2013-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

# 3 Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) years,
SUM(total) orders_total
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

# 4 Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) years,
COUNT(*) orders_total
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

# 5 In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', o.occurred_at) yera,
SUM(o.gloss_amt_usd) gloss_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2
LIMIT 1;

# QUIZ for CASE statement
# 1 Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT account_id, total_amt_usd,
CASE WHEN total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS level
FROM orders;

# 2 Write a query to display the number of orders in each of three categories, 
#     based on the total number of items in each order. 
#     The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

# 3 We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
# The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. 
# The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. 
# You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.name account, 
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'first'
WHEN SUM(o.total_amt_usd) >= 200000 AND SUM(o.total_amt_usd) < 100000 THEN 'second'
ELSE 'lowest' END AS level,
SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2;

## Correction-------------------------------------
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

# 4 We would now like to perform a similar calculation to the first, 
# but we want to obtain the total amount spent by customers only in 2016 and 2017. 
# Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT a.name account, 
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'first'
WHEN SUM(o.total_amt_usd) >= 200000 AND SUM(o.total_amt_usd) < 100000 THEN 'second'
ELSE 'lowest' END AS level,
SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2016' AND '01-01-2018'
GROUP BY 1
ORDER BY 2;

# 5 We would like to identify top performing sales reps, 
# which are sales reps associated with more than 200 orders. 
# Create a table with the sales rep name, the total number of orders, 
# and a column with top or not depending on if they have more than 200 orders. 
# Place the top sales people first in your final table.

SELECT s.name sales_rep_name, 
CASE WHEN COUNT(*) > 200 THEN 'top'
ELSE 'not' END AS level,
COUNT(*) orders_number
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 3 DESC;

# 6 The previous didn't account for the middle, nor the dollar amount associated with the sales. 
# Management decides they want to see these characteristics represented as well. 
# We would like to identify top performing sales reps, 
# which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
# The middle group has any rep with more than 150 orders or 500000 in sales. 
# Create a table with the sales rep name, 
# the total number of orders, total sales across all orders, and a column with top, middle, or 
# low depending on this criteria. Place the top sales people based on dollar amount of sales first in your 
# final table. 
# You might see a few upset sales people by this criteria!

SELECT s.name sales_rep_name, 
CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
ELSE 'not' END AS level,
SUM(o.total_amt_usd) total_sale_amt,
COUNT(*) orders_number
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 3 DESC;
