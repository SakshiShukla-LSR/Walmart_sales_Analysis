CREATE DATABASE IF NOT EXISTS walmartsale;
use walmartsale;
-- Transfering the data frmm .csv to my sql using the table
CREATE TABLE IF NOT EXISTS sale (
invoice_id VARCHAR(70) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30),
gender VARCHAR(30) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10) NOT NULL,
quantity INT NOT NULL,
tax_pct FLOAT(6) NOT NULL,
total DECIMAL(12) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10) NOT NULL,
gross_margin_pct FLOAT(11) NOT NULL,
gross_income DECIMAL(12) NOT NULL,
rating FLOAT(2) NOT NULL
);

SELECT *
FROM sale;
SET SQL_SAFE_UPDATES=0;
-- Adding the time of the day----------------------------------------------------------------
SELECT time,
(CASE 
      WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	Else "Evening"
	END) as time_of_day
	From sale;

ALTER TABLE sale ADD COLUMN time_of_day VARCHAR(20);

UPDATE sale
SET time_of_day =(CASE 
      WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	Else "Evening"
	END);
-- ADDING THE DAY NAME using DAYNAME()      
AlTER TABLE SALE 
ADD COLUMN day_name VARCHAR(20);
UPDATE sale
SET day_name = DAYNAME(Date);

-- adding month_name column
Alter table sale
ADD column month_name Varchar(20);

update sale
set month_name= MONTHNAME(date);

-- -------------------Generic questions--------------
-- How many unique cities does the data have?
SELECT city
FROM Sale
GROUP BY city
ORDER BY city DESC;

-- In which city is each branch?
SELECT branch, city
FROM sale
GROUP BY city, branch;

-- Product based questions
-- How many unique product lines does the data have?
SELECT product_line, COUNT(product_line)
FROM sale
GROUP BY product_line
ORDER BY COUNT(product_line);

-- What is the most common payment method?
SELECT payment, COUNT(payment)
FROM sale
GROUP BY payment
ORDER BY COUNT(payment) DESC ;

-- What is the most selling product line?

SELECT product_line, SUM(quantity)
FROM sale
GROUP BY product_line;

-- What is the total revenue by month
SELECT * FROM sale;
SELECT month_name as monthn, SUM(total)
FROM sale
GROUP BY monthn
ORDER BY SUM(total) DESC;

-- What month had the largest COGS? 
SELECT month_name, SUM(cogs)
FROM sale
GROUP BY month_name
ORDER BY SUM(cogs) DESC ;

-- What product line had the largest revenue?
SELECT product_line, SUM(total)
FROM sale
GROUP BY product_line 
ORDER BY SUM(total) DESC;

-- What is the city with the largest revenue?
SELECT city, SUM(total)
FROM sale
GROUP BY city 
ORDER BY SUM(total) DESC;

-- What product line had the largest VAT?

SELECT product_line, AVG(tax_pct) as VAT
FROM sale
GROUP BY product_line
ORDER BY VAT desc;

-- Fetch each product line and add a column to
-- those product line showing "Good", "Bad". Good 
-- if its greater than average sales

ALTER TABLE sale
ADD COLUMN rating_name VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;
SELECT 
	AVG(quantity) AS avg_qnty
FROM sale;

SELECT
	product_line,
	CASE
	WHEN SUM(quantity) > 6  THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sale
GROUP BY  product_line;
SELECt * FROM sale;
-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity)
FROM sale
Group BY branch
HAVING SUM(quantity)> AVG(quantity);		

-- What is the most common product line by gender

SELECT gender, product_line, COUNt(Gender)
FROM sale
GROUP BY Gender, product_line;

-- What is the average rating of each product line
SELECT product_line, AVG(RATING)
FROM SALE
GROUP BY Product_line;


-- Customer based questions

-- How many unique customer types does the data have?
SELECT * FROM Sale;
SELECT DISTINCT customer_type
FROM sale;
-- OR-------------------------
SELECT customer_type
FROM sale
GROUP BY customer_type;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment 
FROM Sale;
-- What is the most common customer type?
SELECT * FROM sale;
SELECT customer_type , Count(customer_type)
FROM sale
GROUP BY customer_type
ORDER BY COUNT(customer_type) DESC;
-- Which customer type buys the most?
SELECT customer_type, SUM(total)
FROM sale
GROUP BY customer_type;
-- OR
SELECT
	customer_type,
    COUNT(customer_type)
FROM sale
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender, count(gender)
FROM sale
GROUP BY gender;

-- What is the gender distribution per branch?
SELECT branch,count(*),gender
FROM sale
GROUP BY branch, gender;

-- Which time of the day do customers give most ratings?
SELECT AVG(rating),time_of_day
FROM sale
GROUP BY time_of_day;

-- Which time of the day do customers give most ratings per branch?
SELECT AVG(rating),time_of_day,branch
FROM sale
GROUP BY branch,time_of;
 
-- Which day fo the week has the best avg ratings?
SELECT day_name,AVG(rating)
FROM sale
GROUP BY day_name
ORDER BY AVG(rating) DESC;

-- Which day of the week has the best average ratings per branch?
SELECT count(day_name),AVG(rating),branch
FROM sale
GROUP BY branch
ORDER BY AVG(rating) DESC;

-- Number of sales made in each time of the day per weekday
SELECT * FROM sale;
SELECT time_of_day,count(quantity)
From sale
WHERE day_name="Monday"
GROUP BY time_of_day ;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total)
FROM sale
GROUP BY customer_type
ORDER BY SUM(total);

-- Which city has the largest tax/VAT percent?
SELECT city, AVG(tax_pct)
FROm sale
GROUP BY city
ORDER BY AVG(tax_pct);
-- Which customer type pays the most in VAT?

SELECT customer_type, AVG(tax_pct)
FROM sale
GROUP BY customer_type
ORDER BY AVG(tax_pct);