--227. Some Sample Data
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	name VARCHAR(20) NOT NULL, 
	balance INTEGER NOT NULL
);

INSERT INTO accounts (name, balance)
VALUES 
		('Gia', 100),
		('Alyson', 100);

SELECT * FROM accounts;

-- 228. Opening and Closing Transactions
BEGIN;

UPDATE accounts
SET balance = balance - 50
WHERE name = 'Alyson';

SELECT * FROM accounts;

UPDATE accounts
SET balance = balance + 50
WHERE name = 'Gia';

COMMIT;

-- 229. Transaction Cleanup on Crash
UPDATE accounts
SET balance = 100;

SELECT * FROM accounts;

BEGIN;

UPDATE accounts
SET balance = balance - 50
WHERE name = 'Alyson';

SELECT * FROM accounts;

-- 230. Closing Aborted Transactions
BEGIN;

SELECT * FROM sfgdsafgasdf

SELECT * FROM accounts;

ROLLBACK;
