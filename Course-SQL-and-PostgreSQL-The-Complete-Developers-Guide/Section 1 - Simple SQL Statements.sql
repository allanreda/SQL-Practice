-- 5: Creating tables 
CREATE TABLE cities (
	name VARCHAR(50), 
  country VARCHAR(50),
  population INTEGER,
  area INTEGER
);

-- 7: Inserting data into a table
INSERT INTO cities (name, country, population, area)
VALUES ('Tokyo', 'Japan', 38505000, 8223);

INSERT INTO cities (name, country, population, area)
VALUES 
	('Delhi', 'India', 28125000, 2240),
  ('Shanghai', 'China', 22125000, 4015),
  ('Sao Paulo', 'Brazil', 20935000, 3043);

-- Coding Exercise 1:
SELECT title, box_office FROM movies

-- 9: Calculated columns 
SELECT name, population / area as population_density 
FROM cities;

-- Coding Exercise 2:
SELECT name, price * units_sold as revenue FROM phones

-- 12: String operators and functions
SELECT name || ', '|| country AS location FROM cities;

SELECT CONCAT(name, ', ', country) AS location FROM cities;

SELECT 
CONCAT(UPPER(name), ', ', UPPER(country)) AS location 
FROM cities;

SELECT
  UPPER(CONCAT(name, ', ', country)) AS location
FROM
  cities;
