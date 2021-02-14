USE sql_store;

-- Q. Return products with quantity in stock equal to 49, 38, 72
SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38,72);

-- Q. Return Customers born between 1/1/1990 and 1/1/2000 --
SELECT * 
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01'; -- Date format YYYY-MM-DD --

-- Q. GET THE CUSTOMERS WHOSE
--   First name are ELKA or AMBUR
--   last name end with EY or ON
--   last name starts with MY or contains SE
--   last name contain B followed by R or U
SELECT *
FROM customers
WHERE first_name REGEXP 'ELKA|AMBUR';

SELECT *
FROM customers
WHERE last_name REGEXP '^MY|SE';

SELECT *
FROM customers
WHERE last_name REGEXP 'ELKA|AMBUR';

SELECT *
FROM customers
WHERE last_name REGEXP 'b[ru]';  -- 'br|bu';

-- GET THE ORDERS THAT ARE NOT SHIPPED
SELECT *
FROM orders
WHERE shipper_id IS NULL;

-- Q. GET THE DATA FROM ORDER ITEMS OF ORDER ID 2 AND ORDERED BY TOTAL PRICE
-- Remember there is no column as total_price
SELECT *
FROM order_items
WHERE	order_id = 2
ORDER BY quantity*unit_price DESC;

SELECT *, quantity*unit_price AS total_price
FROM order_items
WHERE	order_id = 2
ORDER BY total_price DESC;
-- this adds a new column that it is sorted by

-- Q. Get the top three loyal customers (more points than everyone else)
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;
-- LIMIT clause always comes at the end

-- Q.
SELECT order_id, oi.product_id, quantity, oi.unit_price
FROM order_items oi
JOIN products p
	ON oi.product_id=p.product_id;
    
-- Q. Write a query to join payments table to payment_method table as well as clients table
USE sql_invoicing;
SELECT *
FROM payments p
JOIN clients c
	ON p.client_id=c.client_id
JOIN payment_methods pm
	ON p.payment_method=pm.payment_method_id;
    
    
USE sql_invoicing;
SELECT p.date, p.invoice_id, p.amount, c.name, pm.name
FROM payments p
JOIN clients c
	ON p.client_id=c.client_id
JOIN payment_methods pm
	ON p.payment_method=pm.payment_method_id;
    
-- Q. Write an outer join 
USE sql_store;
SELECT p.product_id, p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id;
-- This is left outer join where everything from left column is included

-- Q. Do a CROSS JOIN between shipers and products
-- using the implicit syntax
-- and then using the explici syntax
USE sql_store;
SELECT sh.name AS shipper, p.name AS products
FROM shippers sh, products p
ORDER BY sh.name;
-- this is Implicit join

USE sql_store;
SELECT sh.name AS shipper, p.name AS products
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;
 -- this is Explicit Join
 
-- Q. Get the 
SELECT customer_id, first_name, points, 'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT customer_id, first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id, first_name, points, 'Bronze' AS type
FROM customers
WHERE points >3000
ORDER BY first_name


    

  









