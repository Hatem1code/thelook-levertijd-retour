-- A4-02: Levertijden per maand
SELECT
    COUNT(*) AS aantal_bestellingen,
    DATE_TRUNC(DATE(created_at), MONTH) AS maand,

    ROUND(AVG(TIMESTAMP_DIFF(delivered_at, created_at, DAY)), 1)
        AS ge_totale_levertijd,

    ROUND(AVG(TIMESTAMP_DIFF(shipped_at, created_at, DAY)), 1)
        AS ge_verwerkingstijd,

    ROUND(AVG(TIMESTAMP_DIFF(delivered_at, shipped_at, DAY)), 1)
        AS ge_transporttijd

FROM `bigquery-public-data.thelook_ecommerce.orders`

WHERE DATE(created_at) >= '2019-02-01'
  AND DATE(created_at) < '2026-10-01'
  AND status IN ('Returned', 'Complete')
  AND delivered_at IS NOT NULL

GROUP BY maand
ORDER BY maand ASC;
