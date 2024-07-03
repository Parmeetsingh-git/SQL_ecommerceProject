/* In this sales and revenue analsysis I will try to find out the answer to the following quetions

1. Find the top 10 categories whose avg products price is expensive? Also do find cheapest 10 ?
2. Find the top 10 most ordered product categories?
3. Find out which payment method is most used for orders?
4. Find out the distribution of payment installments ?
5. Find the total orders yearly and monthly?
6. Find out the total sales revenue yearly and monthly?
7. Find out the average frieght paid by customers?
*/

--1. Find the top 10 categories whose avg products price is expensive? Also do find cheapest 10 ?
-- we have to join order_items with products and then with translation to get results in english

with exppd AS
(
select  pt.product_category_name, avg(oi.price) avg_price
from olist_order_items oi join olist_products pt 
on oi.product_id = pt.product_id
group by pt.product_category_name
order by avg_price DESC
limit 10
)
select exppd.product_category_name, nt.product_category_name_english, exppd.avg_price avg_price
from exppd join olist_product_name_translation nt 
on exppd.product_category_name = nt.product_category_name
order by avg_price desc;

-- observation computer category have most expensive products in average


with chpd AS
(
select pt.product_category_name, avg(oi.price) as avg_price
from olist_order_items oi join olist_products pt 
on oi.product_id = pt.product_id
group by pt.product_category_name
order by avg_price asc
limit 10
)
select chpd.product_category_name, nt.product_category_name_english, chpd.avg_price avg_price
from chpd join olist_product_name_translation nt 
on chpd.product_category_name = nt.product_category_name
order by avg_price asc;


-- observation house_comfort_2 or flowers category have cheapest products in average

--2. Find the top 10 most ordered product categories? 


with products_ordered as
(
select p.product_category_name, count(oi.product_id) productord
from olist_order_items oi join olist_products p
on oi.product_id = p.product_id
group by p.product_category_name
order by productord desc
limit 10
)

select po.product_category_name, nt.product_category_name_english, po.productord
from products_ordered po join olist_product_name_translation nt
on po.product_category_name = nt.product_category_name
order by po.productord desc

--observation : most order are from bed_bath_table category and least from security and services

--3. Find out which payment method is most used for orders?

with num_count as
(
select payment_type, count(order_id) num
from olist_order_payments
group by payment_type
order by num desc
)
,
total as
(
select count(order_id) tot
from olist_order_payments
)
select payment_type, num, (num :: float / tot) * 100 as percentage
from num_count, total

--observation : 73.9 percent of transsactions aare done through credit cards


--4. Find out the distribution of payment installments ?

with num_count as
(
select payment_installments, count(order_id) num
from olist_order_payments
group by payment_installments
order by payment_installments asc
)
,
total as
(
select count(order_id) tot
from olist_order_payments
)
select payment_installments, num, (num :: float / tot) * 100 as percentage
from num_count, total

-- Observation for 50% of the orders customers pay at once.

--5. Find the total orders yearly and monthly?

select  extract(year from order_purchase_timestamp) as year, count(order_id) as total_orders
from olist_orders
group by year


select  extract(month from order_purchase_timestamp) as month, count(order_id) as total_orders
from olist_orders
group by month
order by total_orders desc

-- oberservation : order sales are highest in the month August and least in the month of november

select  extract(month from order_purchase_timestamp) as month, extract(year from order_purchase_timestamp) as year, count(order_id) as total_orders
from olist_orders
group by  year, month


-- 6. Find out the total sales revenue yearly and monthly?

select sum(op.payment_value) as sales_revenue, extract(year from o.order_purchase_timestamp) as year
from olist_order_payments op join olist_orders o
on op.order_id = o.order_id
group by year
order by sales_revenue desc

--observation sales have increased in 2018 

select sum(op.payment_value) as sales_revenue, extract(month from o.order_purchase_timestamp) as month
from olist_order_payments op join olist_orders o
on op.order_id = o.order_id
group by month
order by sales_revenue desc


select sum(op.payment_value) as sales_revenue, extract(year from o.order_purchase_timestamp) as year, extract(month from o.order_purchase_timestamp) as month
from olist_order_payments op join olist_orders o
on op.order_id = o.order_id
group by year, month

--7. Find out the average frieght paid by customers?

select avg(freight_value)
from olist_order_items



select count(product_id)
from olist_products