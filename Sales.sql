create database online_sales;
use online_sales;

Rename table `online sales data` to  `online_sales_data`;

select * from online_sales_data;

#Show total revenue and total orders per month.

select  month(Date), YEAR(Date) AS year,round(sum(`Total Revenue`),2) as   total_revenue_permonth , sum(`Units Sold`) as total_orders_permonth  from online_sales_data
group by  month(Date) , year(Date);


#Find monthly revenue for each region.
SELECT 
    Region,
    MONTH(Date),
    YEAR(Date) AS year,
    ROUND(SUM(`Total Revenue`), 2) AS total_revenue_permonth
FROM
    online_sales_data
GROUP BY  YEAR(Date) , MONTH(Date) , Region;

#Identify the top-selling product Category each month.
    SELECT year, month, `Product Category`, total_revenue
FROM (
    SELECT 
        YEAR(Date) AS year,
        MONTH(Date) AS month,
       `Product Category`,
        SUM(`Total Revenue`) AS total_revenue,
        RANK() OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY SUM(`Total Revenue`) DESC) AS rnk
    FROM online_sales_data
    GROUP BY YEAR(Date), MONTH(Date), `Product Category`
) AS ranked
WHERE rnk = 1;


#4. Calculate month-over-month revenue change
SELECT 
  year,
  month,
  revenue,
  revenue - LAG(revenue) OVER (ORDER BY year, month) AS revenue_change
FROM (
  SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(`Total Revenue`) AS revenue
  FROM online_sales_data
  GROUP BY year, month
) AS monthly;

#5. Show average order value per month
SELECT 
  YEAR(Date) AS year,
  MONTH(Date) AS month,
  ROUND(SUM(`Total Revenue`) / COUNT(DISTINCT `Transaction ID`), 2) AS avg_order_value
FROM online_sales_data
GROUP BY year, month;

#6. Display monthly order volume per category

SELECT 
  `Product Category`,
  YEAR(Date) AS year,
  MONTH(Date) AS month,
  COUNT(DISTINCT `Transaction ID`) AS order_volume
FROM online_sales_data
GROUP BY `Product Category`, year, month;

#Find the most popular product each month by order count
SELECT year, month,  `Product Category`, order_count
FROM (
  SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
     `Product Category`,
    COUNT(DISTINCT `Transaction ID`) AS order_count,
    RANK() OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY COUNT(DISTINCT `Transaction ID`) DESC) AS rnk
  FROM online_sales_data
  GROUP BY year, month, `Product Category`
) AS ranked
WHERE rnk = 1;


