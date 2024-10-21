/* Easy */






/* 1. How many orders were placed in January 2017 in the sales_test.csv dataset? */

SELECT COUNT(ORDER_NO) as Order_placed_in_January
FROM sales_test 
WHERE DATE LIKE '%January%';


/* 2. What is the total number of units ordered (NS_ORDER) in February 2017? */

SELECT SUM(NS_ORDER) as total_number_of_units
FROM sales_test 
WHERE DATE LIKE '%February%';


/* 3. Find the number of canceled orders (NC_ORDER) for each customer in canceled_test.csv. */

SELECT CUSTOMER_NO, SUM(NC_ORDER) as total_canceled_order
FROM canceled_test
GROUP BY CUSTOMER_NO;


/* 4. How many unique customers are there in the sales_test.csv dataset? */

SELECT COUNT(DISTINCT CUSTOMER_NO) as unique_customers
FROM sales_test;


/* 5. Find the average number of items ordered (NS_ORDER) per order in the sales_test.csv dataset. */

SELECT AVG(NS_ORDER) as average_number_of_items_ordered
FROM sales_test;


/* 6. List the top 5 items that have been ordered the most in the sales_test.csv. */

SELECT ITEM, SUM(NS_ORDER) as total_ordered
FROM sales_test
GROUP BY ITEM
ORDER BY total_ordered DESC
LIMIT 5;


/* 7. Find the total number of successful orders (NS_ORDER) where the CUSTOMER_NO is 
either 1857566 or 1358538 and the DATE is in January 2017. */

SELECT SUM(NS_ORDER) AS total_orders 
FROM sales_test 
WHERE (CUSTOMER_NO = 1857566 OR CUSTOMER_NO = 1358538)
AND DATE LIKE '%January%';






/* Intermediate */






/* 8. Find the total number of units ordered (NS_ORDER) and canceled (NC_ORDER) for each 
item that appears in both sales_test.csv and canceled_test.csv. Include items that have 
been both ordered and canceled. */

SELECT  s.ITEM,
				SUM(s.NS_ORDER) as total_ordered,
				SUM(c.NC_ORDER) as total_canceled
FROM sales_test s
INNER JOIN canceled_test c
ON s.ITEM = c.ITEM
GROUP BY s.ITEM;


/* 9. Compare the number of canceled orders (NC_ORDER) and successful orders (NS_ORDER) 
for the same items. */

SELECT  s.ITEM,
				SUM(s.NS_ORDER) as total_ordered,
        SUM(c.NC_ORDER) as total_cancelled
FROM sales_test s
LEFT JOIN canceled_test c
ON s.ITEM=c.ITEM
GROUP BY s.ITEM;


/* 10. Classify each order in the sales_test.csv dataset as 'High', 'Medium', or 'Low' 
based on the number of units ordered (NS_ORDER):
- 'High' if NS_ORDER is greater than 50.
- 'Medium' if NS_ORDER is between 20 and 50.
- 'Low' if NS_ORDER is less than 20.*/

SELECT  ORDER_NO,
				NS_ORDER,
        CASE
        WHEN NS_ORDER > 50 THEN 'High'
        WHEN NS_ORDER BETWEEN 20 AND 50 THEN 'Medium'
        ELSE 'Low'
        END as order_classification
FROM sales_test;


/* 11. Calculate the percentage of shipped items (NS_SHIP) out of the total ordered 
(NS_ORDER) for each customer in sales_test.csv. */

SELECT  CUSTOMER_NO,
		SUM(NS_SHIP) / SUM(NS_ORDER) * 100 as ship_percentage
FROM sales_test
GROUP BY CUSTOMER_NO;


/* 12. Find the top 3 customers with the most canceled orders in canceled_test.csv. */

SELECT  CUSTOMER_NO,
				SUM(NC_ORDER) as total_cancelled
FROM canceled_test
GROUP BY CUSTOMER_NO
ORDER BY total_cancelled DESC
LIMIT 3;


/* 13. List all the items that have been canceled more than shipped in canceled_test.csv. */

SELECT  ITEM,
				SUM(NC_ORDER) as cancelled,
        SUM(NC_SHIP) as shipped
FROM canceled_test
GROUP BY ITEM
HAVING cancelled > shipped;


/* 14. Find the customer who placed the largest number of orders in January 2017 from 
the sales_test.csv dataset. */

SELECT CUSTOMER_NO, total_orders
FROM (
				SELECT  CUSTOMER_NO,
				COUNT(NS_ORDER) as total_orders
				FROM sales_test
        WHERE DATE LIKE '%January%'
        GROUP BY CUSTOMER_NO
	    ) 
	    as customer_orders
ORDER BY total_orders DESC
LIMIT 1;





/* Advanced */






/* 1. How many orders were placed in January 2017 in the sales_test.csv dataset? */

SELECT COUNT(ORDER_NO) as Order_placed_in_January
FROM sales_test 
WHERE DATE LIKE '%January%';


/* 15. For each customer, calculate the cumulative total of ordered units (NS_ORDER) 
over time and rank the orders by date. Show the ORDER_NO, CUSTOMER_NO, NS_ORDER, DATE, 
and the cumulative total of ordered units. */

SELECT 
    ORDER_NO, 
    CUSTOMER_NO, 
    NS_ORDER, 
    DATE, 
    SUM(NS_ORDER) OVER (PARTITION BY CUSTOMER_NO ORDER BY DATE) AS cumulative_ordered_units,
    ROW_NUMBER() OVER (PARTITION BY CUSTOMER_NO ORDER BY DATE) AS order_rank
FROM 
    sales_test
ORDER BY 
    CUSTOMER_NO, DATE;


/* 16. Find the top 3 customers who have the highest total number of canceled orders (NC_ORDER)
from canceled_test.csv and their corresponding total sales (NS_ORDER) from sales_test.csv. */

-- CTE to calculate total canceled orders for each customer
WITH canceled_orders AS (
    SELECT CUSTOMER_NO, SUM(NC_ORDER) AS total_canceled
    FROM canceled_test
    GROUP BY CUSTOMER_NO
)

-- Query to join the CTE with the sales data
SELECT c.CUSTOMER_NO, c.total_canceled, COALESCE(SUM(s.NS_ORDER), 0) AS total_sales
FROM canceled_orders c
LEFT JOIN sales_test s ON c.CUSTOMER_NO = s.CUSTOMER_NO
GROUP BY c.CUSTOMER_NO, c.total_canceled
ORDER BY c.total_canceled DESC
LIMIT 3;


/* 17. Find out the contribution of top 5 customers (by total NS_ORDER) to overall sales. */

WITH total_sales AS (
  SELECT SUM(NS_ORDER) AS total_sales FROM sales_test
),
top_customers AS (
  SELECT CUSTOMER_NO, SUM(NS_ORDER) AS customer_sales 
  FROM sales_test 
  GROUP BY CUSTOMER_NO 
  ORDER BY customer_sales DESC 
  LIMIT 5
)
SELECT CUSTOMER_NO, customer_sales / (SELECT total_sales FROM total_sales) * 100 AS contribution_percentage 
FROM top_customers;


/* 18. Perform an ABC classification of items in sales_test.csv, where:

- Class A: Top 20% of items contributing to 80% of total sales.
- Class B: Next 30% of items contributing to 15% of total sales.
- Class C: Remaining 50% of items. */

WITH total_sales AS (
  SELECT ITEM, SUM(NS_ORDER) AS item_sales 
  FROM sales_test 
  GROUP BY ITEM
),
ranked_sales AS (
  SELECT ITEM, item_sales, 
         NTILE(100) OVER (ORDER BY item_sales DESC) AS percentile 
  FROM total_sales
)
SELECT ITEM, 
       CASE 
         WHEN percentile <= 20 THEN 'A' 
         WHEN percentile <= 50 THEN 'B' 
         ELSE 'C' 
       END AS abc_class 
FROM ranked_sales;

