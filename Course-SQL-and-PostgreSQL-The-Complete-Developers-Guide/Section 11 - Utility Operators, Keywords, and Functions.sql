-- 121. The Greatest Value in a List
SELECT GREATEST(200, 10, 30);

SELECT name, weight, GREATEST(30, 2 * weight)
FROM products;

-- 122. And the Least Value in a List!
SELECT LEAST(1000, 20, 50, 100);

SELECT name, price, LEAST(price * 0.5, 400)
FROM products;

-- 123. The Case Keyword
SELECT 
	name,
	price,
	CASE
		WHEN price > 600 THEN 'high'
		WHEN price > 300 THEN 'medium'
		ELSE 'cheap'
	END
FROM products;

SELECT 
	name,
	price,
	CASE
		WHEN price > 600 THEN 'high'
		WHEN price > 300 THEN 'medium'
	END
FROM products;