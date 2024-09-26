-- 136. Creating and Viewing Tables in PGAdmin
CREATE TABLE products (
		id SERIAL PRIMARY KEY,
		name VARCHAR(40),
		department VARCHAR(40),
		price INTEGER,
		weight INTEGER
);

INSERT INTO products (name, department, price, weight)
VALUES
	('Shirt', 'Clothes', 20, 1);

-- 137. Applying a Null Constraint
INSERT INTO products (name, department, weight)
VALUES
	('Pants', 'Clothes', 3);

ALTER TABLE products
ALTER COLUMN price
SET NOT NULL;

-- 138. Solving a Gotcha with Null Constraints
UPDATE products
SET price = 999
WHERE price IS NULL;

ALTER TABLE products
ALTER COLUMN price
SET NOT NULL;

INSERT INTO products (name, department, weight)
VALUES
	('Shoes', 'Clothes', 5);

-- 139. Default Column Values
ALTER TABLE products
ALTER COLUMN price
SET DEFAULT 999;

INSERT INTO products (name, department, weight)
VALUES
	('Gloves', 'Tools', 1);

-- 140. Applying a Unique Constraint to One column
INSERT INTO products (name, department, price, weight)
VALUES
	('Shirt', 'Tools', 24, 1);

ALTER TABLE products
ADD UNIQUE (name);

INSERT INTO products (name, department, price, weight)
VALUES
	('Shirt', 'Tools', 24, 1);

-- 141. Multi-Column Uniqueness
ALTER TABLE products
DROP CONSTRAINT products_name_key;

ALTER TABLE products
ADD UNIQUE (name, department);

INSERT INTO products (name, department, price, weight)
VALUES
	('Shirt', 'Housewares', 24, 1);

INSERT INTO products (name, department, price, weight)
VALUES
	('Shirt', 'Clothes', 24, 1);

ALTER TABLE products
DROP CONSTRAINT products_name_department_key;

--142. Adding a Validation Check
ALTER TABLE products
ADD CHECK (price > 0);

INSERT INTO products (name, department, price, weight)
VALUES
	('Belt', 'Clothes', -99, 1);

-- 143. Checks Over Multiple Columns
CREATE TABLE orders (
		id SERIAL PRIMARY KEY,
		name VARCHAR(40),
		created_at TIMESTAMP NOT NULL,
		est_delivery TIMESTAMP NOT NULL,
		CHECK (created_at < est_delivery)
);

INSERT INTO orders (name, created_At, est_delivery)
VALUES
	('Shirt', '2000-NOV-20 01:00AM', '2000-NOV-25 01:00AM');

INSERT INTO orders (name, created_At, est_delivery)
VALUES
	('Shirt', '2000-NOV-20 01:00AM', '2000-NOV-10 01:00AM');





