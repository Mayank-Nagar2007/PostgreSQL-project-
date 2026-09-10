DROP TABLE BOOKS;
CREATE TABLE IF NOT EXISTS BOOKS(
    book_id INT primary key,
    title  TEXT,
    author  VARCHAR(100),
    genre   VARCHAR(100),
    published_year  VARCHAR(100),
    price     NUMERIC(10,2),
    stock     INT 
)     

CREATE TABLE IF NOT EXISTS CUSTOMERS(
   Customer_ID INT PRIMARY KEY,
   Name   VARCHAR(100),
   Email  VARCHAR(100),
   Phone  BIGINT,
   City   VARCHAR(100),
   Country VARCHAR(100)
)


CREATE TABLE IF NOT EXISTS ORDERS(
    order_id INT PRIMARY KEY,
	customer_id INT NOT NULL,
	book_id INT NOT NULL,
	order_date  date ,
	Quantity  INT  ,
	Total_Amount NUMERIC(10,2)
	
)

SELECT * FROM ORDERS;
SELECT * FROM books;
SELECT * FROM customers;



-- BASIC QUERIES
-- Q1
SELECT book_id,genre 
FROM books
  where genre = 'Fiction';


  --  Q2
SELECT book_id,genre ,published_year
 FROM books 
 where published_year >'1950' ;


-- Q3 
SELECT customer_id, name,country 
FROM customers 
WHERE country = 'Canada';

--Q4 
-- SELECT order_id, customer_id,book_id,
--    sum(quantity) AS sum_of 
--    FROM orders
--    where order_date BETWEEN '2023-11-01' AND '2023-11-30'
--    GROUP BY order_id,customer_id,book_id ;

-- Q5 
SELECT 
   SUM(stock) AS total_sum
   FROM books ;

-- Q6 
SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- with higest_price AS(
--       SELECT book_id,title,author,published_year , price,stock,
-- dense_rank() OVER(ORDER BY price DESC) as rnk
-- FROM books 
-- ) select book_id,title,author,published_year, price, stock 
--    FROM higest_price  
--    WHERE rnk = 1;


-- Q7
SELECT * FROM orders 
WHERE quantity >1;


-- Q8
SELECT * FROM orders 
WHERE total_amount > 20;

-- Q9
SELECT genre FROM books 
    GROUP BY genre ;

--Q10
SELECT * FROM books ORDER BY stock ASC LIMIT 1;

-- Q11
SELECT 
SUM(total_amount) AS Revenue 
 FROM orders ;



-- ADVANCE QUESTION
-- Q1 
SELECT DISTINCT b.genre,sum(o.quantity)  AS total_book_sold
  FROM books b
  INNER JOIN 
   orders o
   ON b.book_id = o.book_id 
   GROUP BY b.genre ;


-- Q2
WITH average_price_genre AS(
SELECT DISTINCT b.genre,AVG(b.price) as avg_price
FROM books b
GROUP BY genre 
) SELECT genre,avg_price
  FROM average_price_genre
WHERE genre = 'Fantasy';


-- Q3
-- SELECT c.name,c.customer_id,o.quantity 
-- FROM customers c 
-- JOIN 
-- orders o 
-- ON c.customer_id = o.customer_id 
-- WHERE o.quantity >=2;


SELECT o.customer_id,c.name,COUNT(o.order_id) AS ORDER_COUNT 
FROM orders o   
JOIN  customers c ON o.customer_id = c.customer_id 
GROUP BY o.customer_id,c.name 
HAVING COUNT(order_id) >=2;

-- Q4
SELECT o.book_id,b.title.count(o.order_id) AS ORDER_COUNT
FROM orders o 
JOIN books b ON o.book_id = b.book_id 
GROUP BY o.book_id ,b.title 
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- Q5
SELECT  book_id ,genre,price  
  FROM books 
  GROUP BY genre,book_id ,price
  HAVING genre = 'Fantasy'
  ORDER BY price DESC LIMIT 3;


  -- Q6
SELECT DISTINCT b.author ,sum(o.quantity) AS each_quantity
FROM books b 
JOIN orders o ON o.book_id = b.book_id 
GROUP BY b.author;


-- Q7
SELECT DISTINCT c.city ,sum(o.total_amount) AS total_amo
 FROM orders o    
 JOIN customers c ON o.customer_id = c.customer_id 
 GROUP BY c.city, o.total_amount
 HAVING o.total_amount > 30 ;



--  Q8
SELECT c.customer_id,c.name , SUM(o.total_amount) AS Total_spent 
FROM orders o  
JOIN  customers c ON o.customer_id = c.customer_id 
GROUP BY c.customer_id,c.name 
ORDER BY Total_spent DESC LIMIT 1;


-- Q9
SELECT b.book_id,b.title , b.stock , COALESCE(SUM(o.quantity),0) AS order_quntity ,
  b.stock -COALESCE(SUM(o.quantity),0) AS remainig_quantity 
FROM books b 
LEFT JOIN orders o  ON o.book_id = b.book_id 
GROUP BY b.book_id ;