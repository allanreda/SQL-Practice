-- 62. Picturing Group By
SELECT user_id
FROM comments
GROUP BY user_id;

-- 63. Aggregate Functions
SELECT SUM(id)
FROM comments;

SELECT MAX(photo_id)
FROM comments;

-- 64. Combining Group By and Aggregates
SELECT user_id, MAX(id)
FROM comments
GROUP BY user_id;

SELECT user_id, COUNT(id) AS num_comments_created
FROM comments
GROUP BY user_id;

-- A Gotcha with Count
SELECT user_id, COUNT(*)
FROM comments
GROUP BY user_id;

-- 66. Visualizing More Grouping
SELECT photo_id, COUNT(*)
FROM comments
GROUP BY photo_id;

-- Coding Exercise 12: Practice For Grouping and Aggregating
SELECT author_id, COUNT(*)
FROM books
GROUP BY author_id;

-- Coding Exercise 13: Grouping With a Join!
SELECT name, COUNT(*)
FROM books
LEFT JOIN authors
ON books.author_id = authors.id
GROUP BY name;

-- 72. Having In Action
SELECT photo_id, COUNT(*)
FROM comments
WHERE photo_id > 3
GROUP BY photo_id
HAVING COUNT(*) > 2;

-- 73. More on Having!
SELECT user_id, COUNT(*)
FROM comments
WHERE photo_id < 50
GROUP BY user_id 
HAVING COUNT(*) > 20;

-- Coding Exercise 14: Practice Yourself Some Having

SELECT manufacturer, SUM(price * units_sold) 
FROM phones
GROUP BY manufacturer
HAVING SUM(price * units_sold) > 2000000;





