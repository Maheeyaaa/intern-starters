-- Synthetic data only. Deterministic so results can be compared.
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    id    INTEGER PRIMARY KEY,
    name  TEXT NOT NULL,
    email TEXT NOT NULL,
    score INTEGER NOT NULL
);
INSERT INTO customers (id, name, email, score)
SELECT i, 'customer_' || i, 'customer_' || i || '@example.test', (i * 37) % 1000
FROM generate_series(1, 50) AS i;
