-- 118. Selecting Distinct Values
SELECT DISTINCT department
FROM products;

SELECT COUNT(DISTINCT department)
FROM products;

SELECT DISTINCT department, name
FROM products;

-- Coding Exercise 24: Some Practice with Distinct
SELECT COUNT(DISTINCT manufacturer)
FROM phones;