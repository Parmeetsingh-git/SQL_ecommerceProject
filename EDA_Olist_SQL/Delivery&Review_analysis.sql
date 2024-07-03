/* the purpose of the order analysis is to answer the following questions to gather insights:
1. Find the avergare time it takes for the after the puchase for the payment to be approved?
2. FInd out the fastest and the slowest delivery days or time?
3. Find out the average devlivery time or days ?
4. Find the average difference between the actual delivery and estimated delivery?
5. Find out count of all reviews scores and the avergae review score per delivery?
6. Find the relation between delivery time and review score?
*/


--1. Find the avergare time it takes for the after the purchase for the payment to be approved?
-- alos find max and min


select MAX(order_approved_at - order_purchase_timestamp) as maxtime_approval FROM olist_orders
where order_status='delivered'
;


select MIN(order_approved_at - order_purchase_timestamp) as mintime_approval FROM olist_orders
where order_status='delivered'
;

-- we see 0 as result because there are orders when the purchase was approved at the same time

select * from olist_orders
where order_approved_at = order_purchase_timestamp;


select AVG(order_approved_at - order_purchase_timestamp) as avgtime_approval FROM olist_orders
where order_status='delivered'
;


--observation on average it took 10hrs and 16 minutes for the payment bee approved after the purchase was made by the customer


--2. FInd out the fastest and the slowest delivery days or time?
--3. Find out the average devlivery time or days ?

select max(order_delivered_customer_date - order_purchase_timestamp) as slowest_delivery from olist_orders
where order_status= 'delivered'
;

-- observation the slowest delivery took 209 days to deliver


-- lets also find out which order_id has the slowest delivery
select *, (order_delivered_customer_date - order_purchase_timestamp) as slowest_delivery from olist_orders
where order_status= 'delivered' and order_delivered_customer_date is not null
order by slowest_delivery DESC
limit 1
;

select min(order_delivered_customer_date - order_purchase_timestamp) as fastest_delivery from olist_orders
where order_status= 'delivered'
;

--observation fastest delivery time is 12 hours

--lets see which order_id had the fastest delivery

select *, (order_delivered_customer_date - order_purchase_timestamp) as fastest_delivery from olist_orders
where order_status= 'delivered' and order_delivered_customer_date is not null
order by fastest_delivery asc
limit 1
;

select avg(order_delivered_customer_date - order_purchase_timestamp) as average_delivery from olist_orders
where order_status= 'delivered'
;

-- observation average delivery time is 12 days and 13 hours


--4. Find the average difference between the actual delivery and estimated delivery?
--lests find max, min and avg and also chech which order_numbers had max and min

select avg(order_estimated_delivery_date - order_delivered_customer_date) as average_discrepency from olist_orders
where order_status= 'delivered'
;

--observation: 10 days discrepance on average

select max(order_estimated_delivery_date - order_delivered_customer_date) as max_discrepency from olist_orders
where order_status= 'delivered'
;


select *, (order_estimated_delivery_date - order_delivered_customer_date) as max_discrepency from olist_orders
where order_status= 'delivered' and order_delivered_customer_date is not null
order by max_discrepency DESC
limit 1
;

--observation: maximum 146 days discrepancy

select min(order_estimated_delivery_date - order_delivered_customer_date) as min_discrepency from olist_orders
where order_status= 'delivered'
;

select *, (order_estimated_delivery_date - order_delivered_customer_date) as min_discrepency from olist_orders
where order_status= 'delivered' and order_delivered_customer_date is not null
order by min_discrepency ASC
limit 1
;

--observation:  order was delivered 6 months after the estimated delivery date

--5. Find out count of all reviews scores and the percentage of  review score?

with starrating AS
(
select review_score, count(order_id) star_ratings from olist_order_reviews
group by review_score
order by star_ratings DESC
)
,
total as 
(
select count(order_id) as total from olist_order_reviews
)

select review_score, star_ratings, (star_ratings::float / total) * 100 as percentage_stars
from starrating, total;


--oberservation 57.7% of orders have 5 star rating and 11.5% of orders have 1 star rating

-- 6. Find the relation between delivery time and review score?

/* For this we need to join orders table and review table 
Lets find out how the ratings are effected if the delivery is done under 2 week and how the rating is effected by each week of non delivery
*/

with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime < INTERVAL '14 days'

--find avg_rating we use cte inside cte


with avgrating as
(with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime < INTERVAL '14 days'
)
select avg(review_score) from avgrating

-- Observation if the product is delivered with in 2 weeks the avg rating is 4.35



with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime between INTERVAL '14 days' and INTERVAL '21 days'
)
select avg(review_score) from avgrating

--observation if the delivery takes more than 2 weeks the avg rating drops to 4.1 

with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime between INTERVAL '21 days' and INTERVAL '28 days'
)

select avg(review_score) from avgrating

--observation if the delivery takes more than 3 weeks the avg rating drops to 3.6 

with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime  between INTERVAL '28 days' and INTERVAL '35 days'
)

select avg(review_score) from avgrating

--observation if the delivery takes more than 4 weeks the avg rating drops to 2.8

with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime > INTERVAL '35 days'

)

select avg(review_score) from avgrating

--observation if the delivery takes more than 5 weeks the avg rating drops to 1.9