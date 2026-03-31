create database superstore;

use superstore;

select * from superstore;


select  `order ID` , count(*)
from superstore
group by `order ID`
having count(*)>1;

select * from superstore
limit 10;

select max(`row ID`) from superstore;

describe superstore;

select * from superstore
where `order ID` is null
or `Customer ID` is null
or `customer name` is null
or sales is null
or profit is null;

SELECT COUNT(*) FROM superstore;

SELECT COUNT(DISTINCT `Order ID`) FROM superstore;

SELECT `Order ID`, COUNT(*) AS items_per_order
FROM superstore
GROUP BY `Order ID`
ORDER BY items_per_order DESC
LIMIT 5;

select `order date`  from superstore;

alter table superstore
add column order_date_clean date;

SET SQL_SAFE_UPDATES = 0;

UPDATE superstore
SET order_date_clean = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

SELECT `Order Date`, order_date_clean
FROM superstore
LIMIT 10;


ALTER TABLE superstore
ADD COLUMN ship_date_clean DATE;

UPDATE superstore
SET ship_date_clean = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

select `ship date` , ship_date_clean
from superstore
limit 10;

SELECT 
    order_date_clean,
    YEAR(order_date_clean) AS order_year,
    MONTH(order_date_clean) AS order_month,
    DAY(order_date_clean) AS order_day
FROM superstore;

alter table superstore
add column order_year int,
add column order_month int;

set sql_safe_updates = 0;

update superstore
set order_year = year(order_date_clean),
    order_month = month(order_date_clean);


alter table superstore
add column profit_margin float;

update superstore
set profit_margin = (profit/sales)*100;

select * from superstore;

UPDATE superstore
SET profit_margin = 
    CASE 
        WHEN Sales = 0 THEN 0
        ELSE (Profit / Sales) * 100
    END;
    
alter table superstore
add column delivery_days int;

update superstore 
set delivery_days = datediff(ship_date_clean , order_date_clean);

alter table superstore
add column discount_level VARCHAR(20);

update superstore
set discount_level =
       case 
           when discount = 0 then 'No discount'
           when discount <=0.2 then 'low discount'
           when discount <=0.5 then 'midium discount'
           else 'high discount'
           end;
           
select * from superstore 
limit 10;

-- overall buisness performance 
select 
sum(sales) as total_sales,
sum(profit) as total_profit,
count(distinct(`order ID`)) as total_orders
from superstore;


-- sales & profit by category
select category,
sum(sales) as total_sales,
sum(profit) as total_profit
from superstore
group by category
order by total_sales  desc;


-- sub-category analysis
select `sub-category`,
sum(sales) as total_sales,
sum(profit) as total_profit
from superstore
group by `sub-category`
order by total_profit desc;


-- loss making products
select `product name`,
sum(profit) as total_loss
from superstore
group by `product name`
having total_loss<0
order by total_loss ;


-- region wise performance
select region , 
sum(sales) as total_sales,
sum(profit) as total_profit
from superstore
group by region;


-- Top 10 customers
select `customer name`,
sum(sales) as revenue
from superstore
group by `customer name`
order by revenue desc
limit 10;

-- monthly sales trends

select order_year , order_month,
sum(sales) as monthly_sales from superstore
group by order_year , order_month
order by order_year , order_month;

-- discount impact on profit

select discount_level,
sum(sales) as total_sales,
sum(profit) as total_profit
from superstore
group by discount_level;

-- dilevery time analysis

select avg(delivery_days) as avg_dilivery_time
from superstore;

select delivery_days , count(*) as orders
from superstore
group by delivery_days
order by delivery_days;

