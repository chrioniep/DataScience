# Quiz about Data Cleaning

# 1 In the accounts table, there is a column holding the website for each company. 
# The last three digits specify what type of web address they are using. 
# A list of extensions (and pricing) is provided here. 
# Pull these extensions and provide how many of each website type exist in the accounts table.

SELECT RIGHT(website, 3) website_type, 
COUNT(*) count_number
FROM accounts
GROUP BY 1

# 2 There is much debate about how much the name (or even the first letter of a company name) matters. 
# Use the accounts table to pull the first letter of each company name to see the distribution of company names 
# that begin with each letter (or number).

SELECT LEFT(name, 1), COUNT(*)
FROM accounts
GROUP BY 1;

# 3 Use the accounts table and a CASE statement to create two groups: one group of company names 
#  that start with a number and a second group of those company names that start with a letter.
#  What proportion of company names start with a letter?

# Solution------------------------------
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;
------------------------------------------
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
THEN 1 ELSE 0 END AS num,
CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
THEN 0 ELSE 1 END AS letter
FROM accounts) t1;

# 4 Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT SUM(vowel), SUM(other) other
FROM (
  SELECT name, CASE WHEN LEFT(LOWER(name), 1) IN ('a', 'e', 'i', 'o','u')
  THEN 1 ELSE 0 END AS vowel,
  CASE WHEN LEFT(LOWER(name), 1) NOT IN ('a', 'e', 'i', 'o','u')
  THEN 1 ELSE 0 END AS other
  FROM accounts
) tab;

# Quizzes POSITION & STRPOS
# 1 Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')) AS left,
       RIGHT(primary_poc, STRPOS(primary_poc, ' ')) AS right
FROM accounts;

# 2 Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT LEFT(name, STRPOS(name, ' ')) AS left,
       RIGHT(name, STRPOS(name, ' ')) AS right
FROM sales_reps;
# Quizzez CONCAT

# Solution----------------
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;
# 1 Each company in the accounts table wants 
to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name 
primary_poc @ company name .com.

SELECT 
	CONCAT(LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ),'.',RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' '))
    ,'@',name,'.com') email_address
from accounts; 

# 2 You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, 
but otherwise your solution should be just as in question 1. Some helpful documentation is here.

SELECT 
	CONCAT(LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ),'.',RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' '))
    ,'@',REPLACE(name, ' ', ''),'.com') email_address
from accounts;

# 3 We would also like to create an initial password, which they will change after their first log in. 
The first password will be the first letter of the primary_poc first name (lowercase), 
then the last letter of their first name (lowercase), the first letter of their last name (lowercase), 
the last letter of their last name (lowercase), the number of letters in their first name, 
the number of letters in their last name, and then the name of the company they are working with, 
all capitalized with no spaces.

SELECT
CONCAT(
  LEFT(LOWER(LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 )),1),'',
 RIGHT(LOWER(RIGHT(name, LENGTH(name) - STRPOS(name, ' '))),1),'',LENGTH(LEFT(name, STRPOS(name, ' ') -1 )),'',LENGTH(RIGHT(name, LENGTH(name) - STRPOS(name, ' '))),'',UPPER(REPLACE(name, ' ', ''))
) init_password
from accounts;

# Quiz About cas statement

# 1 Write a query to look at the top 10 rows to understand the columns and
the raw data in the dataset called sf_crime_data.
SELECT * FROM sf_crime_data LIMIT 10;

# 2 Remembering back to the lessons on dates, Use
the Quiz Question at the bottom of this page to make
sur you remember the format that dates should use in SQL

# 3 Look at the date column in the sf_crime_data table.
Notice the date is not in the correct format.
SELECT date FROM sf_crime_data LIMIT 10;

# 4 Write a query to change the date into the correct SQL date format.
You will need to use at least SUBSTR and CONCAT to perform this operation.
SELECT date, 
SUBSTR(date, 7, 4) || '-' ||
   LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS fomated_date
FROM sf_crime_data
LIMIT 10;

# 5 Write a query to change the date into the correct SQL date
format. You will need to use at least SUBSTR and CONCAT
to perform this operation
SELECT date, 
CAST(SUBSTR(date, 7, 4) || '-' ||
   LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS DATE)
FROM sf_crime_data
LIMIT 10;

# COALESCE QUIZZ
#1 SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL; 


#2 SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

#3 SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


#4 SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


#5 SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;




