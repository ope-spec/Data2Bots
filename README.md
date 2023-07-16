# Data2Bots Data Engineering Technical Assessment

## Project Name
Data2Bots Data Engineering Technical Assessment

## Project Description
The Data2Bots Data Engineering Technical Assessment project aims to build an ELT pipeline (batch or streaming) that loads business data into our data warehouse and performs transformations.

## Project Structure
The project involves the following steps:
1. Extracting data from an S3 bucket.
2. Loading the extracted data into a PostgreSQL database using Python.
3. Applying transformations to the loaded data using a transformation tool like dbt.
4. Storing the transformed data in the `opeyadeg3905_analytics` schema.

## Installation Instructions
To install and set up the project, follow these steps:

1. Clone the project repository from GitHub.
2. Install Python and the necessary dependencies by running `pip install -r requirements.txt`.
3. Set up your PostgreSQL database and configure the connection details in the project files.
4. Install dbt by following the instructions in the dbt documentation.
5. Configure dbt by providing the necessary database connection details in the dbt profiles.yml file.
6. Run the provided Python script to extract data from the S3 bucket and load it into the PostgreSQL database.
7. Use dbt to apply transformations to the loaded data and store the transformed data in the `opeyadeg3905_analytics` schema.

## Usage
To use the project, follow these steps:

1. Make sure the project is properly installed and set up.
2. Execute the Python script to extract data from the S3 bucket and load it into the PostgreSQL database.
3. Run dbt commands to apply transformations and store the transformed data in the `opeyadeg3905_analytics` schema.
4. Analyze and query the transformed data in the PostgreSQL database as needed.

## Query Structure Explanation

### 1. Get the Total Number of Orders Placed on a Public Holiday Every Month, for the Past Year
This query retrieves the total number of orders placed on a public holiday each month for the past year. A public holiday is defined as a day with a `day_of_the_week` number in the range 1 - 5 (Monday to Friday) and a `working_day` value of `false`. The query utilizes a Common Table Expression (CTE) named `public_holidays` to calculate the total number of orders for each public holiday in the past year, grouped by calendar date and month of the year. The final query selects the ingestion date as `'2022-09-05'` and presents the total number of orders for each month, ensuring that all months are included even if no orders were placed on public holidays.

### 2. Get the Total Number of Late Shipments and Undelivered Shipments
This query calculates the total number of late shipments and undelivered shipments. A late shipment is defined as one with a `shipment_date` greater than or equal to 6 days after the `order_date`, and the `delivery_date` is NULL. An undelivered shipment is one with both `delivery_date` and `shipment_date` as NULL. The query utilizes multiple Common Table Expressions (CTEs) (`orders`, `shipment_deliveries`, and `shipment_counts`) to calculate the total number of late shipments and undelivered shipments based on the given criteria. The final query selects the ingestion date as `'2022-09-05'` and presents the sum of the total number of late shipments and undelivered shipments.

### 3. Get Product Metrics: Highest Reviews, Most Ordered Day, Public Holiday, Review Points, and Shipment Distribution
This query retrieves information about the product with the highest number of reviews. It includes metrics such as the most ordered day, whether that day was a public holiday, total review points, percentage distribution of review points, percentage distribution of early shipments, and percentage distribution of late shipments for that particular product. The query utilizes multiple Common Table Expressions (CTEs) (`best_product`, `reviews`, `orders`, `shipment_deliveries`) to calculate the required metrics. It combines data from different tables and performs calculations to derive the desired metrics. The final query selects the ingestion date as `'2022-09-05'` and retrieves the information for the product with the highest number of reviews, limiting the results to one row.

## Dependencies
The project has the following dependencies:
- Python
- PostgreSQL
- dbt (or any other chosen transformation tool)
- Required Python packages (boto3, psycopg2, pandas, numpy, sqlalchemy)

Make sure to install and configure these dependencies before running the project.


## Contact Information
For any inquiries or questions regarding the project, please contact:
- Name: Opeyemi Adegboye
- Email: opeyemiogunniyi230@gmail.com

