WITH per_maand AS (
    SELECT
        DATE_TRUNC(DATE(o.created_at), MONTH) AS maand,

        ROUND(
            SAFE_DIVIDE(
                COUNTIF(oi.status = 'Returned'),
                COUNT(*)
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
),
 gemiddelde AS (
    SELECT
        AVG(retourpercentage) AS gemiddeld_retourpercentage
    FROM per_maand
)

SELECT
    maand,
    retourpercentage,
    ROUND(gemiddeld_retourpercentage, 1) AS gemiddelde,

    ROUND(
        SAFE_DIVIDE(
            retourpercentage - gemiddeld_retourpercentage,
            gemiddeld_retourpercentage
        ) * 100,
        1
    ) AS afwijking_procent,

    CASE
        WHEN SAFE_DIVIDE(
            retourpercentage - gemiddeld_retourpercentage,
            gemiddeld_retourpercentage
        ) * 100 > 10
        THEN 'signaal'
        ELSE ''
    END AS signaal

FROM per_maand
CROSS JOIN gemiddelde
ORDER BY maand;
