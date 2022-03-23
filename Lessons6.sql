# Lessons 6 Window Function
# example 1
SELECT standard_qty, 
        DATE_TRUNC('month', occurred_at) AS month,
        SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total
FROM demo.orders

# Window Function Quizz
# 1 create another running total. This time, create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.
SELECT standard_amt_usd,
	SUM(standard_amt_usd) OVER (ORDER BY occurred_at) running_total
FROM orders;
# 2 Now, modify your query from the previous quiz to include partitions. 
# Still create a running total of standard_amt_usd (in the orders table) over order time, 
# but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. 
# Your final table should have three columns: One with the amount being added for each row, 
# one for the truncated date, and a final column with the running total within each year.

SELECT standard_amt_usd,
	   DATE_TRUNC('year', occurred_at) AS year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) running_total_by_year
FROM orders;

# example 2 
# row_number example
SELECT id, account_id, occurred_at
        ROW_NUMBER() OVER (ORDER BY id) AS row_num
FROM orders

SELECT id, account_id, occurred_at
        ROW_NUMBER() OVER (ORDER BY occurred_at) AS row_num
FROM orders

SELECT id, account_id, occurred_at
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY occurred_at) AS row_num
FROM orders
# rank
SELECT id, account_id, occurred_at
        RANK() OVER (PARTITION BY account_id ORDER BY occurred_at) AS row_num
FROM orders

SELECT id, account_id, occurred_at
        DATE_TRUNC('month', occurred_at) AS month
        RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num
FROM orders

# dense_rank
SELECT id, account_id, occurred_at
        DATE_TRUNC('month', occurred_at) AS month
        DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num
FROM orders

# 3 Select the id, account_id, and total variable from the orders table, 
# then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) 
# for each account using a partition. Your final table should have these four columns.

SELECT id, account_id, total,
	RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;

# example 3
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS sum_standard_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS count_standard_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS avg_standard_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS min_standard_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS max_standard_qty
FROM orders;

# 4 Percentiles with Partitions

SELECT id,
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (ORDER BY standard_qty) AS quartile,
       NTILE(5) OVER (ORDER BY standard_qty) AS quintile,
       NTILE(100) OVER (ORDER BY standard_qty) AS percentile
FROM orders
ORDER BY standard_qty DESC

Quizz percentiles
#1 Use the NTILE functionality to divide the accounts into 4 levels in 
terms of the amount of standard_qty for their orders. 
Your resulting table should have the account_id, the occurred_at time for each order, 
the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.

Percentiles with Partitions
1.
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC
2.
SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
  FROM orders 
 ORDER BY account_id DESC
3.
SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
  FROM orders 
 ORDER BY account_id DESC