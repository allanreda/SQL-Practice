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
select *
FROM public.amazon_sales_data  
where "ship-city" = 'MUMBAI'

-- 22. Find the total sales amount for each state.
select sum("Amount") as sales_amount, "ship-state"
FROM public.amazon_sales_data  
group by "ship-state"
order by sales_amount desc

-- 23. Count the number of orders for each size.
select count(*) as orders, "Size"
FROM public.amazon_sales_data  
group by "Size"
order by orders desc

-- 24. Calculate the average sales amount per state.
select avg("Amount") as sales_amount, "ship-state"
FROM public.amazon_sales_data  
group by "ship-state"
order by sales_amount desc

-- 25. Find the order with the lowest sales amount.
select *, "Amount"
FROM public.amazon_sales_data  
where "Amount" >= 1
order by "Amount" asc
limit 1

-- 26. List all orders where the status is 'Shipped' but the fulfilment is 'Merchant'.
select *
FROM public.amazon_sales_data  
where "Status" = 'Shipped' and "Fulfilment" = 'Merchant'

-- 27. Count the number of orders with the currency 'INR'.
select count(*) as INR_orders
FROM public.amazon_sales_data  
where "currency" = 'INR'

-- 28. Find the total sales amount for orders fulfilled by 'Easy Ship'.
select sum("Amount") as sales_amount
FROM public.amazon_sales_data  
where "fulfilled-by" = 'Easy Ship'

-- 29. List all orders with a quantity of 1.
select *
FROM public.amazon_sales_data  
where "Qty" = 1

-- 30. Count the number of orders for each courier status.
select count(*) as Orders, "Courier Status"
FROM public.amazon_sales_data  
group by "Courier Status"

-- 31. Calculate the average sales amount for each category.
select avg("Amount") as sales_amount, "Category"
FROM public.amazon_sales_data  
group by "Category"

-- 32. Find the total sales amount for orders shipped to 'HYDERABAD'.
select sum("Amount") as total_sales
FROM public.amazon_sales_data  
where "ship-city" = 'HYDERABAD'

-- 33. Count the number of orders with the ASIN 'B09KXVBD7Z'.
select count(*)
FROM public.amazon_sales_data  
where "ASIN" = 'B09KXVBD7Z'

-- 34. List all orders that were cancelled.
select *
FROM public.amazon_sales_data  
where "Status" = 'Cancelled'

-- 35. Find the total quantity of products sold in 'TELANGANA'.
select sum("Qty") as total_products
FROM public.amazon_sales_data  
where "ship-state" = 'TELANGANA'

-- 36. Count the number of distinct cities orders were shipped to.
select count(distinct("ship-city")) as unique_cities
FROM public.amazon_sales_data  

-- 37. Find the order with the earliest date.
select min(date("Date")) as earliest_date
FROM public.amazon_sales_data  

-- 38. List all orders where the promotion-ids are not null.
select *
FROM public.amazon_sales_data  
where "promotion-ids" is not null

-- 39. Count the number of orders shipped to each country.
select count(*), "ship-country"
FROM public.amazon_sales_data  
group by "ship-country"

-- 40. Calculate the total sales amount for each promotion.
select count("Amount"), "promotion-ids"
FROM public.amazon_sales_data  
group by "promotion-ids"
order by count desc

-- 41. List all orders where the sales amount is between 500 and 1000.
select *
FROM public.amazon_sales_data  
where "Amount" between 500 and 1000

-- 42. Find the average sales amount for each courier status.
select avg("Amount") as sales_amount, "Courier Status"
FROM public.amazon_sales_data  
group by "Courier Status"

-- 43. Count the number of orders with the SKU 'JNE3405-KR-XXL'
select count(*) as order_count
FROM public.amazon_sales_data  
where "SKU" = 'JNE3405-KR-XXL'

-- 44. List all orders where the size is 'M'.
select *
FROM public.amazon_sales_data  
where "Size" = 'M'

-- 45. Find the total sales amount for each ship service level.
select sum("Amount") as sales_amount, "ship-service-level"
FROM public.amazon_sales_data  
group by "ship-service-level"

-- 46. Count the number of orders with the fulfilment type 'Amazon'
select count(*) as order_count
FROM public.amazon_sales_data  
where "Fulfilment" = 'Amazon'

-- 47. List all orders with a sales channel of 'Amazon.in'.
select *
FROM public.amazon_sales_data  
where "Sales Channel" = 'Amazon.in'

-- 48. Find the total sales amount for orders with a quantity greater than 1.
select sum("Amount") as total_amount
FROM public.amazon_sales_data  
where "Qty" > 1

-- 49. Calculate the average sales amount for each sales channel.
select avg("Amount") as avg_amount, "Sales Channel"
FROM public.amazon_sales_data  
group by "Sales Channel"

-- 50. List all orders with the style 'JNE3697'
select *
FROM public.amazon_sales_data  
where "Style" = 'JNE3697'
