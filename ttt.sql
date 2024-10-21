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