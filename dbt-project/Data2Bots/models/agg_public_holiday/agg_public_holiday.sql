WITH public_holidays AS (
  SELECT
    d.calendar_dt,
    d.month_of_the_year_num,
    COUNT(o.order_id) AS total_orders
  FROM
    if_common.dim_dates AS d
  INNER JOIN
    opeyadeg3905_staging.orders AS o ON d.calendar_dt = o.order_date
  WHERE
    d.year_num = EXTRACT(YEAR FROM '2022-09-05'::date) - 1 -- Past year
    AND d.day_of_the_week_num BETWEEN 1 AND 5 -- Day of the week is Monday to Friday
    AND NOT d.working_day -- Not a working day (holiday)
  GROUP BY
    d.calendar_dt,
    d.month_of_the_year_num
)
SELECT
  current_date AS ingestion_date,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 1 THEN total_orders END), 0) AS tt_order_hol_jan,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 2 THEN total_orders END), 0) AS tt_order_hol_feb,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 3 THEN total_orders END), 0) AS tt_order_hol_mar,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 4 THEN total_orders END), 0) AS tt_order_hol_apr,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 5 THEN total_orders END), 0) AS tt_order_hol_may,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 6 THEN total_orders END), 0) AS tt_order_hol_jun,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 7 THEN total_orders END), 0) AS tt_order_hol_jul,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 8 THEN total_orders END), 0) AS tt_order_hol_aug,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 9 THEN total_orders END), 0) AS tt_order_hol_sep,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 10 THEN total_orders END), 0) AS tt_order_hol_oct,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 11 THEN total_orders END), 0) AS tt_order_hol_nov,
  COALESCE(SUM(CASE WHEN month_of_the_year_num = 12 THEN total_orders END), 0) AS tt_order_hol_dec
FROM
  public_holidays
