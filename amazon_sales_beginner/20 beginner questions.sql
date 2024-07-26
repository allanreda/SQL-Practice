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
AND "Courier Status" = 'Shipped'

-- 6. Calculate the average order amount.
SELECT AVG("Amount")
FROM public.amazon_sales_data

-- 7. Count the number of orders for each product category.
select "Category", count(*) as product_category
from public.amazon_sales_data
group by "Category"

-- 8. Identify the state with the most orders shipped.
select "ship-state", count(*) as orders_shipped
from public.amazon_sales_data
where "Courier Status" = 'Shipped'
group by "ship-state"
order by count(*) desc
limit 1

-- 9. List all orders where the quantity ordered is greater than 10.
select *
from public.amazon_sales_data
where "Qty" > 10

-- 10. Find the total sales amount for each currency.
select "currency", sum("Amount") as sales_amount
from public.amazon_sales_data
group by "currency"

-- 11. Retrieve the first 5 records from the table.
select *
from public.amazon_sales_data
limit 5

-- 12. Count the number of unique products sold.
select count(distinct("SKU")) as unique_products
from public.amazon_sales_data

-- 13. Find the order with the highest sales amount.
SELECT * 
FROM public.amazon_sales_data 
WHERE "Amount" IS NOT NULL
ORDER BY "Amount" DESC
LIMIT 1

-- 14. List all distinct sales channels.
select distinct("Sales Channel") 
FROM public.amazon_sales_data  

-- 15. Count the number of orders with a status of 'Cancelled'.
select count(*) as cancelled_orders
FROM public.amazon_sales_data  
where "Status" = 'Cancelled'

-- 16. Calculate the total number of products sold (sum of quantities).
select sum("Qty") as total_products_sold
FROM public.amazon_sales_data  

-- 17. Find the average quantity ordered per order.
select avg("Qty") as average_quantity
FROM public.amazon_sales_data  
where "Status" != 'Cancelled'

-- 18. List all orders with a sales amount greater than 500.
select * 
FROM public.amazon_sales_data  
where "Amount" > 500

-- 19. Retrieve the top 5 most frequently ordered products.
select count(*), "SKU"
FROM public.amazon_sales_data  
group by "SKU"
order by count desc
limit 5

-- 20. Find the number of orders shipped by each fulfilment type.
select count(*), "Fulfilment"
FROM public.amazon_sales_data  
group by "Fulfilment"



