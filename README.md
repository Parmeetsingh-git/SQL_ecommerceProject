# OList E-Commerce Data Analysis SQL Project

## **Overview** 

Welcome to the Olist E-commerce Dataset Analysis Project. This project explores the rich dataset provided by Olist, a Brazilian e-commerce platform, focusing on customer orders, product information,reviews, seller inforamtion, geolocation and sales metrics. Through this analysis, I aim to uncover valuable insights into customer behavior, product performance, and overall business trends within the e-commerce domain.

### **Objective 1 - Database Design and Importing Data** 
The first objective is to import the data to a relational databse in Postgresql. There are 9 tables in this dataset by Olist which have a relation with each other. The following tasks will performed :
- Creating all tables in certain order so that the relationship between the tables can be established
- Choosing the adequate datatypes for the data set values
- Creating important primary keys and foreign keys for relationship among tables
- Importing data into tables with pariticular order to maintain relation.
- Create Entity Relationship Diagram (ERD) to show the table relations.

### **Objective 2 - Exploratory Data Analsyis**
After importing data to the tables, performaing a Exploratory Data Analysis with SQL queries and to answer question to create insights about the data. This will include the following analysis:
- Customer and Seller Analysis
- Delivery and Review Analysis
- Sales and Revenue Analysis

## **Dataset**

**Source**: [Link to Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Description**: 

This dataset is provided by Olist which can be downloaded from kaggle.com. This data set includes 9 CSV files which you can check out in [Dataset folder](/Olist_Dataset/). 

This is a Brazilian ecommerce public dataset of orders made at Olist Store. The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers. We also released a geolocation dataset that relates Brazilian zip codes to lat/lng coordinates.

This is real commercial data, it has been anonymised, and references to the companies and partners in the review text have been replaced with the names of Game of Thrones great houses.

## **Tools I Used**

**SQL**: The backbone of the project used for importing data and doing exploratory data analysis.

**Postgresql**: The database management system ideal for handling the Olist dataset.

**Visual Studio Code**: VS code is my go to Integrated development Enviroment (IDE) to manage database and executing queries.

**Git and Github**: Essential for project tracking and sharing sql queries and analysis. Used Git LFS for large .csv files shared in dataset folder.

**Tableau Public**: All the visualization of the results extracted from the sql queries are created in tableau public using different graphs and image of each graph is attached with link to the visualization.

## **Database Design and Importing Data**

### **Data Schema** 
A data schema is provided by Olist.

![Data Schema](Images/data_schema.png)

I used this Data schema to understand the data and to figure out the sequence in which the tables should be created and the data should be imported. Based on the understand this is the following sequency in which the tables should be created and data should be imported.

Geolocation->Customers/Sellers->Orders->Payments/reviews->Product_name_translation->Products->Oder_items

-> indicate the sequence

/ indicate that either table can be created first

You can check out the SQL files for creating tables and importing Olist data in sequence from   : [Setup Folder](/SQL_Olist_Setup/)

### **Table  Olist_geolocation**
This table cannot have zip_code_prefix as the primary key as there are duplicate values becasue for a particular zip code  there can be multiple corrdinates where the order could have been delivered. Due to the same reason this table cannot connect to other tables until this issue is resolved.
Since it doesnot have connection I can create this table first.

```sql
drop table if exists public.olist_geolocation;

create table public.olist_geolocation
(
    geolocation_zip_code_prefix int,
    geoloacation_lat float,
    geolocation_lng float,
    geolocation_city varchar(100),
    geolocation_state char(2)
    
);
```
To import data I used the follwing code:

```sql
copy public.olist_geolocation
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```
#### **Table Olist_Customers** 
The primary key for this table is Customer_ID and it has 99441 values

```sql

drop table if exists public.olist_customers;
 
create table public.olist_Customers
(
    customer_id varchar(100) primary key,
    customer_unique_id varchar(100),
    customer_zip_code_prefix int,
    customer_city varchar(100),
    customer_state char(2)
);


copy public.olist_Customers
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

### **Table Olist_sellers**

This table has seller_id as the primary key and has 3095 values.

```sql

drop table if exists public.Olist_seller;

create table public.Olist_seller 
(
    seller_id varchar(100) primary key,
    seller_zip_code_prefix int,
    seller_city varchar(100),
    seller_state char(2)
);

copy public.Olist_seller
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```
### ***Table Olist_Order***

This table has order_id as primary key and customer_id as foreign key.

```sql

drop table if EXISTS public.olist_orders;

create table public.olist_orders  
(
    order_id varchar(100) primary key,
    customer_id varchar(100),
    order_status varchar(100), 
    order_purchase_timestamp TIMESTAMP without time zone,
    order_approved_at TIMESTAMP without time zone,
    order_delivered_carrier_date TIMESTAMP without time zone,
    order_delivered_customer_date TIMESTAMP without time zone,
    order_estimated_delivery_date TIMESTAMP without time zone,
    foreign key(customer_id) references olist_Customers(customer_id)
);

copy public.olist_orders
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

```
### ***Table Olist_Order_reviews***

This table has order_id as foreign key.

```sql
drop table if EXISTS public.olist_order_reviews;

create table public.olist_order_reviews
(
    review_id VARCHAR(100),
    order_id varchar(100),
    review_score int,
    review_comment_title varchar(255),
    review_comment_message text,
    review_creation_date TIMESTAMP without time zone,
    review_answer_timestamp TIMESTAMP without time zone,
    foreign key (order_id) references olist_orders(order_id)
)

copy public.olist_order_reviews
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

### ***Table Olist_Order_payments***
This table has order_id as foreign key.
```sql
drop table if EXISTS public.olist_order_payments;

create table public.olist_order_payments 
(
    order_id varchar(100),
    payment_sequential int,
    payment_type varchar(100),
    payment_installments int,
    payment_value numeric(10,2),
    foreign key(order_id) references olist_orders(order_id)
)

copy public.olist_order_payments
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```
### ***Table Olist_product_name_translation***

This table has Product_category_name as the primary key which has 73 values

```sql
drop table if exists public.olist_product_name_translation;

create table public.olist_product_name_translation
(
    product_category_name varchar(100) primary key,
    product_category_name_english varchar(100)
);
```
This dataset had inconsistency as 2 values : pc_gamer,pc_gamer and 
portateis_cozinha_e_preparadores_de_alimentos,kitchen_and_food_portables were missing which were present in the product table so I manually entered the values in .csv file

![Manual_edit](/Images/Manual_edit.png)

```sql
copy public.olist_product_name_translation
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```
#### ***Table Olist_products***
This table has product_id as primary key with values 32951 and product_category_name as foreign key. 
```sql
drop table if EXISTS public.olist_products;

create table public.olist_products
(
    product_id varchar(100) primary key,
    product_category_name varchar(100),
    product_name_lenght int,
    product_description_lenght int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int,
    foreign key (product_category_name) references olist_product_name_translation(product_category_name)
);

copy public.olist_products
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```
### ***Table Olist_products***

This is the last table to be creted as it has relations with three tables with order_id, seller_id and Product_id as its foreign keys

```sql
drop table if exists public.olist_order_items;

create table public.olist_order_items
(
    order_id VARCHAR(100),
    order_item_id int,
    product_id VARCHAR(100),
    seller_id VARCHAR(100),
    shipping_limit_date TIMESTAMP without time zone,
    price numeric(10,2),
    freight_value numeric(10,2),
    foreign key (order_id) references olist_orders(order_id),
    foreign key (product_id) references olist_products(product_id),
    foreign key (seller_id) references Olist_seller(seller_id)
);

copy public.olist_order_items
from '/Users/parmeetsingh/developer/SQL_ecommerceProject/Olist_Dataset/olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```
Have created indexes for foreign keys in order to optimize performance by reducing the amount of data to be scanned and also increasing efficiency for join operations
```sql
create index idx_customer_id on public.olist_orders(customer_id);
create index idx_order_id on public.olist_order_reviews(order_id);
create index idx_order_id_payment on public.olist_order_payments(order_id);
create index idx_product_category_name on public.olist_products(product_category_name);
create index idx_order_id_items on public.olist_order_items(order_id);
create index idx_product_id on public.olist_order_items(product_id);
create index idx_seller_id_items on public.olist_order_items(seller_id);
```

### **Entity Relationship Diagram** 

This diagram illustrates all the relations between the different tables that I created.

![ERD](/Images/Entity_relationship_diagram.png)


## **Exploratory Data Analysis**

The second objective is to do Exploratory Data Analysis and find out the answers to the questions which will help gain insights. There are three different analysis based on the data to better understand overall e-commerce business.

- **Customer and Seller Analysis** [SQL File](/EDA_Olist_SQL/Customer&seller_analysis.sql)

- **Delivery and Review Analysis** [SQL File](/EDA_Olist_SQL/Delivery&Review_analysis.sql)

- **Sales and Revenue Analysis** [SQL File](/EDA_Olist_SQL/Sales&Revenue_analysis.sql)

### **Customer and Seller Analysis**
    
 Questions to be answer for this analysis are as follows:

1. What are the top 10 cities with most customers?
2. What are the top 10 states with most customers?
3. Find what top 10 cities come under what states?
4. What are the top 10 cities with most selles?
5. What are the top 10 states with most selles?
6. Find what top 10 cities come under what states?
7. Is there any relation between the geography of customers and sellers?


 **1. What are the top 10 cities with most customers?**

 ```SQL 
 select customer_city, count(customer_unique_id) as number_customers
from olist_customers
group by customer_city
order by number_customers DESC
limit 10;
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_ca1/CA1?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

![Customer Distribution by City](/Images/sql_olist_ca1.png)

Observation 

Sao Paulo has the largert customer base for Olist. 

 **2. What are the top 10 states with most customers?**

 ```SQL 
select customer_state, count(customer_unique_id) as number_customers
from olist_customers
group by customer_state
order by number_customers DESC
limit 10;
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_ca2/Sheet2?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

![Customer Distribution by State](/Images/sql_olist_ca2.png)

Observation 

State of São Paulo has the largert customer base for Olist. 

 **3. Find what top 10 cities come under what states?**

 ```SQL 
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
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_ca3/sql_olist_ca3?:language=en-US&publish=yes&:sid=DDB1BB01944B494EAEF994CEE9CE8F20-0:0&:display_count=n&:origin=viz_share_link)

![Customer Distribution by State and City](/Images/sql_olist_ca3.png)

Observation 

State of São Paulo has the 4 cities which have largest customer base for Olist.


**4. What are the top 10 cities with most selles?**

```SQL 
select seller_city, count(seller_id) as number_sellers
from olist_seller
group by seller_city
order by number_sellers DESC
limit 10;
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_ca4/sql_olist-ca4?:language=en-US&publish=yes&:sid=59EF1F11C9604755A2F66995E7F82922-0:0&:display_count=n&:origin=viz_share_link)

![Customer Distribution by State and City](/Images/sql_olist_ca4.png)

Observation 

 São Paulo has the most number of sellers for Olist.


**5. What are the top 10 states with most selles?**

```SQL 
select seller_state, count(seller_id) as number_sellers
from olist_seller
group by seller_state
order by number_sellers DESC
limit 10;
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_ca5/sql_olist_ca5?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

![Customer Distribution by State and City](/Images/sql_olist_ca5.png)

Observation 

 State of São Paulo has the most number of sellers for Olist.

**6. Find what top 10 cities come under what states?**

```SQL 
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

```
Visualization [Link](https://public.tableau.com/views/Sql_olist_ca6/sql_olist_ca6?:language=en-US&publish=yes&:sid=AF79A65D9BFA478B85589D8C110B0834-0:0&:display_count=n&:origin=viz_share_link)

![Customer Distribution by State and City](/Images/sql_olist_ca6.png)

Observation 

60% of the top 10 sellers are from the State of Sao Paulo.

Also from the visualizations it is clear that State of Sao Paulo and city of Sao Pualo has the largest customer and seller base. For further analysis I could use the geolocation table but due to prefix zip code dupliaction avoiding it.


### **Delivery and Review Analysis**
    
 Questions to be answer for this analysis are as follows:

1. Find the avergare time it takes for the after the puchase for the payment to be approved?
2. FInd out the fastest and the slowest delivery days or time?
3. Find out the average devlivery time or days ?
4. Find the average, max, min difference between the actual delivery and estimated delivery?
5. Find out count of all reviews scores and the avergae review score per delivery?
6. Find the relation between delivery time and review score?


**1. Find the avergare time it takes for the after the puchase for the payment to be approved?**

```SQL 

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

```
Results

For Max
```Json
{ "days": 30, "hours": 21, "minutes": 26, "seconds": 37}
```
For Min
```Json
{}
```
The MIN value is 0 because purchase time and order time is same for some orders.

For Avg
```Json
{ "hours": 10, "minutes": 16, "seconds": 36, "milliseconds": 361.244}
```

Observation 

On average it took 10hrs and 16 minutes for the payment bee approved after the purchase was made by the customer.

**2. FInd out the fastest and the slowest delivery days or time?**
**3. Find out the average devlivery time or days ?**

For Slowest
```SQL 
select max(order_delivered_customer_date - order_purchase_timestamp) as slowest_delivery from olist_orders
where order_status= 'delivered'
;

```
Results

```Json
{"days": 209,"hours": 15,"minutes": 5,"seconds": 12}
```
For fastest
```SQL 
select min(order_delivered_customer_date - order_purchase_timestamp) as fastest_delivery from olist_orders
where order_status= 'delivered'
;
```
Results

```Json
{"hours": 12, "minutes": 48,"seconds": 7}
```

For Avg
```SQL 
select avg(order_delivered_customer_date - order_purchase_timestamp) as average_delivery from olist_orders
where order_status= 'delivered'
;
```
Results

```Json
{"days": 12, "hours": 13, "minutes": 23, "seconds": 49, "milliseconds": 957.272
}
```
In the sql file for Delivery and Review analysis [link](/EDA_Olist_SQL/Delivery&Review_analysis.sql) I have also find out which order and customer had the fastest and the slowest delivery.

**4. Find the average, max, min difference between the actual delivery and estimated delivery?**

For AVG
```SQL 
select avg(order_estimated_delivery_date - order_delivered_customer_date) as average_discrepency from olist_orders
where order_status= 'delivered'
;

```
Results

```Json
{"days": 10,"hours": 28, "minutes": 16, "seconds": 30, "milliseconds": 62.973}

```
On average product is delivered 10 days before the estimated delivery date.

For Max
```SQL 
select max(order_estimated_delivery_date - order_delivered_customer_date) as max_discrepency from olist_orders
where order_status= 'delivered'
;

```
Results

```Json
{
  "max_discrepency": { "days": 146,  "minutes": 23, "seconds": 13}
}
```
A product was delivered 146 days prior to the estimated delivery time. Refer to [sql file](/EDA_Olist_SQL/Delivery&Review_analysis.sql) to find which order and customers had this delivery.


For MIN
```SQL 
select min(order_estimated_delivery_date - order_delivered_customer_date) as min_discrepency from olist_orders
where order_status= 'delivered'
;
```
Results

```Json
{ "days": -188,"hours": -23, "minutes": -24,"seconds": -7
}
```
A product was delivered 6 months after the estimated delivery time. Negative days means the product was delivered after the estimated date of delivery. Refer to [sql file](/EDA_Olist_SQL/Delivery&Review_analysis.sql) to find which order and customers had this delivery.


**5. Find out count of all reviews scores and the percentage of  review score?**

```SQL 
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
```

Visualization [Link](https://public.tableau.com/views/Sql_olist_dra5/sql_olist_dra5?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

![Rating Analysis](/Images/sql_olist_dra5.png)

**6. Find the relation between delivery time and review score?**

Checking the Avg score if delivered within first two weeks
```SQL 
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
```
Result
```json
{ "avg": "4.3533371570018414"}
```
Observation 

Observation if the product is delivered with in 2 weeks the avg rating is 4.35

Checking the Avg score if delivered between 2 and 3 weeks
```SQL 
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
```
Result
```json
{ "avg": "4.1396386222473179"}
```
Observation 

Observation if the product is delivered with in 2 weeks to 3 weeks the avg rating drops to 4.13

Checking the Avg score if delivered between 3 and 4 weeks
```SQL 
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
```
Result
```json
{ "avg": "3.6899055918663762"}
```
Observation 

Observation if the product is delivered with in 3 weeks to 4 weeks the avg rating drops to 3.6

Checking the Avg score if delivered between 4 and 5 weeks
```SQL 
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

```
Result
```json
{ "avg": "2.8450144508670520"}
```
Observation 

Observation if the product is delivered with in 4 weeks to 5 weeks the avg rating drops to 2.8

Checking the Avg score if delivered after 5 weeks
```SQL 
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

```
Result
```json
{"avg": "1.9714912280701754"}
```
Observation 

Observation if the product is delivered after 5 weeks the avg rating drops to 1.9

### **Sales and Revenue Analysis**
Questions to be answer for this analysis are as follows:
1. Find the top 10 categories whose avg products price is expensive? Also do find cheapest 10 ?
2. Find the top 10 most ordered product categories?
3. Find out which payment method is most used for orders?
4. Find out the distribution of payment installments ?
5. Find the total orders yearly and monthly?
6. Find out the total sales revenue yearly and monthly?
7. Find out the average frieght paid by customers?

**1. Find the top 10 categories whose avg products price is expensive? Also do find cheapest 10 ?**

Most Expensive Categories by average product price.
```SQL
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
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_sra1/sql_olist_sra1?:language=en-US&publish=yes&:sid=A25C7CE7FFA24CFB925B32F0BB0DD354-0:0&:display_count=n&:origin=viz_share_link)

![Most Expensive Category](/Images/sql_olist_sra1.png)

Least Expensive Categories by average product price.

```SQL
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
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_sra1_2/sql_olist_sra1_2?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

![Least Expensive Category](/Images/sql_olist_sra1.2.png)

**2. Find the top 10 most ordered product categories?**

```SQL
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
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_sra2/sql_olist_sra2?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

![TOP 10 PRODUCTS](/Images/sql_olist_sra2.png)

**4. Find out the distribution of payment installments ?**
```SQL
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
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_sra4/sql_olist_sra4?:language=en-US&publish=yes&:sid=7E3EF5692A8646BDB37F44258913749D-0:0&:display_count=n&:origin=viz_share_link)
![Payment Installment Distribution](/Images/sql_olist_sra4.png)

**5. Find the total orders yearly and monthly?**
```SQL
select  extract(month from order_purchase_timestamp) as month, extract(year from order_purchase_timestamp) as year, count(order_id) as total_orders
from olist_orders
group by  year, month
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_sra5/sql_olist_sra5?:language=en-US&publish=yes&:sid=D9F43BE037DE44A791065067CF1D7E16-0:0&:display_count=n&:origin=viz_share_link)
![YEARLY AND MONTHLY ORDER SALES](/Images/sql_olist_sra5.png)

For yearly and monthkly seperate analysis refer to [SQL FILE](/EDA_Olist_SQL/Sales&Revenue_analysis.sql)


**6. Find out the total sales revenue yearly and monthly?**

```SQL
select sum(op.payment_value) as sales_revenue, extract(year from o.order_purchase_timestamp) as year, extract(month from o.order_purchase_timestamp) as month
from olist_order_payments op join olist_orders o
on op.order_id = o.order_id
group by year, month
```
Visualization [Link](https://public.tableau.com/views/Sql_olist_sra6/sql_olist_sra6?:language=en-US&publish=yes&:sid=A776E2BC34D44D6AAA0E79137B8CF4F4-0:0&:display_count=n&:origin=viz_share_link)
![YEARLY AND MONTHLY ORDER SALES](/Images/sql_olist_sra6.png)

For yearly and monthkly seperate analysis refer to [SQL FILE](/EDA_Olist_SQL/Sales&Revenue_analysis.sql)

**7. Find out the average frieght paid by customers?**

```SQL
select avg(freight_value)
from olist_order_items
```
Result
```json
{"avg": "19.9903199289835775"}
```
Observation 

On avergare R$19.9 frieght charges are there per order.

## **Executive summary**

### **Database design and importing data**

This part of the project includes using the schema provide by the Olist dataset to establish the follwing tasks:
- Using the data in different csv files to import into seperate tables using the given schema.
- Creating tables in order so that these relationships can be established and data can be imported in a logical order.
- Asigning adequate data types such as int, numeeric, varchar, timestamp etc to the tables so that it is easies to perform functions usch as joins to the tables.
- Creating a Entity relationship diagram and then comparing it to the schema provided.

After this part the data is avalabl ein a form that can be used for exploratory data analysis.

### **Exploaratory Data Analysis**

This part of the project includes exploring the data using postgres and then visualizing it in tableau.

- Gaining insights using questions for each segment of this analysis.
- Finding the different geographical distribution of customers and sellers.
- Analysing sales and revenue as well as product distribution.
- Understanding the delivery timings and its effect on reviews

Various SQl techniques are used in order to perform these analysis such as:

- Joins are used for  different tables to get required results.
- CTE common tabke expression is used for table manuplation.
- Aggregate functions used such as avg, max, min for analysis.
- Subqueries and Group By clauses used with other basic operations like to extract order and filter data.

Tableau public for Visualization

- Results from sql queries are stores as csv files and used for visualization.
- Diffferet charts such as area chart, bar chart, pie chart, treemaps and packed bubbles are used for interactive visualization.

## **Acknowledgements**

**Kaggle and Olist:**
For providing the Olist E-commerce dataset, which served as the foundation for this analysis. The dataset, made available on Kaggle, was instrumental in conducting this research. Special thanks to Olist for compiling and sharing such a comprehensive and valuable dataset.