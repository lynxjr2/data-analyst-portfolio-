-- SQLite; amounts in NGN. Rates are fractions, not percentages.

-- 01_overview
SELECT COUNT(*) AS transactions,
SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) AS completed_transactions,
SUM(CASE WHEN status='Returned' THEN 1 ELSE 0 END) AS returned_transactions,
ROUND(SUM(net_revenue_ngn),2) AS net_revenue_ngn,
ROUND(SUM(gross_profit_ngn),2) AS gross_profit_ngn,
ROUND(SUM(gross_profit_ngn)/NULLIF(SUM(net_revenue_ngn),0),6) AS gross_margin,
ROUND(SUM(net_revenue_ngn)/NULLIF(SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END),0),2) AS average_completed_order_ngn,
ROUND(1.0*SUM(CASE WHEN status='Returned' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0),6) AS return_rate
FROM clean_sales;

-- 02_monthly
SELECT SUBSTR(order_date,1,7) AS month, COUNT(*) AS transactions,
SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) AS completed_transactions,
SUM(CASE WHEN status='Returned' THEN 1 ELSE 0 END) AS returned_transactions,
ROUND(SUM(net_revenue_ngn),2) AS net_revenue_ngn,
ROUND(SUM(gross_profit_ngn),2) AS gross_profit_ngn
FROM clean_sales GROUP BY SUBSTR(order_date,1,7) ORDER BY month;

-- 03_categories
SELECT category, COUNT(*) AS transactions,
ROUND(SUM(net_revenue_ngn),2) AS net_revenue_ngn,
ROUND(SUM(gross_profit_ngn),2) AS gross_profit_ngn,
ROUND(SUM(gross_profit_ngn)/NULLIF(SUM(net_revenue_ngn),0),6) AS gross_margin,
ROUND(1.0*SUM(CASE WHEN status='Returned' THEN 1 ELSE 0 END)/COUNT(*),6) AS return_rate
FROM clean_sales GROUP BY category ORDER BY net_revenue_ngn DESC;

-- 04_cities
SELECT city, COUNT(*) AS transactions,
ROUND(SUM(net_revenue_ngn),2) AS net_revenue_ngn,
ROUND(SUM(gross_profit_ngn),2) AS gross_profit_ngn
FROM clean_sales GROUP BY city ORDER BY net_revenue_ngn DESC;

-- 05_products
SELECT product, category, COUNT(*) AS transactions,
ROUND(SUM(net_revenue_ngn),2) AS net_revenue_ngn,
ROUND(SUM(gross_profit_ngn),2) AS gross_profit_ngn,
ROUND(SUM(gross_profit_ngn)/NULLIF(SUM(net_revenue_ngn),0),6) AS gross_margin
FROM clean_sales GROUP BY product, category ORDER BY gross_profit_ngn DESC;

-- 06_monthly_growth
WITH monthly AS (
 SELECT SUBSTR(order_date,1,7) AS month, SUM(net_revenue_ngn) AS revenue
 FROM clean_sales GROUP BY SUBSTR(order_date,1,7)
), with_prior AS (
 SELECT month, revenue, LAG(revenue) OVER (ORDER BY month) AS prior_revenue FROM monthly
)
SELECT month, ROUND(revenue,2) AS net_revenue_ngn,
ROUND(prior_revenue,2) AS prior_revenue_ngn,
ROUND((revenue-prior_revenue)/NULLIF(prior_revenue,0),6) AS month_on_month_growth
FROM with_prior ORDER BY month;

-- 07_channels
SELECT channel, COUNT(*) AS transactions,
ROUND(SUM(net_revenue_ngn),2) AS net_revenue_ngn,
ROUND(SUM(gross_profit_ngn),2) AS gross_profit_ngn,
ROUND(1.0*SUM(CASE WHEN status='Returned' THEN 1 ELSE 0 END)/COUNT(*),6) AS return_rate
FROM clean_sales GROUP BY channel ORDER BY net_revenue_ngn DESC;

-- 08_quality
SELECT 'Raw source rows' AS measure, COUNT(*) AS rows FROM raw_sales
UNION ALL SELECT 'Duplicate business records', COUNT(*) FROM ranked_sales WHERE duplicate_rank > 1
UNION ALL SELECT 'Rejected unique transactions', COUNT(*) FROM rejected_rows
UNION ALL SELECT 'Clean transactions', COUNT(*) FROM clean_sales
UNION ALL SELECT 'Blank discounts filled on valid rows', COUNT(*) FROM raw_sales r JOIN clean_sales c ON r.source_row=c.source_row WHERE TRIM(r.discount_rate)=''
UNION ALL SELECT 'Unknown cities retained', COUNT(*) FROM clean_sales WHERE city='Unknown';