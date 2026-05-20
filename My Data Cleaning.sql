use DataCleaning

select * from sales;

-- To check duplicate

select *,
ROW_NUMBER() over (partition by transaction_id order by transaction_id) row_num
from sales;


with CTE AS (
select *,
ROW_NUMBER() over (partition by transaction_id order by transaction_id) row_num
from sales
)

select * from cte where row_num > 1

--1001
--1004
--1030
--1074

with CTE AS (
select *,
ROW_NUMBER() over (partition by transaction_id order by transaction_id) row_num
from sales
)


SELECT	* from CTE WHERE TRANSACTION_ID IN (1001,1004,1030,1074)



with CTE AS (
select *,
ROW_NUMBER() over (partition by TRANSACTION_ID order by TRANSACTION_ID) row_num
from sales
)
DELETE FROM CTE WHERE ROW_NUM >1

with CTE AS (
select *,
ROW_NUMBER() over (partition by TRANSACTION_ID order by TRANSACTION_ID) row_num
from sales
)

SELECT	* from CTE WHERE TRANSACTION_ID IN (1001,1004,1030,1074)


-- CHECK NULL VALUES

SELECT * FROM sales
WHERE transaction_id is null
OR
customer_id IS NULL
OR
customer_name IS NULL;


DECLARE @SQL NVARCHAR(max) = ''

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, 
    COUNT(*) AS NullCount 
    FROM ' + QUOTENAME(TABLE_SCHEMA) + '.sales 
    WHERE ' + QUOTENAME(COLUMN_NAME) + ' IS NULL',
    ' UNION ALL '
)
WITHIN GROUP (ORDER BY COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales';

-- Execute the dynamic SQL
EXEC sp_executesql @SQL;

-- Treating Null Values

select distinct category from sales;

update sales
set category = 'Unknown'
where category is null;

update sales
set customer_address = 'Not Availabe'
where customer_address is null;

select distinct payment_method from sales;

update sales
set payment_method = 'Credit Card'
where payment_method in ('creditcard','CC','credit')


update sales
set payment_method = 'Cash'
where payment_method is null;

select distinct delivery_status from sales;

update sales
set delivery_status = 'Not Delivered'
where delivery_status = 'Cash';

-----------------price
----MEAN
---2510.76

SELECT AVG(price) from sales

----MODE

SELECT price,count(*) as max_count
from sales
group by price
order by max_count desc

----Median
--2530.75

SELECT DISTINCT 
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) OVER() AS median
FROM sales;

------------------------------------------
select category, avg(price) as avg_price
from sales
group by category 

--Unknown	         2511.416405
--Books	             2574.457346
--Home & Kitchen	 2507.058378
--Toys	             2235.471689
--Electronics	     2663.927840
--Clothing	         2539.278187

--Unknown
UPDATE sales
SET price=2511.41
WHERE price is NULL and category='Unknown'

--Books
UPDATE sales
SET price=2574.45
WHERE price is NULL and category='Books'

--Home & Kitchen	 2507.05
UPDATE sales
SET price=2507.05
WHERE price is NULL and category='Home & Kitchen'

--Toys	             2235.47
UPDATE sales
SET price=2235.47
WHERE price is NULL and category='Toys'

--Electronics	     2663.92
UPDATE sales
SET price=2663.92
WHERE price is NULL and category='Electronics'

---Clothing	         2539.27
UPDATE sales
SET price=2539.27
WHERE price is NULL and category='Clothing'

select * from sales


select distinct price from sales;


--Step 4 :- Handling Negative values

SELECT * FROM SALES
where quantity <0

UPDATE sales
SET quantity = ABS(quantity)
WHERE quantity <0

UPDATE sales 
SET total_amount= price*quantity
WHERE total_amount IS NULL OR total_amount <> price*quantity


SELECT * FROM SALES 
WHERE customer_id iS NULL

SELECT * FROM SALES 
WHERE customer_name iS NULL

update sales
set customer_name='User'
where customer_name is NULL

--------------------------------------------------------------------------------------------

--Step 5 :- Fixing Inconsistent Date Formats & Invalid Dates

select * from sales
WHERE purchase_date ='2024-02-30'

UPDATE sales 
SET purchase_date =
	CASE 
		WHEN TRY_CONVERT(DATE,purchase_date, 103) IS NOT NULL
		THEN TRY_CONVERT(DATE,purchase_date, 103)
	ELSE NULL
END;

select purchase_date from sales;

--------------------------------------------------------------------------------------------
--Step 6 :- Fixing Invalid Email Addresses

SELECT * FROM SALES
WHERE email NOT LIKE '%@%'

UPDATE sales
SET email= NULL 
WHERE email NOT LIKE '%@%'


SELECT email FROM SALES
where email is null;

--------------------------------------------------------------------------------------------
--Step 7 :- Checking the datatype

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sales'

ALTER TABLE sales
ALTER COLUMN purchase_date DATE;

SELECT purchase_date 
FROM sales 
WHERE TRY_CAST(purchase_date AS DATE) IS NULL 
  AND purchase_date IS NOT NULL;


ALTER TABLE purchase_date
ALTER COLUMN purchase_date DATE constraint;

SELECT 
    purchase_date,
    TRY_CONVERT(DATE, purchase_date, 103) 
FROM sales;


SELECT COLUMN_NAME, DATA_TYPE
FROM sales
WHERE TRY_CONVERT(DATE, COLUMN_NAME) IS NULL 
  AND COLUMN_NAME IS NOT NULL;

  select * from sales