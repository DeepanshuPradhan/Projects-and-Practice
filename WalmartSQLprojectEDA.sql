CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating DECIMAL(2,1),
    PRIMARY KEY (invoice_id)  -- Define the primary key separately
);

SELECT * FROM salesdatawalmart.sales;

-- ---------------------------------------------------------------------------------------------------------
-- -----------------------------------Feature Engineering----------------------------------------------------
-- time of day
SELECT time,
	(CASE 
      WHEN 'time' BETWEEN "00:00:00" AND "12:00;00" THEN "Morning"
	  WHEN 'time' BETWEEN "12:01:00" AND "16:00;00" THEN "Afternoon"
	  ELSE "Evening"
      END) AS time_of_date
FROM sales;    -- --23:32

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day=(
    CASE 
      WHEN 'time' BETWEEN "00:00:00" AND "12:00;00" THEN "Morning"
	  WHEN 'time' BETWEEN "12:01:00" AND "16:00;00" THEN "Afternoon"
	  ELSE "Evening"
	END
);

  #--day_name
  SELECT
         date,
         DAYNAME(date) AS day_name
   FROM sales;
ALTER TABLE sales ADD Column day_name VARCHAR(10);
   
   
UPDATE sales
SET day_name = DAYNAME(date);
   
# --month_name
SELECT 
      date,
	  MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD column month_name VARCHAR(10);

UPDATE sales
SET month_name=MONTHNAME(date);


#-- Exploratory Data Analysis(EDA)----------------------------

-- how may unique cities does the data have?
SELECT 
     DISTINCT city
FROM sales;

-- how may unique branches does the data have?

SELECT 
     DISTINCT branch
FROM sales;

-- -- in which  city is each  branches  ?
SELECT 
      DISTINCT CITY,
      BRANCH 
FROM sales;
--  how many unique product lines does the data have?     
SELECT 
	   COUNT(DISTINCT product_line)         -- 40:01
FROM sales;
--  what is the most common payment method?   
SELECT 
       payment_method,
       COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

--  what is the most selling product line?  

SELECT 
       product_line,
       COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

--  what is the total revenue by month?  
SELECT 
       month_name AS month,
       SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;
--  what month had the largest COGS?  
SELECT 
       month_name AS month,
       SUM(cogs) AS cogs
FROM sales 
GROUP BY month_name
ORDER BY cogs;

--  what product line had the largest revenue ? 
SELECT 
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;
--  what is the city with the largest revenue ? 

SELECT 
   branch,
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

--  what product line had the largest VAT ? 

SELECT 
       product_line,
       AVG(VAT) AS avg_tax
       FROM sales
       GROUP BY product_line
       ORDER BY avg_tax DESC;
       
-- Which branch sold more products than average product sold?
SELECT branch,
       SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(quantity) FROM sales);

-- What is the most common product line by by gender?
SELECT gender,
       product_line,
       COUNT(gender) as total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT 
  AVG(rating) AS avg_rating,
  product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


 





