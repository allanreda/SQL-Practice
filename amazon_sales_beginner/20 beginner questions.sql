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
