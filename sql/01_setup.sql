-- 01_setup.sql
-- Setup checks after loading the cleaned data from Python (notebooks/01_data_cleaning.ipynb)

USE online_retail;

-- 1. Check the upload: row count should match the number printed in the notebook
SELECT COUNT(*) AS total_rows FROM transactions;

-- 2. Indexes to speed up the analysis queries
--    (already created; running these again gives a "duplicate key name" error)
CREATE INDEX idx_customer ON transactions(customer_id);
CREATE INDEX idx_date ON transactions(invoice_date);