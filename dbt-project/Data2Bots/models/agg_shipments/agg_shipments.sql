WITH orders AS (
  SELECT
    order_id,
    order_date::date AS order_date
  FROM
    opeyadeg3905_staging.orders
),
shipment_deliveries AS (
  SELECT
    order_id,
    shipment_date,
    delivery_date
  FROM
    opeyadeg3905_staging.shipment_deliveries
),
shipment_counts AS (
  SELECT
    COUNT(*) AS tt_late_shipments,
    0 AS tt_undelivered_shipments
  FROM
    shipment_deliveries sd
  INNER JOIN
    orders o ON sd.order_id = o.order_id
  WHERE
    sd.shipment_date >= o.order_date + INTERVAL '6 days'
    AND sd.delivery_date IS NULL
  UNION ALL
  SELECT
    0 AS tt_late_shipments,
    COUNT(*) AS tt_undelivered_shipments
  FROM
    shipment_deliveries sd
  LEFT JOIN
    orders o ON sd.order_id = o.order_id
  WHERE
    sd.delivery_date IS NULL
    AND sd.shipment_date IS NULL
    AND '2022-09-05'::date >= o.order_date::date + INTERVAL '15 days'
)
SELECT
  current_date AS ingestion_date,
  SUM(tt_late_shipments) AS tt_late_shipments,
  SUM(tt_undelivered_shipments) AS tt_undelivered_shipments
FROM
  shipment_counts