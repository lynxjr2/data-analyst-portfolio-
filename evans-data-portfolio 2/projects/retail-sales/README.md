# Retail sales performance

An analysis of revenue, gross profit and returns using simulated Nigerian retail transactions from January–December 2025. Amounts are in Nigerian naira (NGN).

## Business question

Which categories contribute the most revenue, which earn higher gross margins, and where are return rates highest?

The fictional retailer sells twelve products across Electronics, Fashion, Beauty and Home in Lagos, Abuja, Port Harcourt and Kano.

## Data preparation

Each record represents one transaction for one product, with quantity indicating the number of units. The original dataset contains 1,544 rows.

| Treatment | Result |
| --- | --- |
| Duplicate transaction records removed | 24 |
| Invalid unique transactions rejected | 20 |
| Clean transactions retained | 1,500 |
| Completed transactions | 1,377 |
| Returned transactions | 123 |
| Missing discounts recorded as zero | 36 |
| Missing cities retained as Unknown | 18 |

Duplicates have matching business fields. The earliest source row is retained. Invalid records comprise six invalid quantities, five invalid unit costs, four invalid dates and five invalid discounts. Text labels are trimmed and standardised.

The row count reconciles as **1,544 − 24 − 20 = 1,500**. Missing-value counts belong to the clean population rather than additional rejected rows.

## Metric definitions

| Metric | Definition |
| --- | --- |
| Gross sales | Quantity × unit price |
| Net revenue | Discounted sales for completed transactions; zero for full returns |
| Cost of goods sold | Quantity × unit cost for completed transactions; zero for full returns |
| Gross profit | Net revenue − cost of goods sold |
| Gross margin | Total gross profit ÷ total net revenue |
| Return rate | Returned transactions ÷ all clean transactions |
| Average completed order value | Net revenue ÷ completed transactions |

The return model assumes a full refund and saleable stock recovered at full cost. Tax, shipping, overhead and return handling costs are excluded.

## Findings

| Finding | Evidence |
| --- | --- |
| Total net revenue | ₦37,176,500 |
| Total gross profit | ₦13,729,300, with a 36.9% gross margin |
| Largest revenue category | Electronics: ₦13,014,050, or 35.0% of total revenue |
| Highest category gross margin | Beauty: 45.1% |
| Highest category return rate | Fashion: 62 returns from 418 transactions, or 14.8% |
| Highest monthly net revenue | December: ₦4,048,850 |

Electronics leads revenue, while Beauty has the highest margin. Fashion's return rate exceeds the overall 8.2% rate, but the dataset contains no return reasons to explain the difference.

## Recommendations

Further assessment would examine Fashion return reasons, compare product-level margins and discounts, and consider demand and inventory before changing the category mix. Recovering missing city labels would improve geographic reporting.

## Analysis files

- [Excel workbook](excel/Retail_Sales_Analysis.xlsx): transaction calculations, city/category filters, monthly totals and a revenue chart.
- [SQL cleaning](sql/01_clean.sql): duplicate handling, validation and clean transaction views.
- [SQL analysis](sql/02_analysis.sql): overview, monthly, category, city, product, growth, channel and quality results.
- [Query outputs](analysis/summary.json): summary results from the SQL analysis.
- [Power BI measures](power-bi/measures.dax) and [Power Query](power-bi/Sales.pq): reporting source files. The native Power BI report is planned.
- [Data dictionary](data/DATA_DICTIONARY.md): field definitions and dataset assumptions.

SQL totals and Excel calculations reconcile. Rates are calculated from matching totals rather than averages of monthly or category percentages.

## Data limits

All records are simulated. Monthly transaction volumes were deliberately chosen, so the year-end increase does not establish real seasonality. There are no customer identifiers, multi-line orders, return dates or reasons for returns. These figures describe the sample and do not represent real business outcomes.
