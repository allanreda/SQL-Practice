-- 186. Where Does Postgres Store Data?
SHOW data_directory;

SELECT oid, datname
FROM pg_database;

SELECT * 
FROM pg_class;