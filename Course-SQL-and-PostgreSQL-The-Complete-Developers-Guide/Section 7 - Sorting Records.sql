-- 82. The Basics of Sorting
SELECT * 
FROM products
ORDER BY price;

SELECT * 
FROM products
ORDER BY price DESC;

SELECT * 
FROM products
ORDER BY price ASC;

-- 83. Two Variations on Sorting
SELECT * 
FROM products
ORDER BY name;

SELECT * 
FROM products
ORDER BY name DESC;

SELECT * 
FROM products
ORDER BY name ASC;

SELECT * 
FROM products
ORDER BY price, weight;

SELECT * 
FROM products
ORDER BY price, weight DESC;

-- 84. Offset and Limit
SELECT COUNT(*) 
FROM users

SELECT * 
FROM users
OFFSET 40;

SELECT * 
FROM users
LIMIT 5;

SELECT * 
FROM products
ORDER BY price
LIMIT 5;

SELECT * 
FROM products
ORDER BY price DESC
LIMIT 5;

SELECT * 
FROM products
ORDER BY price DESC
LIMIT 5
OFFSET 1;

SELECT * 
FROM products
ORDER BY price 
LIMIT 20
OFFSET 0;

-- Coding Exercise 17: Sorting, Offsetting, and Limiting
SELECT name
FROM phones
ORDER BY price DESC
LIMIT 2
OFFSET 1;

-- 87. Handling Sets with Union
SELECT *
FROM products
ORDER BY price DESC
LIMIT 4;

SELECT *
FROM products
ORDER BY price / weight DESC
LIMIT 4;

(
SELECT *
FROM products
ORDER BY price DESC
LIMIT 4
)
UNION
(
SELECT *
FROM products
ORDER BY price / weight DESC
LIMIT 4
);


(
SELECT *
FROM products
ORDER BY price DESC
LIMIT 4
)
UNION ALL
(
SELECT *
FROM products
ORDER BY price / weight DESC
LIMIT 4
);

SELECT * FROM products
UNION
SELECT * FROM products;

SELECT name FROM products
UNION
SELECT price FROM products

-- 89. Commonalities with Intersect
(
SELECT *
FROM products
ORDER BY price DESC
LIMIT 4
)
INTERSECT
(
SELECT *
FROM products
ORDER BY price / weight DESC
LIMIT 4
);

(
SELECT *
FROM products
ORDER BY price DESC
LIMIT 4
)
INTERSECT 
(
SELECT *
FROM products
ORDER BY price / weight DESC
LIMIT 4
);

-- 90. Removing Commonalities with Except
(
SELECT *
FROM products
ORDER BY price DESC
LIMIT 4
)
EXCEPT
(
SELECT *
FROM products
ORDER BY price / weight DESC
LIMIT 4
);

-- Coding Exercise 18: Merging Results with Union
SELECT manufacturer FROM phones 
WHERE price < 170
UNION
SELECT manufacturer FROM phones 
GROUP BY manufacturer
HAVING COUNT(*) > 2

