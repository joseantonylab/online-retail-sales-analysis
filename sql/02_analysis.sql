-- 02_analysis.sql
-- Business questions on the cleaned Online Retail II data
-- Note: revenue excludes cancelled orders (is_cancelled = 0)

USE online_retail;
-- Q1. Overall KPIs
SELECT
    ROUND(SUM(revenue), 2)                             AS total_revenue,
    COUNT(DISTINCT invoice)                            AS total_orders,
    COUNT(DISTINCT customer_id)                        AS total_customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2)   AS avg_order_value
FROM transactions
WHERE is_cancelled = 0;
--result total revenue is 19398208.44 and total oders 39514 and total customers 5852 and average oder value is 490.92
-- Q2. Monthly revenue and month-over-month growth
WITH monthly AS (
    SELECT DATE(DATE_FORMAT(invoice_date, '%Y-%m-01')) AS month,
           SUM(revenue) AS revenue
    FROM transactions
    WHERE is_cancelled = 0
    GROUP BY month
)
SELECT month,
       ROUND(revenue, 0) AS revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;
--while november shows hike in sale but december month shows a reduction in sale
-- Q3. Top 10 countries by revenue, with share of total
SELECT country,
       ROUND(SUM(revenue), 0) AS revenue,
       ROUND(100 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1) AS pct_of_total
FROM transactions
WHERE is_cancelled = 0
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;
--uk have high in revnue compared to others and that is far ahead and second position holds by EIRE
-- Q4. Top 10 products by revenue
SELECT stock_code,
       description,
       ROUND(SUM(revenue), 0) AS total_revenue
FROM transactions
WHERE is_cancelled = 0
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;
--regency cakestand and white hanging heart produce high revenue
SELECT stock_code,
       description,
       SUM(quantity) AS total_quantity
FROM transactions
WHERE is_cancelled = 0
GROUP BY stock_code, description
ORDER BY total_quantity DESC
LIMIT 10;
--quantity doesnt resembles revenue 
-- Q5. Cancellation rate by country (countries with at least 100 orders)
SELECT country,
       COUNT(DISTINCT invoice) AS total_orders,
       COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice END) AS cancelled_orders,
       ROUND(100 * COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice END)
                 / COUNT(DISTINCT invoice), 1) AS cancellation_rate_pct
FROM transactions
GROUP BY country
HAVING COUNT(DISTINCT invoice) >= 100
ORDER BY cancellation_rate_pct DESC;
-- cancellation rate percent is high on germany and then swiz lowest goes to sweden
-- Q6. One-time vs repeat customers (customers with an ID only)
WITH customer_orders AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice) AS orders,
           SUM(revenue)            AS revenue
    FROM transactions
    WHERE is_cancelled = 0
      AND customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT CASE WHEN orders = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
       COUNT(*)                                        AS customers,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_customers,
       ROUND(SUM(revenue), 0)                          AS revenue,
       ROUND(100 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1) AS pct_of_revenue
FROM customer_orders
GROUP BY customer_type;
--repeat customers comes with revenue of 96.7 and onetime comes with 3.3
-- Q7. Cohort retention rate for the first 6 months
SELECT cohort_month,
       months_since_first,
       customers,
       ROUND(100 * customers / FIRST_VALUE(customers)
             OVER (PARTITION BY cohort_month ORDER BY months_since_first), 1) AS retention_pct
FROM v_cohort_retention
WHERE months_since_first <= 6
ORDER BY cohort_month, months_since_first;
--2009 dec have good retention percent,percent get lower moving to 6 th month
