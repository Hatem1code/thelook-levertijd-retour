#A4-01 bestellingen per maand
SELECT count(*) aantal_bestellingen, date_trunc(date(created_at), month) as maand
FROM
    `bigquery-public-data.thelook_ecommerce.orders`
WHERE DATE(created_at) >= '2019-02-01'
  AND DATE(created_at) < '2026-10-01'
group by maand
order by maand ASC;
