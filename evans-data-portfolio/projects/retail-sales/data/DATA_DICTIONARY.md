# Data dictionary

Source: simulated retail fixture, seed `4517`. No real people or businesses are represented. The raw file includes deliberate duplicates, missing values, label variations and invalid values.

**Grain:** one transaction for one product. Quantity can exceed one. There are no multi-line orders, customer IDs, return dates or return reasons.

| Field | Clean type | Meaning |
| --- | --- | --- |
| `source_row` | Integer | Stable original row number, retained for traceability |
| `transaction_id` | Text | Transaction identifier; unique in clean data |
| `order_date` | ISO date | Transaction date in 2025 |
| `city` | Text | Lagos, Abuja, Port Harcourt, Kano or Unknown |
| `category` | Text | Electronics, Fashion, Beauty or Home |
| `product` | Text | Product name; one of twelve simulated products |
| `channel` | Text | Online or In-store |
| `quantity` | Positive integer | Units in the transaction |
| `unit_price_ngn` | Number | Selling price per unit in NGN, before discount |
| `unit_cost_ngn` | Number | Product cost per unit in NGN |
| `discount_rate` | Fraction 0–1 | Discount as a fraction, e.g. 0.10 means 10% |
| `status` | Text | Completed or Returned |
| `gross_sales_ngn` | Number | Quantity × unit price, before refund treatment |
| `net_revenue_ngn` | Number | Discounted sales retained after full-refund treatment |
| `cogs_ngn` | Number | Retained cost of goods after saleable-stock return treatment |
| `gross_profit_ngn` | Number | Net revenue − COGS |

Raw data contains the first twelve fields. The clean export includes the four derived amounts. The Excel Sales sheet recalculates those amounts with formulas.

## Dataset assumptions

- Product prices and unit costs are fixed for each product; they are integer naira values in this fixture.
- Discounts are chosen from 0%, 5%, 10% and 15%. Thirty-six blank discounts on valid transactions are treated as zero.
- Eighteen missing city labels on valid transactions remain Unknown.
- Monthly valid transaction counts are intentionally chosen as 96, 102, 109, 112, 118, 120, 124, 128, 132, 139, 148 and 172.
- City, channel, category and return outcomes use chosen random weights. These are simulation assumptions rather than observed market proportions.
- Returned transactions are fully refunded. Stock is assumed saleable at full cost, and return handling costs are not modelled.
- Dates represent transaction dates. Refund timing and monthly accounting recognition are simplified.

## Rejected-row file

`rejected_rows.csv` contains the parsed unique rows excluded by validation and a `rejection_reason`. The unmodified original values remain available in `raw_sales.csv`, linked by `source_row`.
