-- 93. What's a Subquery?
SELECT name, price
FROM products
WHERE price > (
	SELECT MAX(price)
	FROM products
	WHERE department = 'Toys'
);

-- 95. Subqueries in a Select
SELECT MAX(price)
FROM products;

SELECT name, price, (
	SELECT MAX(price)
	FROM products
)
FROM products
WHERE price > 867;

SELECT price
FROM products
WHERE id=3;

SELECT name, price, (
	SELECT price
	FROM products
	WHERE id=3
) AS id_3_price
FROM products
WHERE price > 867;

-- Coding Exercise 19: Embedding in Select
SELECT name, price, price / (SELECT MAX(price) FROM phones) AS price_ratio 
FROM phones;

-- 98. Subqueries in a From
SELECT name, price / weight AS price_weight_ratio
FROM products;


SELECT name, price_weight_ratio
FROM (
	SELECT name, price / weight AS price_weight_ratio
	FROM products
) AS p
WHERE price_weight_ratio > 5;

-- 99. From Subqueries that Return a Value
SELECT MAX(price)
FROM products;

SELECT *
FROM (
	SELECT MAX(price)
	FROM products
) AS p;

-- 100. Example of a Subquery in a From
SELECT user_id, COUNT(*)
FROM orders
GROUP BY user_id;

SELECT AVG(p.order_count)
FROM (
	SELECT user_id, COUNT(*) AS order_count
	FROM orders
	GROUP BY user_id
) AS p

-- Coding Exercise 20: Subquery From's
SELECT MAX(p.avg_price) AS max_average_price
FROM (
    SELECT AVG(price) AS avg_price, manufacturer
    FROM phones
    GROUP BY manufacturer
) AS p;

-- 103. Subqueries in a Join Clause
SELECT user_id
FROM orders
WHERE product_id = 3;

SELECT first_name
FROM users
JOIN (
	SELECT user_id
	FROM orders
	WHERE product_id = 3
) AS o
ON o.user_id = users.id;

-- 104. More Useful - Subqueries with Where
SELECT id
FROM products
WHERE price / weight > 5;

SELECT id
FROM orders
WHERE product_id IN (
	SELECT id
	FROM products
	WHERE price / weight > 50
);

-- 105. Data Structure with Where Subqueries
SELECT name
FROM products
WHERE price > (
	SELECT AVG(price)
	FROM products
);

-- Coding Exercise 21: Subquery Where's
SELECT name, price
FROM phones
WHERE price > (
    SELECT price
    FROM phones
    WHERE name = 'S5620 Monte'
);

-- 108. The Not In Operator with a List
SELECT name, department
FROM products
WHERE department NOT IN (
	SELECT department
	FROM products
	WHERE price < 100
);

-- 109. A New Where Operator
SELECT name, department, price
FROM products
WHERE price > ALL (
	SELECT price
	FROM products
	WHERE department = 'Industrial'
);

-- 110. Finally Some!
SELECT name, department, price
FROM products
WHERE price > SOME (
	SELECT price
	FROM products
	WHERE department = 'Industrial'
);

-- Coding Exercise 22: Practice Your Subqueries!
SELECT name
FROM phones
WHERE price > ALL (
    SELECT price
    FROM phones
    WHERE manufacturer = 'Samsung'
);

-- 113. Probably Too Much About Correlated Subqueries
SELECT name, department, price
FROM products AS p1
WHERE p1.price = (
	SELECT MAX(price)
	FROM products AS p2
	WHERE p2.department = p1.department
)

-- 114. More on Correlated Subqueries
SELECT name, (
	SELECT COUNT(*)
	FROM orders AS o1
	WHERE o1.product_id = p1.id
) AS num_orders
FROM products AS p1;

-- 115. A Select Without a From?
SELECT (
	SELECT MAX(price) FROM products
);

SELECT (
	SELECT MAX(price) FROM products
) / (
	SELECT AVG(price) FROM products
);

SELECT (
	SELECT MAX(price) FROM products
), (
	SELECT AVG(price) FROM products
);

-- Coding Exercise 23: From-less Selects
SELECT (
    SELECT MAX(price)
    FROM phones
) AS max_price, (
    SELECT MIN(price)
    FROM phones
) AS min_price, (
    SELECT AVG(price)
    FROM phones
) AS avg_price




