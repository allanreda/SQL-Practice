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
SELECT "Fulfilment", COUNT(*) as fulfilment_type
FROM public.amazon_sales_data
GROUP BY "Fulfilment"

-- 5. List all orders that were shipped to 'BENGALURU'.
SELECT *
FROM public.amazon_sales_data
WHERE "ship-city" = 'BENGALURU' 
AND "Status" != 'Cancelled'

-- 6. Calculate the average order amount.

-- 7. Count the number of orders for each product category.

-- 8. Identify the state with the most orders shipped.

-- 9. List all orders where the quantity ordered is greater than 10.

-- 10. Find the total sales amount for each currency.

-- 11. Retrieve the first 5 records from the table.

-- 12. Count the number of unique products sold.

-- 13. Find the order with the highest sales amount.

-- 14. List all distinct sales channels.

-- 15. Count the number of orders with a status of 'Cancelled'.

-- 16. Calculate the total number of products sold (sum of quantities).

-- 17. Find the average quantity ordered per order.

-- 18. List all orders with a sales amount greater than 500.

-- 19. Retrieve the top 5 most frequently ordered products.

-- 20. Find the number of orders shipped by each fulfilment type.



