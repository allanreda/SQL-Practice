-- 1. Calculate the total sales amount for each product category in each state.
SELECT SUM("Amount") AS sales_amount, "Category", "ship-state"
FROM public.amazon_sales_data
GROUP BY "Category", "ship-state";


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
    month;

-- 4. Calculate the average sales amount per order for each combination of fulfilment type and courier status.
select 
	avg("Amount") as sales_amount, 
	"Fulfilment", 
	"Courier Status"
FROM public.amazon_sales_data
group by 
	"Fulfilment", 
	"Courier Status";

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
	correlation desc;

-- 6. List the top 5 states with the highest number of orders for each month.
WITH monthly_state_orders AS (
	select 
	count(*) as order_count, 
    "ship-state", 
    EXTRACT(YEAR FROM normalized_date) AS year, 
    EXTRACT(MONTH FROM normalized_date) AS month
FROM 
    (SELECT 
        "ship-state",
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
group by 
	"ship-state", 
	month, 
	year),	
ranked_orders AS (
    SELECT 
        "ship-state", 
        year, 
        month, 
        order_count,
        RANK() OVER (PARTITION BY year, month ORDER BY order_count DESC) AS rank
    FROM 
        monthly_state_orders
)
SELECT 
    "ship-state", 
    year, 
    month, 
    order_count
FROM 
    ranked_orders
WHERE 
    rank <= 5
ORDER BY 
    year, 
    month, 
    rank;

-- 7. Calculate the total sales amount for orders with promotion-ids applied for each sales channel.
select 
	sum("Amount") as sales_amount,
	"Sales Channel"
FROM public.amazon_sales_data
where 
	"promotion-ids" is not null
group by "Sales Channel";

-- 8. Identify the top 3 sizes with the highest sales amount for each product category.
with category_sizes as (
	select 
	sum("Amount") as sales_amount, 
	"Size", 
	"Category"
FROM 
	public.amazon_sales_data
group by 
	"Size", 
	"Category"
),
ranked_orders AS (
    SELECT 
	"Size", 
	"Category", 
	sales_amount,
        RANK() OVER (PARTITION BY "Category" ORDER BY sales_amount DESC) AS rank
    FROM 
        category_sizes
)
select 
	"Size", 
	"Category", 
	sales_amount
from ranked_orders
where 
	rank <= 3
order by  
	"Category", 
	rank;

-- 9. Calculate the average quantity ordered per order for each ship-service-level in each city.
select 
	avg("Qty") as avg_qty, 
	"ship-service-level", 
	"ship-city"
FROM 
	public.amazon_sales_data
group by 
	"ship-service-level", 
	"ship-city";

-- 10. Find the total sales amount for each product category in each month.
select 
	sum("Amount") as sales_amount,
	"Category",
	EXTRACT(MONTH FROM normalized_date) AS month,
	EXTRACT(YEAR FROM normalized_date) AS year
FROM 
    (SELECT 
        "Amount", 
        "Category",
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
group by 
	"Category",
	month,
	year;

-- 11. Identify the top 5 cities with the highest average sales amount per order for each fulfilment type.
with city_fulfilment as(
	select 
	avg("Amount") as avg_amount, 
	"ship-city", 
	"Fulfilment"
FROM 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"ship-city", 
	"Fulfilment"
),
ranked_amounts as (
	select 
	avg_amount, 
	"ship-city", 
	"Fulfilment",
	rank() over (partition by "Fulfilment" order by avg_amount desc) as rank
	from city_fulfilment
)
select 
	avg_amount, 
	"ship-city", 
	"Fulfilment",
	rank
from ranked_amounts
where 
	rank <= 5
order by 
	"Fulfilment",
	rank;

-- 12. Calculate the total quantity of products sold for each combination of size and ship-country.
select 
	sum("Qty") as total_qty,
	"Size", 
	"ship-country"
from public.amazon_sales_data
group by 
	"Size", 
	"ship-country";

-- 13. Determine the trend of the number of orders cancelled each month for each state.
SELECT 
    "ship-state", 
    EXTRACT(YEAR FROM normalized_date) AS year, 
    EXTRACT(MONTH FROM normalized_date) AS month, 
    count(*) as cancelled_orders
FROM 
    (SELECT 
    "ship-state", 
	"Status",   
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
WHERE 
    normalized_date IS NOT NULL and "Status" = 'Cancelled'
GROUP BY 
    "ship-state", 
    year, 
    month
ORDER BY 
    "ship-state", 
    year, 
    month;

-- 14. Find the top 3 product categories with the highest average sales amount in each city.
with category_city as(
	select avg("Amount") as avg_amounts,
	"Category", 
	"ship-city"
FROM 
	public.amazon_sales_data
where 
	"Amount" is not null
group by
	"Category",
	"ship-city"
),
ranked_avgs as (
	select 
	avg_amounts,
	"Category", 
	"ship-city",
	rank() over (partition by "ship-city" order by avg_amounts desc) as rank
from category_city
)
select 
	avg_amounts, 
	"Category", 
	"ship-city",
	rank
from 
	ranked_avgs
where
	rank <= 3
order by 
	"ship-city",
	rank;

-- 15. Calculate the total sales amount for each courier status in each month of the year.
select 
	sum("Amount") as sales_amount,
	"Courier Status", 
	EXTRACT(YEAR FROM normalized_date) AS year, 
    EXTRACT(MONTH FROM normalized_date) AS month
FROM 
    (SELECT 
    "Amount", 
	"Courier Status",   
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
where 
	"Amount" is not null 
	and "Courier Status" is not null
group by 
	"Courier Status", 
	month, 
	year
order by 
	year,
	month;

-- 16. Identify the top 5 ASINs with the highest quantity sold in each ship-service-level.
with top_asins as ( 
	select
	sum("Qty") as qty_sold, 
	"ASIN", 
	"ship-service-level"
FROM 
	public.amazon_sales_data
where 
	"Qty" is not null
group by 
	"ASIN", 
	"ship-service-level"
),
ranked_qtys as (
	select 
	qty_sold,
	"ASIN", 
	"ship-service-level",
	rank() over (partition by "ship-service-level" order by qty_sold desc) as rank
from top_asins
)
select 
	qty_sold, 
	"ASIN", 
	"ship-service-level", 
	rank
from 
	ranked_qtys
where 
	rank <= 5
order by 
	"ship-service-level", 
	rank;

-- 17. Calculate the average sales amount for each ship-postal-code for each state.
select 
	avg("Amount") as avg_amount,
	"ship-postal-code", 
	"ship-state"
from 	
	public.amazon_sales_data
where 
	"Amount" is not null 
	and "ship-postal-code" is not null
	and "ship-state" is not null
group by 
	"ship-postal-code", 
	"ship-state"
order by 
	avg_amount desc


-- 18. Determine the top 5 cities with the lowest average sales amount per order for each courier status.
with top_cities as (
	select
	avg("Amount") as avg_amount,
	"ship-city",
	"Courier Status"
FROM 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"ship-city",
	"Courier Status"
),
ranked_orders as (
	select
	avg_amount,
	"ship-city",
	"Courier Status",
	rank() over (partition by "Courier Status" order by avg_amount asc) as rank
from top_cities
)
select 
	avg_amount,
	"ship-city",
	"Courier Status",
	rank
from 
	ranked_orders
where 
	rank <= 5
order by 
	"Courier Status", 
	rank;

-- 19. Find the total sales amount for each fulfilled-by type for each sales channel.
select 
	sum("Amount") as sales_amount, 
	"Fulfilment", 
	"Sales Channel"
from 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"Fulfilment", 
	"Sales Channel"
order by 
	sales_amount desc;

-- 20. Calculate the total quantity of products sold for each ship-country in each month.
select 
	sum("Qty") as total_qty, 
	"ship-country",
    EXTRACT(MONTH FROM normalized_date) AS month,
	EXTRACT(YEAR FROM normalized_date) AS year
FROM 
    (SELECT 
    "Qty", 
	"ship-country",   
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery 
where 
	"ship-country" is not null
group by 
	"ship-country", 
	month, 
	year
order by 
	month, 
	year;

-- 21. Identify the top 3 states with the highest number of orders for each promotion-id.
with state_orders as(
	select 
	count(*) as order_count, 
	"ship-state", 
	"promotion-ids"
from 
	public.amazon_sales_data
group by 
	"ship-state", 
	"promotion-ids"
),
ranked_orders as (
	select
	order_count,
	"ship-state", 
	"promotion-ids",
	rank() over (partition by "promotion-ids" order by order_count desc) as rank
from state_orders
)
select 
	order_count,
	"ship-state", 
	rank,
	"promotion-ids"
from 
	ranked_orders
where 
	rank <= 3
order by  
	"promotion-ids", 
	rank;
	
-- 22. Calculate the average order amount for each combination of ship-service-level and sales channel.
select 
	avg("Amount") as avg_amount, 
	"ship-service-level", 
	"Sales Channel"
from 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"ship-service-level", 
	"Sales Channel"

-- 23. Determine the correlation between the number of orders and the total sales amount for each month in each state.
WITH monthly_data AS (
    SELECT 
        "ship-state",
        EXTRACT(MONTH FROM normalized_date) AS month,
        EXTRACT(YEAR FROM normalized_date) AS year,
        COUNT(*) AS order_count,
        SUM("Amount") AS sales_amount
    FROM (
        SELECT 
            "Amount",
            "ship-state",
            CASE 
                WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
                WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
                ELSE NULL
            END AS normalized_date
        FROM public.amazon_sales_data
    ) AS base_data
    WHERE normalized_date IS NOT NULL
    GROUP BY 
        "ship-state", 
        EXTRACT(MONTH FROM normalized_date),
        EXTRACT(YEAR FROM normalized_date)
)
SELECT 
    "ship-state",
    month,
    year,
    order_count,
    sales_amount,
    CORR(order_count, sales_amount) OVER (PARTITION BY "ship-state") AS correlation
FROM 
    monthly_data
WHERE 
	order_count is not null and
	sales_amount is not null
ORDER BY 
    "ship-state",
    year,
    month;

-- 24. Find the total sales amount for each ship-city for orders with a quantity greater than 5.
select 
	sum("Amount") as sales_amount, 
	"ship-city", 
	sum("Qty") as total_qty
from 
	public.amazon_sales_data
where 
	"Qty" > 5 and
	"Amount" is not null
group by 
	"ship-city";

-- 25. Calculate the average quantity ordered per order for each product category in each month.
select 
	avg("Qty") as avg_qty, 
	"Category", 
	EXTRACT(MONTH FROM normalized_date) AS month,
	EXTRACT(YEAR FROM normalized_date) AS year
FROM 
    (SELECT 
    "Qty", 
	"Category",   
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
where 
	"Qty" is not null
group by 
	"Category", 
	month, 
	year;

-- 26. Identify the top 5 ship-postal-codes with the highest total sales amount for each size.
with postal_orders as(
	select 
	sum("Amount") as total_amount, 
	"ship-postal-code", 
	"Size"
from 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"ship-postal-code", 
	"Size"
),
ranked_orders as (
	select
	total_amount,
	"ship-postal-code", 
	"Size",
	rank() over (partition by "Size" order by total_amount desc) as rank
from 
	postal_orders
)
select 
	total_amount,
	"ship-postal-code", 
	"Size", 
	rank
from 
	ranked_orders
where 
	rank <= 5
order by 
	"Size", 
	rank;

-- 27. Calculate the average sales amount per order for each product category across different sales channels.
select 
	avg("Amount") as avg_sales, 
	"Category", 
	"Sales Channel"
from 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"Category", 
	"Sales Channel"
order by 
	avg_sales desc;

-- 28. Find the total sales amount for each ASIN for orders shipped using 'Standard' service level.
select 
	sum("Amount") as total_sales, 
	"ASIN"
from 
	public.amazon_sales_data
where 
	"Amount" is not null 
	and "ship-service-level" = 'Standard'
group by 
	"ASIN";

-- 29. Calculate the average sales amount for each combination of ship-country and fulfilment type.
select 
	avg("Amount") as avg_amount, 
	"ship-country", 
	"Fulfilment"
from 
	public.amazon_sales_data
where 
	"Amount" is not null 
group by
	"ship-country", 
	"Fulfilment";

-- 30. Identify the top 3 sizes with the highest average quantity ordered for each courier status.
with size_quantities as(
	select
	avg("Qty") as avg_qty, 
	"Size", 
	"Courier Status"
from 
	public.amazon_sales_data
where 
	"Qty" is not null
group by 
	"Size", 
	"Courier Status"
),
ranked_orders as (
	select
	avg_qty,
	"Size",
	"Courier Status",
	rank() over (partition by "Courier Status" order by avg_qty desc) as rank
from 
	size_quantities
)
select
	avg_qty,
	"Size",
	"Courier Status",
	rank
from 
	ranked_orders
where 
	rank <= 3

-- 31. Find the total sales amount for orders with promotion-ids applied for each month.
select 
	EXTRACT(MONTH FROM normalized_date) AS month,
	EXTRACT(YEAR FROM normalized_date) AS year,
	sum("Amount") as total_sales
FROM 
    (SELECT 
    "Amount",
	"promotion-ids",
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
where 
	"Amount" is not null and
	"promotion-ids" is not null
group by 
	month, 
	year
order by 
	total_sales desc;

-- 32. Calculate the average order amount for each combination of ship-service-level and promotion-id.
select 
	avg("Amount") as avg_amount, 
	"ship-service-level", 
	"promotion-ids"
FROM public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"ship-service-level", 
	"promotion-ids"
order by avg_amount desc;

-- 33. Determine the correlation between the average order amount and the number of orders for each status type.
with channel_corr as (
	select
	"Status",
	avg("Amount") as avg_amount,
	count(*) as order_count
FROM 
	public.amazon_sales_data
group by 
	"Status") 
select
	CORR(avg_amount, order_count) AS correlation
from 
	channel_corr
order by 
	correlation desc;

-- 34. Identify the top 5 states with the highest average sales amount per order for each ship-service-level.
with state_amounts as (
	select 
	"ship-state", 
	avg("Amount") as avg_amount, 
	"ship-service-level"
from 
	public.amazon_sales_data
where 
	"Amount" is not null
group by 
	"ship-state", 
	"ship-service-level"
),
ranked_orders as (
	select 
	"ship-state", 
	avg_amount, 
	"ship-service-level", 
	rank() over (partition by "ship-service-level" order by avg_amount desc) as rank
from 
	state_amounts
)
select 
	"ship-state", 
	avg_amount, 
	"ship-service-level", 
	rank
from 
	ranked_orders
where 
	rank <= 5


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
