-- 200. Explain and Explain Analyze
SELECT username, contents
FROM users
JOIN comments 
ON comments.user_id = users.id
WHERE username = 'Alyson14';

EXPLAIN SELECT username, contents
FROM users
JOIN comments 
ON comments.user_id = users.id
WHERE username = 'Alyson14';

EXPLAIN ANALYZE SELECT username, contents
FROM users
JOIN comments 
ON comments.user_id = users.id
WHERE username = 'Alyson14';

-- 201. Solving an Explain Mystery
Select *
FROM pg_stats 
WHERE tablename = 'users';