-- creating database 
create database bigbaskit;
use bigbaskit;
show tables;


create table bigbasket (
product VARCHAR(255)
 ,category VARCHAR(100),	
 sub_category VARCHAR(100),
 brand VARCHAR(100) ,
 sale_price FLOAT,
 market_price FLOAT,
 Type VARCHAR(100)	,
 rating FLOAT );
 

select * from bigbasket;




drop table bigbasket;
select count(*) from bigbasket;

-- basic sql queries
-- 1. 📦 Total Number of Products by Category;

select  category,
count(*) as total_products 
from bigbasket 
group by category 
order by total_products desc ;


-- 2. ⭐ Top 10 Products by Rating;


select product ,
 rating 
 from bigbasket 
 where rating is not null
 order by rating desc limit 10;

-- 3. List top 10 most expensive products (by sale price);


select product ,
 sale_price 
 from bigbasket 
 order by sale_price desc limit 10;

-- 4. Count of products by each main category;


select category ,
COUNT(*) as Total_Products
 from bigbasket 
 group by category 
 order by Total_Products DESC ;

-- 5. Average rating per sub-category;
select  sub_category ,
AVG(rating) as avg_rating 
from `bigbasket products`
 where rating is not null 
 group by sub_category 
 order by avg_rating desc ;
 
 
 -- 6. Which brands offer biggest discounts (market - sale price)?
 
 select brand ,
 AVG(market_price - sale_price) as biggest_discount 
 from bigbasket
 where sale_price is not null
 group by brand 
 order by biggest_discount desc limit 10;

-- 7. Products with missing or zero ratings;
select product,
 rating 
 from `bigbasket products`
 where rating is null or rating = 0;

-- 8. 📈 Average Sale Price by Category

select category ,
ROUND(avg(sale_price),2) as avg_sale
from bigbasket
group by category
order by avg_sale desc ;


-- 9. 🏷️ Most Common Brands


select brand,
 count(*) as total_price 
 from bigbasket
 group by brand 
 order by total_price desc limit 10;
 
SELECT brand, 
       COUNT(*) AS product_count
FROM `bigbasket products`
GROUP BY brand
ORDER BY product_count DESC
LIMIT 10;

select * from bigbasket;

-- advance sql query


-- Q1. Find products where sale_price > market_price (pricing anomaly).
SELECT product,brand,category, sale_price, market_price
FROM bigbasket 
WHERE sale_price > market_price;

-- Q2.Standardize brand names (remove spaces, lowercase).


SELECT DISTINCT  TRIM(LOWER(brand)) AS clean_brand
FROM bigbasket;

-- Q3. Replace missing ratings with sub-category average.
SET SQL_SAFE_UPDATES = 0;

UPDATE bigbasket b
JOIN ( SELECT  sub_category, AVG(rating) as avg_rating
      FROM bigbasket WHERE rating is not null 
      group by sub_category ) s on b.sub_category  = s.sub_category
      SET b.rating = s.avg_rating
      WHERE b.rating is not null;
      
      
-- Q4. Rank sub-categories by average rating and return top 5. 

WITH  sub_avg as (
SELECT sub_category , AVG(rating) as avg_rating
FROM bigbasket 
WHERE rating is not null
GROUP BY sub_category )
SELECT *FROM (
SELECT sub_category , avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS ranking
FROM sub_avg ) t
WHERE ranking <= 5; 

WITH sub_avg AS (
    SELECT sub_category, AVG(rating) AS avg_rating
    FROM bigbasket
    WHERE rating IS NOT NULL
    GROUP BY sub_category
)
SELECT sub_category, avg_rating,
       RANK() OVER (ORDER BY avg_rating DESC) AS ranking
FROM sub_avg LIMIT 5;


-- Q5. Top 3 most expensive products in each category.
SELECT category, product, sale_price ,
 RANK() OVER(PARTITION BY category ORDER BY sale_price) as rnk
FROM bigbasket WHERE sale_price is not null 
LIMIT 3;


-- Q6. Divide products into price quartiles.
SELECT sub_category,product, sale_price ,
NTILE(4) OVER (ORDER BY sub_category ) as price_quantile
FROM bigbasket
WHERE sale_price is not null;

-- Q7. Category where discounts contribute the most.
SELECT category , SUM(market_price - sale_price) AS total_discount 
FROM bigbasket 
WHERE market_price is not null AND sale_price is not null
GROUP BY category
ORDER BY total_discount DESC LIMIT 1;

-- Q8. Brand with the highest rating consistency (lowest variance).
SELECT brand, VARIANCE(rating) as rating_variance
FROM bigbasket GROUP BY brand
ORDER BY rating_variance ASC LIMIT 1;