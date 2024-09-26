-- 13: Filtering Rows with "Where"
SELECT name, area FROM cities WHERE area > 4000;

-- 14: More on the "Where" Keyword
SELECT name, area FROM cities WHERE area = 8223;

SELECT name, area FROM cities WHERE area != 8223;

SELECT name, area FROM cities WHERE area <> 8223;

-- 15: Compound "Where" Clauses
SELECT name, area FROM cities WHERE area BETWEEN 2000 and 4000;

SELECT name, area FROM cities WHERE name in ('Delhi', 'Shanghai');

SELECT name, area FROM cities WHERE name NOT IN ('Delhi', 'Shanghai');

SELECT name, area FROM cities WHERE area NOT IN (3043, 8223);

SELECT name, area FROM cities 
WHERE area NOT IN (3043, 8223) AND name = 'Delhi';

SELECT name, area FROM cities 
WHERE area NOT IN (3043, 8223) OR name = 'Delhi';

SELECT name, area FROM cities 
WHERE area NOT IN (3043, 8223) 
OR name = 'Delhi'
OR name = 'Tokyo';

-- Coding Exercise 3: Practicing Where Statements
SELECT name, price 
FROM phones
WHERE units_sold > 5000;

-- Coding Exercise 4: A More Challenging 'Where'
SELECT name, manufacturer
FROM phones
WHERE manufacturer IN ('Apple', 'Samsung');

-- 20. Calculations in "Where" Clauses
SELECT name, population / area AS population_density
FROM cities
WHERE population / area > 6000;

-- Coding Exercise 5: Trying Calculations in Where Clauses
SELECT name, price * units_sold AS total_revenue
FROM phones
WHERE price * units_sold > 1000000;

-- 22. Updating Rows
UPDATE cities
SET population = 39505000
WHERE name = 'Tokyo';

-- 23. Deleting Rows
DELETE FROM cities 
WHERE name = 'Tokyo';

INSERT INTO cities (name, country, population, area)
VALUES ('Tokyo', 'Japan', 38505000, 8223);

-- Coding Exercise 6: Try Updating Records In a Table!
UPDATE phones
SET units_sold = 8543
WHERE name = 'N8';

-- Coding Exercise 7: Practice Deleting Records
DELETE FROM phones 
WHERE manufacturer = 'Samsung';












