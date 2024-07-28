-- 1. Count the total number of records in the amazon_sales_report table.
SELECT COUNT(*) 
FROM public.amazon_sales_data

-- 2. Find the total sales amount.
SELECT SUM("Amount") 
FROM public.amazon_sales_data

-- 3. Retrieve the top 10 orders based on the sales amount.
SELECT * 
FROM public.amazon_sales_data 
WHERE "Amount" IS NOT NULL
ORDER BY "Amount" DESC
LIMIT 10

-- 4. Count the number of orders per fulfilment type.
SELECT "Fulfilment", COUNT(*) AS fulfilment_type
FROM public.amazon_sales_data
GROUP BY "Fulfilment"

-- 5. List all orders that were shipped to 'BENGALURU'.
SELECT *
FROM public.amazon_sales_data
WHERE "ship-city" = 'BENGALURU' 
AND "Courier Status" = 'Shipped'

-- 6. Calculate the average order amount.
SELECT AVG("Amount")
FROM public.amazon_sales_data

-- 7. Count the number of orders for each product category.
SELECT "Category", COUNT(*) AS product_category
FROM public.amazon_sales_data
GROUP BY "Category"

-- 8. Identify the state with the most orders shipped.
SELECT "ship-state", COUNT(*) AS orders_shipped
FROM public.amazon_sales_data
WHERE "Courier Status" = 'Shipped'
GROUP BY "ship-state"
ORDER BY COUNT(*) DESC
LIMIT 1

-- 9. List all orders where the quantity ordered is greater than 10.
SELECT *
FROM public.amazon_sales_data
WHERE "Qty" > 10

-- 10. Find the total sales amount for each currency.
SELECT "currency", SUM("Amount") AS sales_amount
FROM public.amazon_sales_data
GROUP BY "currency"

-- 11. Retrieve the first 5 records from the table.
SELECT *
FROM public.amazon_sales_data
LIMIT 5

-- 12. Count the number of unique products sold.
SELECT COUNT(DISTINCT "SKU") AS unique_products
FROM public.amazon_sales_data

-- 13. Find the order with the highest sales amount.
SELECT * 
FROM public.amazon_sales_data 
WHERE "Amount" IS NOT NULL
ORDER BY "Amount" DESC
LIMIT 1

-- 14. List all distinct sales channels.
SELECT DISTINCT "Sales Channel" 
FROM public.amazon_sales_data

-- 15. Count the number of orders with a status of 'Cancelled'.
SELECT COUNT(*) AS cancelled_orders
FROM public.amazon_sales_data  
WHERE "Status" = 'Cancelled'

-- 16. Calculate the total number of products sold (sum of quantities).
SELECT SUM("Qty") AS total_products_sold
FROM public.amazon_sales_data

-- 17. Find the average quantity ordered per order.
SELECT AVG("Qty") AS average_quantity
FROM public.amazon_sales_data  
WHERE "Status" != 'Cancelled'

-- 18. List all orders with a sales amount greater than 500.
SELECT * 
FROM public.amazon_sales_data  
WHERE "Amount" > 500

-- 19. Retrieve the top 5 most frequently ordered products.
SELECT COUNT(*), "SKU"
FROM public.amazon_sales_data  
GROUP BY "SKU"
ORDER BY COUNT DESC
LIMIT 5

-- 20. Find the number of orders shipped by each fulfilment type.
SELECT COUNT(*), "Fulfilment"
FROM public.amazon_sales_data  
GROUP BY "Fulfilment"

-- 21. List all orders that were shipped in 'MUMBAI'.
SELECT *
FROM public.amazon_sales_data  
WHERE "ship-city" = 'MUMBAI'

-- 22. Find the total sales amount for each state.
SELECT SUM("Amount") AS sales_amount, "ship-state"
FROM public.amazon_sales_data  
GROUP BY "ship-state"
ORDER BY sales_amount DESC

-- 23. Count the number of orders for each size.
SELECT COUNT(*) AS orders, "Size"
FROM public.amazon_sales_data  
GROUP BY "Size"
ORDER BY orders DESC

-- 24. Calculate the average sales amount per state.
SELECT AVG("Amount") AS sales_amount, "ship-state"
FROM public.amazon_sales_data  
GROUP BY "ship-state"
ORDER BY sales_amount DESC

-- 25. Find the order with the lowest sales amount.
SELECT *, "Amount"
FROM public.amazon_sales_data  
WHERE "Amount" >= 1
ORDER BY "Amount" ASC
LIMIT 1

-- 26. List all orders where the status is 'Shipped' but the fulfilment is 'Merchant'.
SELECT *
FROM public.amazon_sales_data  
WHERE "Status" = 'Shipped' AND "Fulfilment" = 'Merchant'

-- 27. Count the number of orders with the currency 'INR'.
SELECT COUNT(*) AS INR_orders
FROM public.amazon_sales_data  
WHERE "currency" = 'INR'

-- 28. Find the total sales amount for orders fulfilled by 'Easy Ship'.
SELECT SUM("Amount") AS sales_amount
FROM public.amazon_sales_data  
WHERE "fulfilled-by" = 'Easy Ship'

-- 29. List all orders with a quantity of 1.
SELECT *
FROM public.amazon_sales_data  
WHERE "Qty" = 1

-- 30. Count the number of orders for each courier status.
SELECT COUNT(*) AS Orders, "Courier Status"
FROM public.amazon_sales_data  
GROUP BY "Courier Status"

-- 31. Calculate the average sales amount for each category.
SELECT AVG("Amount") AS sales_amount, "Category"
FROM public.amazon_sales_data  
GROUP BY "Category"

-- 32. Find the total sales amount for orders shipped to 'HYDERABAD'.
SELECT SUM("Amount") AS total_sales
FROM public.amazon_sales_data  
WHERE "ship-city" = 'HYDERABAD'

-- 33. Count the number of orders with the ASIN 'B09KXVBD7Z'.
SELECT COUNT(*)
FROM public.amazon_sales_data  
WHERE "ASIN" = 'B09KXVBD7Z'

-- 34. List all orders that were cancelled.
SELECT *
FROM public.amazon_sales_data  
WHERE "Status" = 'Cancelled'

-- 35. Find the total quantity of products sold in 'TELANGANA'.
SELECT SUM("Qty") AS total_products
FROM public.amazon_sales_data  
WHERE "ship-state" = 'TELANGANA'

-- 36. Count the number of distinct cities orders were shipped to.
SELECT COUNT(DISTINCT("ship-city")) AS unique_cities
FROM public.amazon_sales_data  

-- 37. Find the order with the earliest date.
SELECT MIN(DATE("Date")) AS earliest_date
FROM public.amazon_sales_data  

-- 38. List all orders where the promotion-ids are not null.
SELECT *
FROM public.amazon_sales_data  
WHERE "promotion-ids" IS NOT NULL

-- 39. Count the number of orders shipped to each country.
SELECT COUNT(*), "ship-country"
FROM public.amazon_sales_data  
GROUP BY "ship-country"

-- 40. Calculate the total sales amount for each promotion.
SELECT COUNT("Amount"), "promotion-ids"
FROM public.amazon_sales_data  
GROUP BY "promotion-ids"
ORDER BY COUNT DESC

-- 41. List all orders where the sales amount is between 500 and 1000.
SELECT *
FROM public.amazon_sales_data  
WHERE "Amount" BETWEEN 500 AND 1000

-- 42. Find the average sales amount for each courier status.
SELECT AVG("Amount") AS sales_amount, "Courier Status"
FROM public.amazon_sales_data  
GROUP BY "Courier Status"

-- 43. Count the number of orders with the SKU 'JNE3405-KR-XXL'
SELECT COUNT(*) AS order_count
FROM public.amazon_sales_data  
WHERE "SKU" = 'JNE3405-KR-XXL'

-- 44. List all orders where the size is 'M'.
SELECT *
FROM public.amazon_sales_data  
WHERE "Size" = 'M'

-- 45. Find the total sales amount for each ship service level.
SELECT SUM("Amount") AS sales_amount, "ship-service-level"
FROM public.amazon_sales_data  
GROUP BY "ship-service-level"

-- 46. Count the number of orders with the fulfilment type 'Amazon'
SELECT COUNT(*) AS order_count
FROM public.amazon_sales_data  
WHERE "Fulfilment" = 'Amazon'

-- 47. List all orders with a sales channel of 'Amazon.in'.
SELECT *
FROM public.amazon_sales_data  
WHERE "Sales Channel" = 'Amazon.in'

-- 48. Find the total sales amount for orders with a quantity greater than 1.
SELECT SUM("Amount") AS total_amount
FROM public.amazon_sales_data  
WHERE "Qty" > 1

-- 49. Calculate the average sales amount for each sales channel.
SELECT AVG("Amount") AS avg_amount, "Sales Channel"
FROM public.amazon_sales_data  
GROUP BY "Sales Channel"

-- 50. List all orders with the style 'JNE3697'
SELECT *
FROM public.amazon_sales_data  
WHERE "Style" = 'JNE3697'

