-- 03_views.sql
-- Saved views used by the Power BI dashboard

USE online_retail;

-- Cohort retention: customers active in each month after their first purchase
CREATE OR REPLACE VIEW v_cohort_retention AS
WITH first_purchase AS (
    SELECT customer_id,
           DATE(DATE_FORMAT(MIN(invoice_date), '%Y-%m-01')) AS cohort_month
    FROM transactions
    WHERE customer_id IS NOT NULL AND is_cancelled = 0
    GROUP BY customer_id
),
activity AS (
    SELECT DISTINCT t.customer_id,
           f.cohort_month,
           DATE(DATE_FORMAT(t.invoice_date, '%Y-%m-01')) AS active_month
    FROM transactions t
    JOIN first_purchase f ON t.customer_id = f.customer_id
    WHERE t.is_cancelled = 0
)
SELECT cohort_month,
       TIMESTAMPDIFF(MONTH, cohort_month, active_month) AS months_since_first,
       COUNT(DISTINCT customer_id) AS customers
FROM activity
GROUP BY cohort_month, months_since_first;