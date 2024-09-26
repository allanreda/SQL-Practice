-- 193. Creating an Index
CREATE INDEX ON users (username);

CREATE INDEX users_username_idx ON users (username);

DROP INDEX users_username_idx;

-- 194. Benchmarking Queries

-- With index: around 0.050ms
-- Without index: 0.450ms
EXPLAIN ANALYZE SELECT *
FROM users
WHERE username = 'Emil30';

-- 195. Downsides of Indexes
SELECT pg_size_pretty(pg_relation_size('users'));
-- 872 kB

SELECT pg_size_pretty(pg_relation_size('users_username_idx'));
-- 184 kB

-- 197. Automatically Generated Indexes
SELECT relname, relkind
FROM pg_class
WHERE relkind = 'i';