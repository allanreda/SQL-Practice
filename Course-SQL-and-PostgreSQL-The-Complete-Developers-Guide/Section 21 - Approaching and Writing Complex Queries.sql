-- 177. Adding Some Data
SELECT COUNT(*)
FROM users;

SELECT COUNT(*)
FROM likes;

-- 179. Highest User ID's Exercise
SELECT *
FROM users
ORDER BY id DESC
LIMIT 3;

-- 181. Posts by a Particular User
SELECT username, caption
FROM users
JOIN posts
ON users.id = posts.user_id
WHERE users.id = 200;

-- 183. Likes Per User
SELECT username, count(*) AS like_count
FROM users
JOIN likes
ON users.id = likes.user_id
GROUP BY username;