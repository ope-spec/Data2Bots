# Data2Bots Data Engineering Technical Assessment

## Project Name
Data2Bots Data Engineering Technical Assessment

## Project Description
The Data2Bots Data Engineering Technical Assessment project aims to build an ELT pipeline (batch or streaming) that loads business data into data warehouse (opeyadeg3905_staging) and performs transformations (opeyadeg3905_analytics).

## Project Structure
The project involves the following steps:
1. **Extraction**: Data is extracted from an S3 bucket using Python.
2. **Loading**: The extracted data is loaded into a PostgreSQL database (`opeyadeg3905_staging` schema).
3. **Transformation**: The dbt tool is used to perform data transformations.
4. **Schema**: The transformed data is stored in the `opeyadeg3905_analytics` schema.

## Installation Instructions
To install and set up the project, follow these steps:

1. Clone the project repository from GitHub.
2. Install Python and the necessary dependencies by running `pip install -r requirements.txt`.
3. Set up your PostgreSQL database and configure the connection details in the project files.
4. Install dbt by following the instructions in the dbt documentation.
5. Configure dbt by providing the necessary database connection details in the dbt profiles.yml file.
6. Run the provided Python script to extract data from the S3 bucket and load it into the PostgreSQL database.
7. Use dbt to apply transformations to the loaded data and store the transformed data in the `opeyadeg3905_analytics` schema.

## Query Structure for the Data Transformation Questions

### 1. Get the total number of orders placed on a public holiday every month, for the past year.

**Location of SQL Query** - dbt-project/Data2Bots/models/agg_public_holiday
**Description of query** - This query retrieves the total number of orders placed on public holidays each month for the past year. It joins the if_common.dim_dates table with the opeyadeg3905_staging.orders table to match the order dates with the public holidays (Boolean data). The result is stored in the derived view agg_public_holiday within the opeyadeg3905_analytics schema.
**Query Breakdown**:
	1. The query uses a Common Table Expression (CTE) named public_holidays to calculate the total number of orders on public holidays.

	2. The CTE begins with the WITH keyword followed by the CTE name public_holidays.

	3. Inside the CTE, a SELECT statement retrieves the columns calendar_dt, month_of_the_year_num, and the count of order_id as total_orders.

	4. The SELECT statement joins two tables: if_common.dim_dates (aliased as d) and opeyadeg3905_staging.orders (aliased as o). The join condition is d.calendar_dt = o.order_date.

	5. The WHERE clause filters the data by the following conditions: 
		* d.year_num = EXTRACT(YEAR FROM '2022-09-05'::date) - 1: It selects the past year based on the date '2022-09-05'. 
		* d.day_of_the_week_num BETWEEN 1 AND 5: It restricts the day of the week to Monday to Friday.
		* NOT d.working_day: It excludes working days (holidays).

	6. The GROUP BY clause groups the data by calendar_dt and month_of_the_year_num.

	7. The CTE public_holidays has been defined and is ready to be used in the subsequent SELECT statement.

	8. The main SELECT statement retrieves the results from the CTE. It selects current_date as ingestion_date and calculates the total number of orders for each month using conditional aggregation.

	9. The COALESCE function is used to handle cases where there are no orders for a specific month. It replaces null values with 0.


### 2. Get the total number of late shipments and undelivered shipments.

**Location of SQL Query** - dbt-project/Data2Bots/models/agg_shipments
**Description of query** - This query calculates the total number of late shipments and undelivered shipments. It joins the opeyadeg3905_staging.shipment_deliveries table with the opeyadeg3905_staging.orders table to match the shipments with the corresponding orders. The results are returned as the total number of late shipments and undelivered shipments.
**Query Breakdown**:
	1. The query begins by defining three Common Table Expressions (CTEs) - orders, shipment_deliveries, and shipment_counts. CTEs are temporary result sets that can be referenced within the main query.

	2. The orders CTE selects the order_id and order_date from the opeyadeg3905_staging.orders table. The order_date is cast to the date data type.

	3. The shipment_deliveries CTE selects the order_id, shipment_date, and delivery_date from the opeyadeg3905_staging.shipment_deliveries table.

	4. The shipment_counts CTE consists of two parts, connected with a UNION ALL operator. The first part calculates the total number of late shipments. It joins the shipment_deliveries and orders CTEs on the order_id column. It selects the count of records (COUNT(*)) as tt_late_shipments and sets tt_undelivered_shipments to 0. It applies the following conditions: sd.shipment_date is greater than or equal to (>=) o.order_date plus 6 days (INTERVAL '6 days'), and sd.delivery_date is NULL.

	5. The second part calculates the total number of undelivered shipments. It performs a left join between the shipment_deliveries and orders CTEs on the order_id column. It selects 0 as tt_late_shipments and the count of records (COUNT(*)) as tt_undelivered_shipments. It applies the following conditions: sd.delivery_date is NULL, sd.shipment_date is NULL, and '2022-09-05' (cast to the date data type) is greater than or equal to (>=) o.order_date plus 15 days (INTERVAL '15 days').

	6. The main query selects the current date as ingestion_date and calculates the sum of tt_late_shipments as tt_late_shipments and the sum of tt_undelivered_shipments as tt_undelivered_shipments from the shipment_counts CTE.


### 3. Get information about the product with the highest reviews.

**Location of SQL Query** - dbt-project/Data2Bots/models/best_performing_product
**Description of query** - This query calculates the total number of late shipments and undelivered shipments. It joins the opeyadeg3905_staging.shipment_deliveries table with the opeyadeg3905_staging.orders table to match the shipments with the corresponding orders. The results are returned as the total number of late shipments and undelivered shipments.
**Query Breakdown**:
	1. The query starts with a Common Table Expression (CTE) named best_product. CTEs allow you to create temporary result sets that can be referenced later in the query.

	2. The CTE consists of three subqueries joined together to gather information about the best product:

		a. The first subquery (rp) calculates review-related metrics for each product. It counts the total number of reviews (total_reviews) and sums the review points (tt_review_points). It also calculates the percentage distribution of one-star reviews (pct_one_star_review), two-star reviews (pct_two_star_review), three-star reviews (pct_three_star_review), four-star reviews (pct_four_star_review), and five-star reviews (pct_five_star_review) for each product. The GROUP BY clause groups the results by product_id.

		b. The second subquery (op) retrieves the most ordered day and checks if it falls on a public holiday. It joins the opeyadeg3905_staging.orders table with the if_common.dim_dates table to match the order dates with the calendar dates. The GROUP BY clause groups the results by product_id and working_day from the dim_dates table.

		c. The third subquery (ss) calculates the percentage distribution of early shipments and late shipments for each product. It joins the opeyadeg3905_staging.orders table with the opeyadeg3905_staging.shipment_deliveries table based on the order_id column. It counts the number of early shipments (where the delivery date is on or before the shipment date) and the number of late shipments (where the delivery date is after the shipment date). The percentage distributions are calculated by dividing the counts by the total shipments for each product.

	3. The best_product CTE combines the results from the three subqueries using join operations. It joins rp and op on the product_id column and then joins the result with ss on the same column. Finally, it joins the if_common.dim_products table to retrieve the product name based on the product_id.

	4. The outer query selects columns from the best_product CTE to form the final result set. It includes columns such as current_date (as ingestion_date), product_name, most_ordered_day, is_public_holiday, tt_review_points, and the various percentage distributions.

	5. The LIMIT 1 clause is applied to the outer query to ensure that only one row is returned which is the product with the highest reviews


## Usage
To use the project, follow these steps:

1. Make sure the project is properly installed and set up.
2. Execute the Python script to extract data from the S3 bucket and load it into the PostgreSQL database.
3. Run dbt commands to apply transformations and store the transformed data in the `opeyadeg3905_analytics` schema.
4. Analyze and query the transformed data in the PostgreSQL database as needed.


## Dependencies
The project has the following dependencies:
- Python (Jupyter Notebook)
- PostgreSQL
- dbt
- Required Python packages (boto3, psycopg2, pandas, numpy, sqlalchemy)

Make sure to install and configure these dependencies before running the project.


## Contact Information
For any inquiries or questions regarding the project, please contact:
- Name: Opeyemi Adegboye
- Email: opeyemiogunniyi230@gmail.com

