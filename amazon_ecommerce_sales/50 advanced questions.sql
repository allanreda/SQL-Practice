-- 1. Calculate the total sales amount for each product category in each state.
SELECT SUM("Amount") AS sales_amount, "Category", "ship-state"
FROM public.amazon_sales_data
GROUP BY "Category", "ship-state"


-- 2. Identify the top 10 products (ASINs) with the highest sales amount in each city.
SELECT "ASIN", "ship-city", sales_amount
FROM (
    SELECT 
        "ASIN", 
        "ship-city", 
        SUM("Amount") AS sales_amount,
        RANK() OVER (PARTITION BY "ship-city" ORDER BY SUM("Amount") DESC) AS rank
    FROM public.amazon_sales_data
    WHERE "Amount" IS NOT NULL
    GROUP BY "ASIN", "ship-city"
) AS ranked_sales
WHERE rank <= 10
ORDER BY "ship-city", rank;

-- 3. Find the monthly trend of total sales amount for each fulfilment type.
SELECT 
    "Fulfilment", 
    EXTRACT(YEAR FROM normalized_date) AS year, 
    EXTRACT(MONTH FROM normalized_date) AS month, 
    SUM("Amount") AS total_sales_amount
FROM 
    (SELECT 
        "Amount", 
        "Fulfilment",
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
WHERE 
    normalized_date IS NOT NULL
GROUP BY 
    "Fulfilment", 
    year, 
    month
ORDER BY 
    "Fulfilment", 
    year, 
    month

-- 4. Calculate the average sales amount per order for each combination of fulfilment type and courier status.
select 
	avg("Amount") as sales_amount, 
	"Fulfilment", 
	"Courier Status"
FROM public.amazon_sales_data
group by 
	"Fulfilment", 
	"Courier Status"

-- 5. Determine the correlation between the quantity ordered and the sales amount for each product category.
select 
	sum("Qty") as quantity, 
	sum("Amount") as sales_amount, 
	"Category",
	CORR("Qty", "Amount") AS correlation
FROM public.amazon_sales_data
group by 
	"Category"
order by 
	correlation desc

-- 6. List the top 5 states with the highest number of orders for each month.
-- 7. Calculate the total sales amount for orders with promotion-ids applied for each sales channel.
-- 8. Identify the top 3 sizes with the highest sales amount for each product category.
-- 9. Calculate the average quantity ordered per order for each ship-service-level in each city.
-- 10. Find the total sales amount for orders shipped in each quarter of the year.
-- 11. Identify the top 5 cities with the highest average sales amount per order for each fulfilment type.
-- 12. Calculate the total quantity of products sold for each combination of size and ship-country.
-- 13. Determine the trend of the number of orders cancelled each month for each state.
-- 14. Find the top 3 product categories with the highest average sales amount in each city.
-- 15. Calculate the total sales amount for each courier status in each month of the year.
-- 16. Identify the top 5 ASINs with the highest quantity sold in each ship-service-level.
-- 17. Calculate the average sales amount for each ship-postal-code for each state.
-- 18. Determine the top 5 cities with the lowest average sales amount per order for each courier status.
-- 19. Find the total sales amount for each fulfilled-by type for each sales channel.
-- 20. Calculate the total quantity of products sold for each ship-country in each quarter.
-- 21. Identify the top 3 states with the highest number of orders for each promotion-id.
-- 22. Calculate the average order amount for each combination of ship-service-level and sales channel.
-- 23. Determine the correlation between the number of orders and the total sales amount for each month in each state.
-- 24. Find the total sales amount for each ship-city for orders with a quantity greater than 5.
-- 25. Calculate the average quantity ordered per order for each product category in each month.
-- 26. Identify the top 5 ship-postal-codes with the highest total sales amount for each size.
-- 27. Determine the trend of the average sales amount per order for each sales channel over the past year.
-- 28. Find the total sales amount for each ASIN for orders shipped using 'Standard' service level.
-- 29. Calculate the average sales amount for each combination of ship-country and fulfilment type.
-- 30. Identify the top 3 sizes with the highest average quantity ordered for each courier status.
-- 31. Find the total sales amount for orders with promotion-ids applied for each month.
-- 32. Calculate the average order amount for each combination of ship-service-level and promotion-id.
-- 33. Determine the correlation between the fulfilment type and the courier status for each state.
-- 34. Identify the top 5 states with the highest average sales amount per order for each ship-service-level.
-- 35. Calculate the total quantity of products sold for each ship-postal-code in each month.
-- 36. Find the average sales amount for each combination of ship-city and sales channel.
-- 37. Determine the trend of the total quantity of products sold for each product category over the past year.
-- 38. Identify the top 3 ship-countries with the highest total sales amount for each promotion-id.
-- 39. Calculate the average quantity ordered per order for each fulfilment type in each city.
-- 40. Find the total sales amount for each courier status in each quarter of the year.
-- 41. Calculate the average sales amount for each combination of size and ship-state.
-- 42. Identify the top 5 ASINs with the highest average sales amount for each ship-service-level.
-- 43. Determine the correlation between the ship-service-level and the total sales amount for each state.
-- 44. Calculate the total quantity of products sold for each ship-country for each product category.
-- 45. Find the average sales amount for each combination of ship-city and fulfilment type.
-- 46. Identify the top 3 states with the highest number of orders for each combination of ship-service-level and courier status.
-- 47. Calculate the total sales amount for each promotion-id for orders shipped using 'Expedited' service level.
-- 48. Determine the trend of the number of orders with promotion-ids applied for each ship-country.
-- 49. Find the average quantity ordered per order for each ship-state for each sales channel.
-- 50. Calculate the total sales amount for each ship-service-level for orders with a status of 'Shipped - Delivered to Buyer'.
