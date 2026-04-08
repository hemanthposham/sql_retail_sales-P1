CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sale
				(
					transactions_id INT,
					sale_date	DATE,
					sale_time	TIME,
					customer_id	INT,
					gender	VARCHAR(15),
					age	INT,
					category  VARCHAR(15),	
					quantiy	INT,
					price_per_unit	FLOAT,
					cogs   FLOAT,
					total_sale  FLOAT

);

SELECT * FROM retail_sale
LIMIT 10

SELECT COUNT (*) FROM retail_sale

SELECT * FROM retail_sale
WHERE transactions_id IS NULL

SELECT * FROM retail_sale
WHERE sale_date IS NULL

SELECT * FROM retail_sale
WHERE 
	 transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR 
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR 
	 total_sale IS NULL;
	 
DELETE  FROM retail_sale
WHERE 
	 transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR 
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR 
	 total_sale IS NULL;

-- how many sales wh have
SELECT COUNT (*) total_sales FROM retail_sale

-- how many uniuq customers we have
-- distinct use for uniuq ppl 
SELECT COUNT (DISTINCT customer_id) total_sales FROM retail_sale

--how many uniuq categorys we have?
SELECT COUNT (DISTINCT category) total_sales FROM retail_sale

--name of the categorys names
SELECT DISTINCT category FROM retail_sale


--DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWER
--1Q. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sale
WHERE sale_date = '2022-11-05'

--2Q. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT 
  *
FROM retail_sale
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4
--3Q. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM(total_sale) AS net_cost,
	COUNT(*) AS total_orders
FROM retail_sale
GROUP BY 1

--4Q. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age),2) AS avg_age
	FROM retail_sale
WHERE category = 'Beauty'

--5Q. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sale
WHERE total_sale > 1000

--6Q. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	category,
	age,
	COUNT (*) TOTAL_TR
	FROM retail_sale
GROUP BY
	category,
	age
	ORDER BY 1

--7Q. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	AVG(total_sale) AS AVG_SALE,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sale
GROUP BY 1, 2
) AS t1
WHERE RANK = 1

--8Q. Write a SQL query to find the top 5 customers based on the highest total sales .

SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sale
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--9Q. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS UNIQUE_ID
FROM retail_sale

GROUP BY category
ORDER BY 1

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
AS(
SELECT *,
	CASE 
	WHEN EXTRACT( HOUR FROM sale_time) < 12 THEN 'MORNING'
	WHEN  EXTRACT( HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE 'EVENING'
	END AS shift
FROM retail_sale
)
SELECT
	SHIFT, 
	COUNT(*) total_order
	FROM hourly_sale
	GROUP BY shift
