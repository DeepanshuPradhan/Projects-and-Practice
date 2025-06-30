-- Revenue Leakage & Refund Pattern Analysis Using MySQL --
CREATE DATABASE revenue_leakage;
USE revenue_leakage;

CREATE TABLE orders (
         order_id VARCHAR(10) PRIMARY KEY,
         customer_id VARCHAR(10),
         order_date DATE,
         product_id VARCHAR(10),
         qunatity INT,
         price_per_unit DECIMAL(10,2),
         total_amount DECIMAL(10,2)
);

CREATE TABLE returns (
      return_id VARCHAR(10) PRIMARY KEY,
      order_id VARCHAR(10),
      return_date DATE,
      reason VARCHAR(50),
      refund_amount DECIMAL(10,2)
);
      
CREATE TABLE products (
     product_id VARCHAR(10) PRIMARY KEY,
     category VARCHAR(50),
     cost_price DECIMAL(10,2),
     selling_price DECIMAL(10,2),
     vendor_id VARCHAR(10)
);


CREATE TABLE vendors (
       vendor_id VARCHAR(10) PRIMARY KEY,
       vendor_name VARCHAR(100),
       region VARCHAR(50),
       rating INT 
);


-- Revenue Leakage Summary--

SELECT 
      SUM(o.total_amount) AS total_sales,
      SUM(r.refund_amount) AS total_refunds,
      ROUND(SUM(r.refund_amount) *100/SUM(o.total_amount),2) AS refund_rate_percentage
      -- calculates the refund rate percentage 
      -- gets the percentage of refunds relative to total sales
      --  rounds the % to 2 decimal places 
FROM orders o 
JOIN returns r ON o.order_id=r.order_id;  

-- Refund % by category --   

SELECT 
      p.category,
      COUNT(r.return_id) AS total_returns,
      COUNT(o.order_id) AS total_orders,
      ROUND(COUNT(r.return_id)*100/COUNT(o.order_id),2) AS return_percentage
FROM products p
JOIN orders o ON p.product_id=o.product_id
LEFT JOIN returns r ON o.order_id=r.order_id
GROUP BY p.category
ORDER BY return_percentage DESC;

-- Cutsomers with High Returns --

SELECT 
      o.customer_id,
      COUNT(*) AS total_returns,
      SUM(r.refund_amount) AS total_refund_amount
FROM returns r
JOIN orders o ON r.order_id=o.order_id
GROUP BY o.customer_id
HAVING COUNT(*) >3
ORDER BY total_returns DESC;


-- Loss Making Products

SELECT 
     p.product_id,
     p.category,
     SUM(o.total_amount) AS sales,
     SUM(r.refund_amount) AS refunds,
     SUM(o.total_amount) - SUM(r.refund_amount) AS net_revenue
FROM orders o
JOIN products p ON o.product_id=p.product_id
LEFT JOIN returns r ON o.order_id=r.order_id
GROUP BY p.product_id,p.category
HAVING refunds>sales*0.5;

-- Vendors Return Rate

SELECT 
       v.vendor_name,
       COUNT(r.return_id) AS total_returns,
       COUNT(o.order_id) AS total_orders,
       ROUND(COUNT(r.return_id)*100/COUNT(o.order_id),2) AS return_rate
FROM vendors v 
JOIN products p ON v.vendor_id=p.vendor_id 
JOIN orders o ON o.product_id=p.product_id
LEFT JOIN returns r ON o.order_id=r.order_id
GROUP BY v.vendor_name
ORDER BY return_rate DESC;