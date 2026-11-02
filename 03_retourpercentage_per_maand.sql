-- A4-03: Retourpercentage per maand
SELECT
    DATE_TRUNC(DATE(o.created_at), MONTH) AS maand,

    COUNT(*) AS aantal_orderregels,

    COUNTIF(oi.status = 'Returned') AS aantal_retouren,

    COUNTIF(oi.status = 'Complete') AS aantal_geleverd,

    ROUND(
        SAFE_DIVIDE(
            COUNTIF(oi.status = 'Returned'),
            COUNTIF(oi.status = 'Returned')
            + COUNTIF(oi.status = 'Complete')
        ) * 100,
        1
    ) AS retourpercentage

FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi

JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON oi.order_id = o.order_id

WHERE DATE(o.created_at) >= '2019-02-01'
  AND DATE(o.created_at) < '2026-10-01'
  AND oi.status IN ('Returned', 'Complete')

GROUP BY maand
ORDER BY maand ASC;
