-- 1. Calculate the total sales amount for each product category in each state.
SELECT SUM("Amount") AS sales_amount, "Category", "ship-state"
FROM public.amazon_sales_data
GROUP BY "Category", "ship-state";


-- 2. Identify the top 10 products (ASINs) with the highest sales amount in each city.
SELECT 
	"ASIN", 
	"ship-city", 
	sales_amount
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
SELECT 
	AVG("Amount") AS sales_amount, 
	"Fulfilment", 
	"Courier Status"
FROM public.amazon_sales_data
GROUP BY 
	"Fulfilment", 
	"Courier Status";

-- 5. Determine the correlation between the quantity ordered and the sales amount for each product category.
SELECT 
	SUM("Qty") AS quantity, 
	SUM("Amount") AS sales_amount, 
	"Category",
	CORR("Qty", "Amount") AS correlation
FROM public.amazon_sales_data
GROUP BY 
	"Category"
ORDER BY 
	correlation DESC;

-- 6. List the top 5 states with the highest number of orders for each month.
WITH monthly_state_orders AS (
	SELECT 
	COUNT(*) AS order_count, 
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
GROUP BY 
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
SELECT 
	SUM("Amount") AS sales_amount,
	"Sales Channel"
FROM public.amazon_sales_data
WHERE 
	"promotion-ids" IS NOT NULL
GROUP BY "Sales Channel";

-- 8. Identify the top 3 sizes with the highest sales amount for each product category.
WITH category_sizes AS (
	SELECT 
	SUM("Amount") AS sales_amount, 
	"Size", 
	"Category"
FROM 
	public.amazon_sales_data
GROUP BY 
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
SELECT 
	"Size", 
	"Category", 
	sales_amount
FROM ranked_orders
WHERE 
	rank <= 3
ORDER BY  
	"Category", 
	rank;

-- 9. Calculate the average quantity ordered per order for each ship-service-level in each city.
SELECT 
	AVG("Qty") AS avg_qty, 
	"ship-service-level", 
	"ship-city"
FROM 
	public.amazon_sales_data
GROUP BY 
	"ship-service-level", 
	"ship-city";

-- 10. Find the total sales amount for each product category in each month.
SELECT 
	SUM("Amount") AS sales_amount,
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
GROUP BY 
	"Category",
	month,
	year;

-- 11. Identify the top 5 cities with the highest average sales amount per order for each fulfilment type.
WITH city_fulfilment AS(
	SELECT 
	AVG("Amount") AS avg_amount, 
	"ship-city", 
	"Fulfilment"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-city", 
	"Fulfilment"
),
ranked_amounts AS (
	SELECT 
	avg_amount, 
	"ship-city", 
	"Fulfilment",
	RANK() OVER (PARTITION BY "Fulfilment" ORDER BY avg_amount DESC) AS rank
	FROM city_fulfilment
)
SELECT 
	avg_amount, 
	"ship-city", 
	"Fulfilment",
	rank
FROM ranked_amounts
WHERE 
	rank <= 5
ORDER BY 
	"Fulfilment",
	rank;

-- 12. Calculate the total quantity of products sold for each combination of size and ship-country.
SELECT 
	SUM("Qty") AS total_qty,
	"Size", 
	"ship-country"
FROM public.amazon_sales_data
GROUP BY 
	"Size", 
	"ship-country";

-- 13. Determine the trend of the number of orders cancelled each month for each state.
SELECT 
    "ship-state", 
    EXTRACT(YEAR FROM normalized_date) AS year, 
    EXTRACT(MONTH FROM normalized_date) AS month, 
    COUNT(*) AS cancelled_orders
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
    normalized_date IS NOT NULL AND "Status" = 'Cancelled'
GROUP BY 
    "ship-state", 
    year, 
    month
ORDER BY 
    "ship-state", 
    year, 
    month;

-- 14. Find the top 3 product categories with the highest average sales amount in each city.
WITH category_city AS(
	SELECT AVG("Amount") AS avg_amounts,
	"Category", 
	"ship-city"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY
	"Category",
	"ship-city"
),
ranked_avgs AS (
	SELECT 
	avg_amounts,
	"Category", 
	"ship-city",
	RANK() OVER (PARTITION BY "ship-city" ORDER BY avg_amounts DESC) AS rank
	FROM category_city
)
SELECT 
	avg_amounts, 
	"Category", 
	"ship-city",
	rank
FROM 
	ranked_avgs
WHERE
	rank <= 3
ORDER BY 
	"ship-city",
	rank;

-- 15. Calculate the total sales amount for each courier status in each month of the year.
SELECT 
	SUM("Amount") AS sales_amount,
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
WHERE 
	"Amount" IS NOT NULL 
	AND "Courier Status" IS NOT NULL
GROUP BY 
	"Courier Status", 
	month, 
	year
ORDER BY 
	year,
	month;

-- 16. Identify the top 5 ASINs with the highest quantity sold in each ship-service-level.
WITH top_asins AS ( 
	SELECT
	SUM("Qty") AS qty_sold, 
	"ASIN", 
	"ship-service-level"
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" IS NOT NULL
GROUP BY 
	"ASIN", 
	"ship-service-level"
),
ranked_qtys AS (
	SELECT 
	qty_sold,
	"ASIN", 
	"ship-service-level",
	RANK() OVER (PARTITION BY "ship-service-level" ORDER BY qty_sold DESC) AS rank
	FROM top_asins
)
SELECT 
	qty_sold, 
	"ASIN", 
	"ship-service-level", 
	rank
FROM 
	ranked_qtys
WHERE 
	rank <= 5
ORDER BY 
	"ship-service-level", 
	rank;

-- 17. Calculate the average sales amount for each ship-postal-code for each state.
SELECT 
	AVG("Amount") AS avg_amount,
	"ship-postal-code", 
	"ship-state"
FROM 	
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL 
	AND "ship-postal-code" IS NOT NULL
	AND "ship-state" IS NOT NULL
GROUP BY 
	"ship-postal-code", 
	"ship-state"
ORDER BY 
	avg_amount DESC;


-- 18. Determine the top 5 cities with the lowest average sales amount per order for each courier status.
WITH top_cities AS (
	SELECT
	AVG("Amount") AS avg_amount,
	"ship-city",
	"Courier Status"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-city",
	"Courier Status"
),
ranked_orders AS (
	SELECT
	avg_amount,
	"ship-city",
	"Courier Status",
	RANK() OVER (PARTITION BY "Courier Status" ORDER BY avg_amount ASC) AS rank
	FROM top_cities
)
SELECT 
	avg_amount,
	"ship-city",
	"Courier Status",
	rank
FROM 
	ranked_orders
WHERE 
	rank <= 5
ORDER BY 
	"Courier Status", 
	rank;

-- 19. Find the total sales amount for each fulfilled-by type for each sales channel.
SELECT 
	SUM("Amount") AS sales_amount, 
	"Fulfilment", 
	"Sales Channel"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"Fulfilment", 
	"Sales Channel"
ORDER BY 
	sales_amount DESC;

-- 20. Calculate the total quantity of products sold for each ship-country in each month.
SELECT 
	SUM("Qty") AS total_qty, 
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
WHERE 
	"ship-country" IS NOT NULL
GROUP BY 
	"ship-country", 
	month, 
	year
ORDER BY 
	month, 
	year;

-- 21. Identify the top 3 states with the highest number of orders for each promotion-id.
WITH state_orders AS(
	SELECT 
	COUNT(*) AS order_count, 
	"ship-state", 
	"promotion-ids"
FROM 
	public.amazon_sales_data
GROUP BY 
	"ship-state", 
	"promotion-ids"
),
ranked_orders AS (
	SELECT
	order_count,
	"ship-state", 
	"promotion-ids",
	RANK() OVER (PARTITION BY "promotion-ids" ORDER BY order_count DESC) AS rank
	FROM state_orders
)
SELECT 
	order_count,
	"ship-state", 
	rank,
	"promotion-ids"
FROM 
	ranked_orders
WHERE 
	rank <= 3
ORDER BY  
	"promotion-ids", 
	rank;
	
-- 22. Calculate the average order amount for each combination of ship-service-level and sales channel.
SELECT 
	AVG("Amount") AS avg_amount, 
	"ship-service-level", 
	"Sales Channel"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-service-level", 
	"Sales Channel";

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
	order_count IS NOT NULL AND
	sales_amount IS NOT NULL
ORDER BY 
    "ship-state",
    year,
    month;

-- 24. Find the total sales amount for each ship-city for orders with a quantity greater than 5.
SELECT 
	SUM("Amount") AS sales_amount, 
	"ship-city", 
	SUM("Qty") AS total_qty
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" > 5 AND
	"Amount" IS NOT NULL
GROUP BY 
	"ship-city";

-- 25. Calculate the average quantity ordered per order for each product category in each month.
SELECT 
	AVG("Qty") AS avg_qty, 
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
WHERE 
	"Qty" IS NOT NULL
GROUP BY 
	"Category", 
	month, 
	year;

-- 26. Identify the top 5 ship-postal-codes with the highest total sales amount for each size.
WITH postal_orders AS(
	SELECT 
	SUM("Amount") AS total_amount, 
	"ship-postal-code", 
	"Size"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-postal-code", 
	"Size"
),
ranked_orders AS (
	SELECT
	total_amount,
	"ship-postal-code", 
	"Size",
	RANK() OVER (PARTITION BY "Size" ORDER BY total_amount DESC) AS rank
	FROM postal_orders
)
SELECT 
	total_amount,
	"ship-postal-code", 
	"Size", 
	rank
FROM 
	ranked_orders
WHERE 
	rank <= 5
ORDER BY 
	"Size", 
	rank;

-- 27. Calculate the average sales amount per order for each product category across different sales channels.
SELECT 
	AVG("Amount") AS avg_sales, 
	"Category", 
	"Sales Channel"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"Category", 
	"Sales Channel"
ORDER BY 
	avg_sales DESC;

-- 28. Find the total sales amount for each ASIN for orders shipped using 'Standard' service level.
SELECT 
	SUM("Amount") AS total_sales, 
	"ASIN"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL 
	AND "ship-service-level" = 'Standard'
GROUP BY 
	"ASIN";

-- 29. Calculate the average sales amount for each combination of ship-country and fulfilment type.
SELECT 
	AVG("Amount") AS avg_amount, 
	"ship-country", 
	"Fulfilment"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL 
GROUP BY
	"ship-country", 
	"Fulfilment";

-- 30. Identify the top 3 sizes with the highest average quantity ordered for each courier status.
WITH size_quantities AS(
	SELECT
	AVG("Qty") AS avg_qty, 
	"Size", 
	"Courier Status"
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" IS NOT NULL
GROUP BY 
	"Size", 
	"Courier Status"
),
ranked_orders AS (
	SELECT
	avg_qty,
	"Size",
	"Courier Status",
	RANK() OVER (PARTITION BY "Courier Status" ORDER BY avg_qty DESC) AS rank
	FROM size_quantities
)
SELECT
	avg_qty,
	"Size",
	"Courier Status",
	rank
FROM 
	ranked_orders
WHERE 
	rank <= 3;

-- 31. Find the total sales amount for orders with promotion-ids applied for each month.
SELECT 
	EXTRACT(MONTH FROM normalized_date) AS month,
	EXTRACT(YEAR FROM normalized_date) AS year,
	SUM("Amount") AS total_sales
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
WHERE 
	"Amount" IS NOT NULL AND
	"promotion-ids" IS NOT NULL
GROUP BY 
	month, 
	year
ORDER BY 
	total_sales DESC;

-- 32. Calculate the average order amount for each combination of ship-service-level and promotion-id.
SELECT 
	AVG("Amount") AS avg_amount, 
	"ship-service-level", 
	"promotion-ids"
FROM public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-service-level", 
	"promotion-ids"
ORDER BY avg_amount DESC;

-- 33. Determine the correlation between the average order amount and the number of orders for each status type.
WITH channel_corr AS (
	SELECT
	"Status",
	AVG("Amount") AS avg_amount,
	COUNT(*) AS order_count
FROM 
	public.amazon_sales_data
GROUP BY 
	"Status") 
SELECT
	CORR(avg_amount, order_count) AS correlation
FROM 
	channel_corr
ORDER BY 
	correlation DESC;

-- 34. Identify the top 5 states with the highest average sales amount per order for each ship-service-level.
WITH state_amounts AS (
	SELECT 
	"ship-state", 
	AVG("Amount") AS avg_amount, 
	"ship-service-level"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-state", 
	"ship-service-level"
),
ranked_orders AS (
	SELECT 
	"ship-state", 
	avg_amount, 
	"ship-service-level", 
	RANK() OVER (PARTITION BY "ship-service-level" ORDER BY avg_amount DESC) AS rank
	FROM 
	state_amounts
)
SELECT 
	"ship-state", 
	avg_amount, 
	"ship-service-level", 
	rank
FROM 
	ranked_orders
WHERE 
	rank <= 5;

-- 35. Calculate the total quantity of products sold for each ship-postal-code in each month.
SELECT 
	EXTRACT(MONTH FROM normalized_date) AS month,
	EXTRACT(YEAR FROM normalized_date) AS year,
	SUM("Qty") AS total_qty,
	"ship-postal-code"
FROM 
    (SELECT 
    "Qty",
	"ship-postal-code",
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
WHERE 
	"Qty" IS NOT NULL AND
	"ship-postal-code" IS NOT NULL
GROUP BY 
	month, 
	year,
	"ship-postal-code"
ORDER BY 
	total_qty DESC;

-- 36. Find the average sales amount for each combination of ship-city and sales channel.
SELECT 
	AVG("Amount") AS avg_amount, 
	"ship-city", 
	"Sales Channel"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-city", 
	"Sales Channel"
ORDER BY 
	avg_amount DESC;

-- 37. Analyze the distribution of the total quantity of products sold by size for each sales channel.
SELECT 
	SUM("Qty") AS total_qty, 
	"Size", 
	"Sales Channel"
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" IS NOT NULL
GROUP BY 
	"Size", 
	"Sales Channel";

-- 38. Identify the top 3 ship-countries with the highest total sales amount for each promotion-id.
WITH ship_orders AS(
	SELECT 
	SUM("Amount") AS total_sales,
	"ship-country", 
	"promotion-ids"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" >= 1
GROUP BY 
	"ship-country", 
	"promotion-ids"
),
ranked_orders AS (
	SELECT 
	total_sales, 
	"ship-country",
	"promotion-ids", 
	RANK() OVER (PARTITION BY "promotion-ids" ORDER BY total_sales DESC) AS rank
	FROM 
	ship_orders
)
SELECT 
	rank,
	total_sales, 
	"ship-country",
	"promotion-ids"
FROM 
	ranked_orders
WHERE 
	rank <= 3;

-- 39. Calculate the average quantity ordered per order for each fulfilment type in each city.
SELECT 
	AVG("Qty") AS avg_qty, 
	"Fulfilment", 
	"ship-city"
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" >= 1
GROUP BY 
	"Fulfilment", 
	"ship-city"
ORDER BY 
	avg_qty DESC;

-- 40. Find the total sales amount for each courier status for each SKU.
SELECT 
	SUM("Amount") AS total_sales, 
	"Courier Status", 
	"SKU"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"Courier Status", 
	"SKU"
ORDER BY 
	total_sales DESC;

-- 41. Calculate the average sales amount for each combination of size and ship-state.
SELECT 
	AVG("Amount") AS avg_amount, 
	"Size", 
	"ship-state"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"Size", 
	"ship-state"
ORDER BY 
	avg_amount DESC;

-- 42. Identify the top 5 ASINs with the highest average sales amount for each ship-service-level.
WITH top_asins AS(
	SELECT 
	AVG("Amount") AS avg_amount,
	"ASIN", 
	"ship-service-level"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" >= 1
GROUP BY 
	"ASIN", 
	"ship-service-level"
),
ranked_asins AS (
	SELECT 
	avg_amount,
	"ASIN", 
	"ship-service-level",
	RANK() OVER (PARTITION BY "ship-service-level" ORDER BY avg_amount DESC) AS rank
	FROM 
	top_asins
)
SELECT 
	rank, 
	avg_amount,
	"ASIN", 
	"ship-service-level"
FROM 
	ranked_asins
WHERE 
	rank <= 5;

-- 43. Determine the correlation between the total quantity and the total sales amount for each state.
WITH service_corr AS (
	SELECT 
	SUM("Qty") AS total_qty,
	SUM("Amount") AS total_sales,
	"ship-state"
FROM 
	public.amazon_sales_data
GROUP BY 
	"ship-state"
)
SELECT 
	CORR(total_qty, total_sales) AS correlation
FROM 
	service_corr
ORDER BY 
	correlation DESC;

-- 44. Calculate the total quantity of products sold for each ship-country for each product category.
SELECT 
	SUM("Qty") AS total_qty, 
	"ship-country", 
	"Category"
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" >= 1
GROUP BY 
	"ship-country", 
	"Category";

-- 45. Find the average sales amount for each combination of ship-city and fulfilment type.
SELECT 
	AVG("Amount") AS avg_amount, 
	"ship-city", 
	"Fulfilment"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL
GROUP BY 
	"ship-city", 
	"Fulfilment"
ORDER BY "ship-city" ASC;

-- 46. Identify the top 3 states with the highest number of orders for each combination of ship-service-level and courier status.
WITH state_orders AS(
	SELECT
	COUNT(*) AS order_count,
	"ship-state",
	"ship-service-level",
	"Courier Status"
FROM 
	public.amazon_sales_data
GROUP BY 
	"ship-state",
	"ship-service-level",
	"Courier Status"
),
ranked_orders AS (
	SELECT
	order_count,
	"ship-state",
	"ship-service-level",
	"Courier Status",
	RANK() OVER (PARTITION BY "ship-service-level", "Courier Status" ORDER BY order_count DESC) AS rank
	FROM 
	state_orders
)
SELECT 
	order_count,
	"ship-service-level",
	"Courier Status",
	"ship-state",
	rank
FROM 
	ranked_orders
WHERE 
	rank <= 3;

-- 47. Calculate the total sales amount for each promotion-id for orders shipped using 'Expedited' service level.
SELECT 
	SUM("Amount") AS total_sales, 
	"promotion-ids"
FROM 
	public.amazon_sales_data
WHERE 
	"ship-service-level" = 'Expedited' AND
	"promotion-ids" IS NOT NULL
GROUP BY 
	"promotion-ids"
ORDER BY 
	total_sales DESC;

-- 48. Determine the trend of the number of orders with promotion-ids applied for each ship-country.
SELECT 
    "ship-country", 
    EXTRACT(YEAR FROM normalized_date) AS year, 
    EXTRACT(MONTH FROM normalized_date) AS month, 
    COUNT(*) AS promotion_orders
FROM 
    (SELECT 
    "ship-country", 
	"promotion-ids",   
        CASE 
            WHEN LENGTH("Date") = 8 THEN TO_DATE("Date", 'MM-DD-YY')
            WHEN LENGTH("Date") = 10 THEN TO_DATE("Date", 'MM-DD-YYYY')
            ELSE NULL
        END AS normalized_date
    FROM public.amazon_sales_data) AS subquery
WHERE 
    normalized_date IS NOT NULL AND 
	"promotion-ids" IS NOT NULL AND
	"ship-country" IS NOT NULL
GROUP BY 
    "ship-country", 
    year, 
    month
ORDER BY 
    "ship-country", 
    year, 
    month;

-- 49. Find the average quantity ordered per order for each ship-state for each sales channel.
SELECT 
	AVG("Qty") AS avg_qty, 
	"ship-state", 
	"Sales Channel"
FROM 
	public.amazon_sales_data
WHERE 
	"Qty" >= 1
GROUP BY 
	"ship-state", 
	"Sales Channel"
ORDER BY 
	avg_qty DESC;

-- 50. Calculate the total sales amount for each ship-service-level for orders with a status of 'Shipped - Delivered to Buyer'.
SELECT 
	SUM("Amount") AS total_sales, 
	"ship-service-level"
FROM 
	public.amazon_sales_data
WHERE 
	"Amount" IS NOT NULL AND 
	"Status" = 'Shipped - Delivered to Buyer'
GROUP BY 
	"ship-service-level"
ORDER BY 
	total_sales DESC;
