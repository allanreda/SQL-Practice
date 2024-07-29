-- 1. Calculate the total sales amount for each fulfilment type.
select sum("Amount") as sales_amount, "Fulfilment"
FROM public.amazon_sales_data  
group by "Fulfilment"

-- 2. Find the top 5 cities with the highest number of orders.
select count(*), "ship-city"
FROM public.amazon_sales_data  
group by "ship-city"
order by count(*) desc
limit 5

-- 3. Calculate the average quantity ordered for each product category.
select avg("Qty") as avg_qty, "Category"
FROM public.amazon_sales_data  
where "Status" != 'Cancelled'
group by "Category"

-- 4. List all orders that were shipped using 'Expedited' service level.
select *
FROM public.amazon_sales_data  
where "ship-service-level" = 'Expedited' and "Status" != 'Cancelled'

-- 5. Count the number of orders that have a promotion applied.
select count(*)
FROM public.amazon_sales_data  
where "promotion-ids" is not null

-- 6. Find the total sales amount for each sales channel.
select sum("Amount") as sales_amount, "Sales Channel"
FROM public.amazon_sales_data  
group by "Sales Channel"

-- 7. Identify the ASIN with the highest total sales amount.
select sum("Amount") as sales_amount, "ASIN"
FROM public.amazon_sales_data  
where "Amount" is not null
group by "ASIN"
order by sales_amount desc
limit 1

-- 8. Calculate the total quantity of products sold for each size.
select sum("Qty") as sold_products, "Size"
FROM public.amazon_sales_data  
group by "Size"
order by sold_products desc

-- 9. List all orders where the 'Courier Status' is not 'Shipped'.
select *
FROM public.amazon_sales_data  
where "Courier Status" != 'Shipped'

-- 10. Find the average sales amount for orders shipped to each city.
select avg("Amount") as avg_amount, "ship-city"
FROM public.amazon_sales_data  
where "Amount" is not null
group by "ship-city"
order by avg_amount desc

-- 11. Calculate the total sales amount for each date.
select sum("Amount") as sales_amount, "Date"
FROM public.amazon_sales_data  
group by "Date"

-- 12. Identify the month with the highest number of orders.
select 
	count(*) as order_count, 
    extract(month from normalized_date) as order_month,
    extract(year from normalized_date) as order_year
FROM 
    (SELECT 
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
group by order_month, order_year
order by order_count desc

-- 13. List all orders where the quantity ordered is less than 5.
select *
FROM public.amazon_sales_data  
where "Qty" < 5

-- 14. Calculate the average order amount for each fulfilment type.
select count("Amount") as sales_amount, "Fulfilment"
FROM public.amazon_sales_data  
group by "Fulfilment"

-- 15. Find the top 3 states with the highest average sales amount per order.
select avg("Amount") avg_amount, "ship-state"
FROM public.amazon_sales_data  
where "Amount" is not null and "ship-state" is not null
group by "ship-state"
order by "ship-state" desc

-- 16. Count the number of orders with a status of 'Cancelled' for each state.
-- 17. Calculate the total sales amount for orders with a promotion applied.
-- 18. Find the most frequently ordered size.
-- 19. List all orders that were fulfilled by 'Merchant'.
-- 20. Calculate the average sales amount for each 'ship-service-level'.
-- 21. Identify the top 5 products with the highest quantity sold.
-- 22. Calculate the total sales amount for each courier status.
-- 23. Find the state with the highest number of 'Cancelled' orders.
-- 24. List all orders where the promotion-ids contain more than one promotion.
-- 25. Calculate the total quantity of products sold for each sales channel.
-- 26. Identify the product category with the lowest average sales amount.
-- 27. Find the total sales amount for orders shipped in the month of April.
-- 28. Calculate the average order amount for orders with a quantity of 1.
-- 29. List all orders where the 'Size' is not specified.
-- 30. Find the total sales amount for each 'ship-country'.
-- 31. Calculate the average quantity ordered for orders with a 'Shipped' status.
-- 32. Identify the top 3 ASINs with the highest average sales amount.
-- 33. Count the number of orders for each 'ship-service-level'.
-- 34. Calculate the total sales amount for each 'ship-city' in 'MAHARASHTRA'.
-- 35. Find the total quantity of products sold for each 'fulfilled-by' type.
-- 36. List all orders where the 'Sales Channel' is 'Amazon.in' and the 'Status' is 'Cancelled'.
-- 37. Calculate the average sales amount for each 'promotion-id'.
-- 38. Identify the state with the highest average quantity ordered per order.
-- 39. Find the total sales amount for orders shipped to each postal code.
-- 40. Calculate the total sales amount for orders with a sales amount greater than 1000.
-- 41. List all orders where the 'Style' is not null.
-- 42. Count the number of orders shipped to 'KARNATAKA' with a 'Shipped' status.
-- 43. Calculate the average sales amount for each 'Category' in 'TELANGANA'.
-- 44. Identify the month with the lowest total sales amount.
-- 45. Find the total quantity of products sold for each 'ship-postal-code'.
-- 46. Calculate the average order amount for orders with a quantity greater than 5.
-- 47. List all orders where the 'Category' is 'kurta' and the 'Size' is 'M'.
-- 48. Calculate the total sales amount for orders with a 'Shipped' status and 'Courier Status' is 'Delivered to Buyer'.
-- 49. Identify the top 3 sales channels with the highest total sales amount.
-- 50. Find the average quantity ordered for each 'ASIN' in 'MUMBAI'.
