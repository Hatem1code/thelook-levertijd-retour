# TheLook eCommerce – delivery times and returns (BigQuery)

## Question

How do the average delivery time and the return rate develop per month at TheLook eCommerce, and in which months is the return rate more than 10% above the average?

## Data source

- Dataset: `bigquery-public-data.thelook_ecommerce` (public, synthetic data)
- Period: February 2019 – September 2026 (only complete months)
- Privacy: only queries and aggregated results, no rows per customer.

## Steps

| File | What it does |
| --- | --- |
| `01_bestellingen_per_maand.sql` | Counts the number of orders per month. |
| `02_levertijden_per_maand.sql` | Calculates the average total delivery time, processing time and shipping time per month, in days. |
| `03_retourpercentage_per_maand.sql` | Calculates the return rate per month: Returned / (Returned + Complete), at order-item level (JOIN orders + order\_items). |
| `04_signalering_retour.sql` | Compares each month's return rate with the average of all months and flags a month that is more than 10% above the average (WITH, CROSS JOIN, CASE WHEN). |

## Checks

- A4-01: 124,452 orders, 124,452 unique order\_ids and 0 empty created\_at. My first check was invalid: the period filter removed rows without a date before I could count them.
- A4-02: 0 negative times (delivered before ordered, delivered before shipped, shipped before ordered). Also found: the status is called 'Complete', not 'Delivered'.
- A4-03: 180,746 order items before and after the JOIN, all unique: no double counting. This is expected, because order\_id is unique in orders (A4-01: 124,452 = 124,452), so each order item matches exactly one order. Extra: order items = returns + delivered (e.g. Oct 2019: 66 = 19 + 47).
- A4-04: threshold at 10%: last flagged month 2024-06 (32.9%, deviation 14.6%), first month without a flag 2019-03 (31.3%, deviation 9.0%); recalculated by hand, correct.
- A4-05: February 2019 recalculated with a separate query. Attempt 1 gave 40.0%, because '< 2019-02-28' excluded the last day. Attempt 2 with '< 2019-03-01' gave 57.1% (4 of 7), equal to A4-03.

Screenshots of every query and check are kept in my DP2 portfolio, not in this repository.

## Results

- 92 complete months; orders grow from 10 (February 2019) to more than 3,000 per month in 2026.
- Average return rate across all months: 28.7% (average of the monthly rates).
- 13 months are more than 10% above the average, spread over several years; no flags in 2025 and 2026.
- Average total delivery time per month: roughly 2.3 to 3.9 days.

**Conclusion:** The flagged months are spread across the year, with no clear seasonal pattern visible (not tested statistically). The flags are mostly in the early years, when there were only a few orders, so a few returns could push the rate up. In later years, with many more orders, the return rate is more stable and stays below the threshold.

## Limitations

- The average is an average of monthly rates: a small month weighs as much as a large one. February 2019 (57.1%, 7 order items) counts as much as a month with more than 3,000 items. Flags in the early years may partly come from small numbers.
- I use the current status: recent months may show a return rate that is too low, because returns are still coming in.
- TIMESTAMP\_DIFF in DAY only counts whole days.
- The data is synthetic (TheLook), so the results say nothing about a real company.
- Flagging only on the return rate, not on delivery time.

