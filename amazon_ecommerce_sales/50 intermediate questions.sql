-- 1. Calculate the total sales amount for each fulfilment type.
SELECT SUM("Amount") as sales_amount, "Fulfilment"
FROM public.amazon_sales_data  
GROUP BY "Fulfilment"

-- 2. Find the top 5 cities with the highest number of orders.
SELECT COUNT(*), "ship-city"
FROM public.amazon_sales_data  
GROUP BY "ship-city"
ORDER BY COUNT(*) DESC
LIMIT 5

-- 3. Calculate the average quantity ordered for each product category.
SELECT AVG("Qty") as avg_qty, "Category"
FROM public.amazon_sales_data  
WHERE "Status" != 'Cancelled'
GROUP BY "Category"

-- 4. List all orders that were shipped using 'Expedited' service level.
SELECT *
FROM public.amazon_sales_data  
WHERE "ship-service-level" = 'Expedited' AND "Status" != 'Cancelled'

-- 5. Count the number of orders that have a promotion applied.
SELECT COUNT(*)
FROM public.amazon_sales_data  
WHERE "promotion-ids" IS NOT NULL

-- 6. Find the total sales amount for each sales channel.
SELECT SUM("Amount") as sales_amount, "Sales Channel"
FROM public.amazon_sales_data  
GROUP BY "Sales Channel"

-- 7. Identify the ASIN with the highest total sales amount.
SELECT SUM("Amount") as sales_amount, "ASIN"
FROM public.amazon_sales_data  
WHERE "Amount" IS NOT NULL
GROUP BY "ASIN"
ORDER BY sales_amount DESC
LIMIT 1

-- 8. Calculate the total quantity of products sold for each size.
SELECT SUM("Qty") as sold_products, "Size"
FROM public.amazon_sales_data  
GROUP BY "Size"
ORDER BY sold_products DESC

-- 9. List all orders where the 'Courier Status' is not 'Shipped'.
SELECT *
FROM public.amazon_sales_data  
WHERE "Courier Status" != 'Shipped'

-- 10. Find the average sales amount for orders shipped to each city.
SELECT AVG("Amount") as avg_amount, "ship-city"
FROM public.amazon_sales_data  
WHERE "Amount" IS NOT NULL
GROUP BY "ship-city"
ORDER BY avg_amount DESC

-- 11. Calculate the total sales amount for each date.
SELECT SUM("Amount") as sales_amount, "Date"
FROM public.amazon_sales_data  
GROUP BY "Date"

-- 12. Identify the month with the highest number of orders.
SELECT 
	COUNT(*) as order_count, 
    EXTRACT(month FROM normalized_date) as order_month,
    EXTRACT(year FROM normalized_date) as order_year
FROM 
    (SELECT 
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
GROUP BY order_month, order_year
ORDER BY order_count DESC

-- 13. List all orders where the quantity ordered is less than 5.
SELECT *
FROM public.amazon_sales_data  
WHERE "Qty" < 5

-- 14. Calculate the average order amount for each fulfilment type.
SELECT AVG("Amount") as avg_amount, "Fulfilment"
FROM public.amazon_sales_data  
GROUP BY "Fulfilment"

-- 15. Find the top 3 states with the highest average sales amount per order.
SELECT AVG("Amount") avg_amount, "ship-state"
FROM public.amazon_sales_data  
WHERE "Amount" IS NOT NULL AND "ship-state" IS NOT NULL
GROUP BY "ship-state"
ORDER BY "ship-state" DESC

-- 16. Count the number of orders with a status of 'Cancelled' for each state.
SELECT COUNT(*) as cancelled_orders, "ship-state"
FROM public.amazon_sales_data  
WHERE "Status" = 'Cancelled'
GROUP BY "ship-state"
ORDER BY cancelled_orders DESC

-- 17. Calculate the total sales amount for orders with a promotion applied.
SELECT SUM("Amount") as promotion_order_amount
FROM public.amazon_sales_data  
WHERE "promotion-ids" IS NOT NULL

-- 18. Find the most frequently ordered size.
SELECT COUNT(*) as order_count, "Size"
FROM public.amazon_sales_data  
GROUP BY "Size"
ORDER BY order_count DESC
LIMIT 1

-- 19. List all orders that were fulfilled by 'Merchant'.
SELECT *
FROM public.amazon_sales_data  
WHERE "Fulfilment" = 'Merchant'

-- 20. Calculate the average sales amount for each 'ship-service-level'.
SELECT AVG("Amount") as avg_amount, "ship-service-level"
FROM public.amazon_sales_data  
GROUP BY "ship-service-level"

-- 21. Identify the top 5 products with the highest quantity sold.
SELECT SUM("Qty") as qty_sold, "SKU"
FROM public.amazon_sales_data  
GROUP BY "SKU"
ORDER BY qty_sold DESC
LIMIT 5

-- 22. Calculate the total sales amount for each courier status.
SELECT SUM("Amount") as sales_amount, "Courier Status"
FROM public.amazon_sales_data  
GROUP BY "Courier Status"

-- 23. Find the state with the highest number of 'Cancelled' orders.
SELECT COUNT(*) as cancelled_orders, "ship-state"
FROM public.amazon_sales_data  
WHERE "Status" = 'Cancelled'
GROUP BY "ship-state"
ORDER BY cancelled_orders DESC
LIMIT 1

-- 24. List all orders where the promotion-ids contain more than one promotion.
SELECT *
FROM public.amazon_sales_data  
WHERE REGEXP_COUNT("promotion-ids", ',') > 1

-- 25. Calculate the total quantity of products sold for each sales channel.
SELECT SUM("Qty"), "Sales Channel"
FROM public.amazon_sales_data  
GROUP BY "Sales Channel"

-- 26. Identify the product category with the lowest average sales amount.
SELECT AVG("Amount") as avg_amount, "Category"
FROM public.amazon_sales_data  
GROUP BY "Category"
ORDER BY avg_amount ASC
LIMIT 1

-- 27. Find the total sales amount for orders shipped in the month of April.
SELECT SUM("Amount") as sales_amount
FROM public.amazon_sales_data  
WHERE "Date" ~ '^04-\d{2}-\d{2}(\d{2})?$'

-- 28. Calculate the average order amount for orders with a quantity of 1.
SELECT AVG("Amount") as avg_amount
FROM public.amazon_sales_data  
WHERE "Qty" = 1

-- 29. List all orders where the 'Size' is not specified.
SELECT *
FROM public.amazon_sales_data  
WHERE "Size" IS NULL

-- 30. Find the total sales amount for each 'ship-country'.
SELECT SUM("Amount") as sales_amount, "ship-country"
FROM public.amazon_sales_data  
GROUP BY "ship-country"

-- 31. Calculate the average quantity ordered for orders with a 'Shipped' status.
SELECT AVG("Qty")
FROM public.amazon_sales_data  
WHERE "Status" = 'Shipped'

-- 32. Identify the top 3 ASINs with the highest average sales amount.
SELECT AVG("Amount") as avg_amount, "ASIN"
FROM public.amazon_sales_data  
WHERE "Amount" IS NOT NULL
GROUP BY "ASIN"
ORDER BY avg_amount DESC
LIMIT 3

-- 33. Count the number of orders for each 'ship-service-level'.
SELECT COUNT(*) as order_acount, "ship-service-level"
FROM public.amazon_sales_data  
GROUP BY "ship-service-level"

-- 34. Calculate the total sales amount for each 'ship-city' in 'MAHARASHTRA'.
SELECT SUM("Amount") as sales_amount, "ship-city"
FROM public.amazon_sales_data  
WHERE "ship-state" = 'MAHARASHTRA'
GROUP BY "ship-city" 

-- 35. Find the total quantity of products sold for each 'fulfilled-by' type.
SELECT SUM("Qty") as products_sold, "fulfilled-by"
FROM public.amazon_sales_data  
GROUP BY "fulfilled-by"

-- 36. List all orders where the 'Sales Channel' is 'Amazon.in' and the 'Status' is 'Cancelled'.
SELECT *
FROM public.amazon_sales_data  
WHERE "Sales Channel" = 'Amazon.in' AND "Status" = 'Cancelled'

-- 37. Calculate the average sales amount for each 'promotion-id'.
SELECT AVG("Amount") as avg_amount, "promotion-ids"
FROM public.amazon_sales_data  
GROUP BY "promotion-ids"

-- 38. Identify the state with the highest average quantity ordered per order.
SELECT AVG("Qty") as avg_qty, "ship-state"
FROM public.amazon_sales_data  
WHERE "Qty" IS NOT NULL
GROUP BY "ship-state"
ORDER BY avg_qty DESC
LIMIT 1

-- 39. Find the total sales amount for orders shipped to each postal code.
SELECT SUM("Amount") as sales_amount, "ship-postal-code"
FROM public.amazon_sales_data  
GROUP BY "ship-postal-code"

-- 40. Calculate the total sales amount for orders with a sales amount greater than 1000.
SELECT SUM("Amount") as sales_amount_over_1000
FROM public.amazon_sales_data  
WHERE "Amount" > 1000

-- 41. List all orders where the 'Style' is not null.
SELECT *
FROM public.amazon_sales_data  
WHERE "Style" IS NOT NULL

-- 42. Count the number of orders shipped to 'KARNATAKA' with a 'Shipped' status.
SELECT COUNT(*) as orders
FROM public.amazon_sales_data  
WHERE "ship-state" = 'KARNATAKA' AND "Status" = 'Shipped'

-- 43. Calculate the average sales amount for each 'Category' in 'TELANGANA'.
SELECT AVG("Amount") as avg_amount, "Category"
FROM public.amazon_sales_data  
WHERE "ship-state" = 'TELANGANA'
GROUP BY "Category"

-- 44. Identify the month with the lowest total sales amount.
SELECT 
	SUM("Amount") as order_amount,
    EXTRACT(month FROM normalized_date) as order_month,
    EXTRACT(year FROM normalized_date) as order_year
FROM 
    (SELECT 
	    "Amount",
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
GROUP BY order_month, order_year
ORDER BY order_amount ASC
LIMIT 1

-- 45. Find the total quantity of products sold for each 'ship-postal-code'.
SELECT SUM("Qty") as products_sold, "ship-postal-code"
FROM public.amazon_sales_data
GROUP BY "ship-postal-code"

-- 46. Calculate the average order amount for orders with a quantity greater than 5.
SELECT AVG("Amount") as avg_amount
FROM public.amazon_sales_data
WHERE "Qty" > 5 

-- 47. List all orders where the 'Category' is 'kurta' and the 'Size' is 'M'.
SELECT *
FROM public.amazon_sales_data
WHERE "Category" = 'kurta' AND "Size" = 'M'

-- 48. Calculate the total sales amount for orders with a 'Shipped' status and 'Courier Status' is 'Delivered to Buyer'.
SELECT SUM("Amount") as sales_amount
FROM public.amazon_sales_data
WHERE "Status" = 'Shipped' AND "Courier Status" = 'Delivered to Buyer'

-- 49. Identify the top 3 sales channels with the highest total sales amount.
SELECT SUM("Amount") as sales_amount, "Sales Channel"
FROM public.amazon_sales_data
GROUP BY "Sales Channel"
ORDER BY sales_amount DESC
LIMIT 3

-- 50. Find the average quantity ordered for each 'ASIN' in 'MUMBAI'.
SELECT AVG("Qty") as avg_qty, "ASIN"
FROM public.amazon_sales_data
WHERE "ship-city" = 'MUMBAI'
GROUP BY "ASIN"


