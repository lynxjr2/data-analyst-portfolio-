-- Keep the first source row for each transaction. Duplicates in this fixture
-- have identical business fields; inspect conflicts before using this rule elsewhere.
CREATE VIEW ranked_sales AS
SELECT *, ROW_NUMBER() OVER (PARTITION BY TRIM(transaction_id) ORDER BY source_row) AS duplicate_rank
FROM raw_sales;

-- Normalize text and parse amounts. Blank discount is assumed to mean no discount.
-- Keep missing city as Unknown so valid revenue is not discarded.
CREATE VIEW staged_sales AS
SELECT source_row, TRIM(transaction_id) AS transaction_id, TRIM(order_date) AS order_date,
  CASE LOWER(TRIM(city))
    WHEN 'lagos' THEN 'Lagos' WHEN 'abuja' THEN 'Abuja'
    WHEN 'port harcourt' THEN 'Port Harcourt' WHEN 'kano' THEN 'Kano'
    WHEN '' THEN 'Unknown' ELSE TRIM(city) END AS city,
  TRIM(category) AS category, TRIM(product) AS product,
  CASE LOWER(TRIM(channel)) WHEN 'online' THEN 'Online'
    WHEN 'in-store' THEN 'In-store' ELSE TRIM(channel) END AS channel,
  CAST(quantity AS INTEGER) AS quantity,
  CAST(unit_price_ngn AS REAL) AS unit_price_ngn,
  CAST(unit_cost_ngn AS REAL) AS unit_cost_ngn,
  CASE WHEN TRIM(discount_rate) = '' THEN 0 ELSE CAST(discount_rate AS REAL) END AS discount_rate,
  CASE LOWER(TRIM(status)) WHEN 'completed' THEN 'Completed'
    WHEN 'returned' THEN 'Returned' ELSE TRIM(status) END AS status,
  CASE WHEN TRIM(transaction_id) = '' THEN 'Missing transaction ID'
    WHEN date(TRIM(order_date), '+0 days') IS NULL OR date(TRIM(order_date), '+0 days') <> TRIM(order_date)
      OR TRIM(order_date) NOT BETWEEN '2025-01-01' AND '2025-12-31' THEN 'Invalid date'
    WHEN TRIM(quantity) = '' OR TRIM(quantity) GLOB '*[^0-9]*' OR CAST(quantity AS INTEGER) <= 0 THEN 'Invalid quantity'
    WHEN TRIM(unit_price_ngn) = '' OR TRIM(unit_price_ngn) GLOB '*[^0-9]*' OR CAST(unit_price_ngn AS REAL) <= 0 THEN 'Invalid unit price'
    WHEN TRIM(unit_cost_ngn) = '' OR TRIM(unit_cost_ngn) GLOB '*[^0-9]*' OR CAST(unit_cost_ngn AS REAL) < 0 THEN 'Invalid unit cost'
    WHEN (TRIM(discount_rate) <> '' AND TRIM(discount_rate) GLOB '*[^0-9.]*')
      OR CAST(discount_rate AS REAL) NOT BETWEEN 0 AND 1 THEN 'Invalid discount'
    WHEN LOWER(TRIM(status)) NOT IN ('completed', 'returned') THEN 'Invalid status'
    WHEN LOWER(TRIM(channel)) NOT IN ('online', 'in-store') THEN 'Invalid channel'
    ELSE NULL END AS rejection_reason
FROM ranked_sales WHERE duplicate_rank = 1;

CREATE VIEW rejected_rows AS SELECT * FROM staged_sales WHERE rejection_reason IS NOT NULL;
CREATE VIEW valid_sales AS SELECT * FROM staged_sales WHERE rejection_reason IS NULL;

-- A returned transaction is fully refunded. Saleable stock is recovered at
-- full cost; therefore returned revenue and COGS are zero. Shipping, tax,
-- overhead and return handling costs are outside this gross-profit model.
CREATE VIEW clean_sales AS
SELECT source_row, transaction_id, order_date, city, category, product, channel,
  quantity, unit_price_ngn, unit_cost_ngn, discount_rate, status,
  ROUND(quantity * unit_price_ngn, 2) AS gross_sales_ngn,
  CASE WHEN status = 'Completed' THEN ROUND(quantity * unit_price_ngn * (1-discount_rate), 2) ELSE 0 END AS net_revenue_ngn,
  CASE WHEN status = 'Completed' THEN ROUND(quantity * unit_cost_ngn, 2) ELSE 0 END AS cogs_ngn,
  CASE WHEN status = 'Completed' THEN ROUND(quantity * unit_price_ngn * (1-discount_rate) - quantity * unit_cost_ngn, 2) ELSE 0 END AS gross_profit_ngn
FROM valid_sales;
