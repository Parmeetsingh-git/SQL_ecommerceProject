/* With the customer and seller tables we want to find the answer to the following questions:
1. What are the top 10 cities with most customers?
2. What are the top 10 states with most customers?
3. Find what top 10 cities come under what states?
4. What are the top 10 cities with most selles?
5. What are the top 10 states with most selles?
6. Find what top 10 cities come under what states?
7. Is there any relation between the geography of customers and sellers?
*/

--1. What are the top 10 cities with most customers?
--we will use customer unique id because we want to get total unique customers

select customer_city, count(customer_unique_id) as number_customers
from olist_customers
group by customer_city
order by number_customers DESC
limit 10;


--2. What are the top 10 states with most customers?

select customer_state, count(customer_unique_id) as number_customers
from olist_customers
group by customer_state
order by number_customers DESC
limit 10;

--3. Find what top 10 cities come under what states?

with topcities_cust AS
(SELECT customer_state, customer_city, count(customer_unique_id) as number_customers,
row_number() over (ORDER BY count(customer_unique_id) desc) as row_num
from olist_customers
group by customer_city,customer_state
)
select customer_state, customer_city, number_customers
from topcities_cust
where row_num<=10
ORDER BY customer_state, number_customers desc;

--oberseravtaion SP has 4 out of the top 10 cities with most customers

--4. What are the top 10 cities with most selles?

select seller_city, count(seller_id) as number_sellers
from olist_seller
group by seller_city
order by number_sellers DESC
limit 10;

--5. What are the top 10 states with most selles?

select seller_state, count(seller_id) as number_sellers
from olist_seller
group by seller_state
order by number_sellers DESC
limit 10;

--6 Find what top 10 cities come under what states?


with topcities_seller AS
(SELECT seller_state, seller_city, count(seller_id) as number_sellers,
row_number() over (ORDER BY count(seller_id) desc) as row_num
from olist_seller
group by seller_city,seller_state
)
select seller_state, seller_city, number_sellers
from topcities_seller
where row_num<=10
ORDER BY seller_state, number_sellers desc;

--observation 60% of the top 10 sellers are from state SP

-- there seems some discrepency between the number of sellers 127 in curitiba
-- and 124 for state and city curitiba
-- checking if any missing state names for cities



with descripency AS
(
select seller_state, seller_city, count (seller_id)
from olist_seller
group by seller_city, seller_state
)

select * from descripency
where seller_city like '%curitiba%'

-- obeservation curitiba is mention in dataset under two different states sp and pr


--7. Is there any relation between the geography of customers and sellers?

/* Sao paulo is the city with most customers and sellers 
A more detail obervation could be done from the gelocation table 
but since it has multiple duplicates for the zip code prefix we will not perform that analysis
*/


