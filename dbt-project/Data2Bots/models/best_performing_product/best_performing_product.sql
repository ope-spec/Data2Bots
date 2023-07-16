WITH best_product AS (
  SELECT
    p.product_id::varchar,
    p.product_name,
    op.most_ordered_day,
    op.is_public_holiday,
    rp.tt_review_points,
    rp.pct_one_star_review,
    rp.pct_two_star_review,
    rp.pct_three_star_review,
    rp.pct_four_star_review,
    rp.pct_five_star_review,
    ss.pct_early_shipments,
    ss.pct_late_shipments
  FROM (
    SELECT
      product_id::varchar,
      COUNT(*) AS total_reviews,
      SUM(review) AS tt_review_points,
      (COUNT(CASE WHEN review = 1 THEN 1 END)::float / COUNT(*)) * 100 AS pct_one_star_review,
      (COUNT(CASE WHEN review = 2 THEN 1 END)::float / COUNT(*)) * 100 AS pct_two_star_review,
      (COUNT(CASE WHEN review = 3 THEN 1 END)::float / COUNT(*)) * 100 AS pct_three_star_review,
      (COUNT(CASE WHEN review = 4 THEN 1 END)::float / COUNT(*)) * 100 AS pct_four_star_review,
      (COUNT(CASE WHEN review = 5 THEN 1 END)::float / COUNT(*)) * 100 AS pct_five_star_review
    FROM opeyadeg3905_staging.reviews
    GROUP BY product_id
    ORDER BY total_reviews DESC
    LIMIT 1
  ) AS rp
  JOIN (
    SELECT
      o.product_id::varchar,
      MAX(o.order_date) AS most_ordered_day,
      CASE
        WHEN d.working_day = true THEN true
        ELSE false
      END AS is_public_holiday
    FROM opeyadeg3905_staging.orders o
    JOIN if_common.dim_dates d ON o.order_date = d.calendar_dt
    GROUP BY o.product_id, d.working_day
  ) AS op ON rp.product_id = op.product_id
  JOIN (
    SELECT
      o.product_id::varchar,
      (COUNT(CASE WHEN s.delivery_date <= s.shipment_date THEN 1 END)::float / COUNT(*)) * 100 AS pct_early_shipments,
      (COUNT(CASE WHEN s.delivery_date > s.shipment_date THEN 1 END)::float / COUNT(*)) * 100 AS pct_late_shipments
    FROM opeyadeg3905_staging.orders o
    JOIN opeyadeg3905_staging.shipment_deliveries s ON o.order_id = s.order_id
    GROUP BY o.product_id
  ) AS ss ON rp.product_id = ss.product_id
  JOIN if_common.dim_products p ON rp.product_id::int = p.product_id
)

SELECT
  current_date AS ingestion_date,
  product_name,
  most_ordered_day,
  is_public_holiday,
  tt_review_points,
  pct_one_star_review,
  pct_two_star_review,
  pct_three_star_review,
  pct_four_star_review,
  pct_five_star_review,
  pct_early_shipments,
  pct_late_shipments
FROM best_product
LIMIT 1
