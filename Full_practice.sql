USE sql_store;

SELECT *
FROM customers
where state='VA' OR state='GA' OR state='FL';

-- Using IN statement --
SELECT *
FROM customers
where state IN ('VA','FL','GA'); -- NOT IN can also be used--


-- BETWEEN OPERATOR--

SELECT *
FROM customers
WHERE points >=1000 AND points<=3000;

-- Similar way to do using between operator --

SELECT *
FROM customers
WHERE points BETWEEN 1000 and 3000; -- range values are inclusive--

-- LIKE OPERATOR--
SELECT *
FROM customers
WHERE last_name LIKE 'b%';

-- Another example--
SELECT *
FROM customers
WHERE last_name LIKE '%b%';

SELECT *
FROM customers
WHERE last_name LIKE '_____y'; -- f characters and last character 'y' --

-- SUBSTRING --
USE sql_hr;
SELECT substring(salary, 1,3) AS First_3_digit, salary -- substring(column_name, starting index, length) 
FROM employees
WHERE salary >=50000;

-- Q. Get the customers whose
--     addresses contain TRAIL or AVENUE
--     phone number end with 9

SELECT	*
FROM customers
WHERE address LIKE '%trail%' OR 
	  address LIKE '%avenue%';
 
SELECT	*
FROM customers
WHERE phone LIKE '%9';

-- We can also use NOT LIKE operator to get value other than that
SELECT	*
FROM customers
WHERE phone NOT LIKE '%9';

-- The REGEX operator --
-- More powerful tool --
SELECT	*
FROM customers
WHERE last_name REGEXP 'field';
-- same as WHERE last_name LIKE '%field%'

SELECT	*
FROM customers
WHERE last_name REGEXP 'field$|mac|^rose';
-- $ sign indicates the string ends with field
-- | indicates as OR statement
-- ^ sign indicates that the string should start with rose

SELECT	*
FROM customers
WHERE last_name REGEXP '[gie]e'; -- or e[fml] or '[a-h]e'
-- Last name with 'ge' or 'ie' or 'ee'
-- ^ beginning
-- $ end
-- | logocal OR
-- [abcd]
-- [a-h] range


-- THE NULL OPERATOR --
SELECT *
FROM customers
WHERE phone IS NULL;

SELECT *
FROM customers
WHERE phone IS NOT NULL;

-- The ORDER BY Clause --
SELECT *
FROM customers
ORDER BY first_name DESC;

SELECT *
FROM customers
ORDER BY state DESC, first_name; -- order by state first, and then first_name--
-- We can use anything that is not in SELECT clause to order by--

SELECT first_name, last_name, 10 AS points -- We can add random assigned as column'
FROM customers
ORDER BY points, first_name;

SELECT first_name, last_name
FROM customers
ORDER BY 1,2 ;
-- Sorting the data with first_name and last_name
-- The 1, 2 references as what we put in the SELECT clause but avoid it


-- The LIMIT Clause
SELECT *
FROM customers
LIMIT 3;
-- Returns only the first 3 customers

SELECT *
FROM customers
ORDER BY last_name
LIMIT 6,3;
-- It skips the first 6 rows and returns the 3 rows starting from row 7

-- The INNER JOINS--
USE sql_store;
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id=c.customer_id;
    
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c
	ON o.customer_id=c.customer_id
ORDER BY last_name DESC;

-- JOININING ACROSS MULTIPLE DATABASE
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id=p.product_id;
-- We are using sql_store as our main database here

-- SELF JOINS--
USE sql_hr;
SELECT *
FROM employees e
JOIN employees m
	ON e.reports_to=m.employee_id;

USE sql_hr;
SELECT e.employee_id,
		e.first_name,
        m.first_name AS manager
FROM employees e
JOIN employees m
	ON e.reports_to=m.employee_id;
 --------------------------------------------------------------------------------------   
--  JOINING MULTIPLE TABLES
USE sql_store;
SELECT * FROM orders o
JOIN customers c
	ON o.customer_ID=c.customer_id
JOIN order_statuses os
	ON o.status=os.order_status_id;
      
USE sql_store;
SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_ID=c.customer_id
JOIN order_statuses os
	ON o.status=os.order_status_id;
 ------------------------------------------------------------------------------------   
    -- COMPOUND JOIN CONDITIONS--
 -- sometims if same value is repeated in the column, it cannot identify each row
 -- so combination of 2 columns helps to identify each row in the table
 -- we can check in the design mode to see if 2 primary key is assigned in it
 -- a composite primary key contains more than one columns
USE sql_store;
SELECT	*
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id=oin.order_id
    AND oi.product_id=oin.product_id;
------------------------------------------------------------------------------    
-- IMPLICIT JOIN SYNTAX--
SELECT *
FROM orders o, customers c
WHERE o.customer_id=c.customer_id;
-- if we forget WHERE clause here, it does cross join--
---------------------------------------------------------------------------

-- OUTER JOINS --
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o
	ON c.customer_id=o.customer_id
ORDER BY c.customer_id;
-- This is RIGHT outer join

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id=o.customer_id
ORDER BY c.customer_id;
-- This is LEFT OUTER JOIN, OUTER is optional


-- OUTER JOINS between Multiple Tables--
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id=o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id= sh.shipper_id
ORDER BY c.customer_id;
----------------------------------------------------------------------------------------
-- SELF OUTER JOINS--
USE sql_hr;
SELECT e.employee_id, e.first_name, m.first_name AS Manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to=m.employee_id;
------------------------------------------------------------------------------------------    
    -- The USING clause ---
    -- If the column name is same, we can use USING clause --
USE sql_store;
SELECT o.order_id, c.first_name, sh.name AS shipper
FROM orders o
JOIN customers c 
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);
-- for 2 columns as primary keys, just write column name with , seprated inside USING clause
------------------------------------------------------------------------------------------
-- NATURAL JOINS --
-- Not recommended as computer itself chooses the common column
SELECT o.order_id, c.first_name
FROM orders o
NATURAL JOIN customers c;
-----------------------------------------------------------------------------------------
-- CROSS JOIN --
-- each value from left is combined with each value in right column--
SELECT c.first_name AS customer, p.name AS product
FROM customers c
CROSS JOIN products p
ORDER by c.first_name ;
--------------------------------------------------------------------------------------------
 -- UNION --
-- combining rows from multiple tables
SELECT order_id, order_date, 'Active' AS Status
FROM orders
WHERE order_date>= '2019-01-01'
UNION
SELECT order_id, order_date, 'Archive' AS Status
FROM orders
WHERE order_date < '2019-01-01';
-- This is UNION from same table
-- the number of columns in each query should always be equal for this to work

SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;
-- The column name in the first query determines the name of final result query--
-----------------------------------------------------------------------------------------

-- COLUMN ATTRIBUTES --
-- Inserting a ROW into a table
USE sql_store;
INSERT INTO customers
VALUES (DEFAULT, 'Rocky','Kharel','1990-01-03',NULL, '119 Dahlia Dr','Thornton','CO',DEFAULT);
-- One way to do that

INSERT INTO customers (first_name,last_name, birth_date, address, city, state)
VALUES ('Prashant','Khanal','1993-01-07', '503 Rossile Dr','LittleRock','AK');
-- Another way to do it--
-- The default values ads up automatically if it is assigned in column attributes--

-- INSERTING multile rows --
INSERT INTO shippers (name)
VALUES ('shiper1'),
		('shiper2'),
        ('shiper3');
        
  -------------------------------------------      
	-- INSERTING DATA INTO MULTILE TABLES--
    -- Inserting Hierafchical Rows --
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02',1);

INSERT INTO order_items
VALUES(LAST_INSERT_ID(),1, 1,2.95),
	  (LAST_INSERT_ID(),2, 1,3.95);
-- LAST_INSERT_ID is a built in function to ease the way to insert values in connected tables--
-------------------------------------------------------------------------------------------------

-- CREATING A COPY OF A TABLE--
CREATE TABLE order_archive AS
SELECT * FROM orders; -- This line is subquery to be inserted into the table--

CREATE TABLE order_before2019
SELECT *
FROM orders
WHERE order_date < '2019-01-01'; -- This line is sub query
-- The column attributes won't have primary key assigned and AutoIncrement slected 

----------------------------------------------------------------------------------------------

-- UDATING A SINGLE ROW --
USE sql_invoicing;
UPDATE invoices
SET payment_total=10, payment_date='2019-03-01'
WHERE invoice_id=1;









