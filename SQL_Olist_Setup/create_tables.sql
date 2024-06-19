
--drop table if it already exists to ensure multiple runs and clean slate

drop table if exists public.olist_geolocation;

/* create table olist_geolocation table with no primary key
 because zip code prefix has duplicate values.
Also this table cannot be joined with olist_seller or olist_customers table 
through zip code prefix because it has duplicate values */

create table public.olist_geolocation
(
    geolocation_zip_code_prefix int,
    geoloacation_lat float,
    geolocation_lng float,
    geolocation_city varchar(100),
    geolocation_state char(2)
    
);

--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.Olist_seller;

--create table Olist_seller table with primary key 

create table public.Olist_seller 
(
    seller_id varchar(100) primary key,
    seller_zip_code_prefix int,
    seller_city varchar(100),
    seller_state char(2)
);

--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.olist_customers;

--create table olist_Customers with primary key 

create table public.olist_Customers
(
    customer_id varchar(100) primary key,
    customer_unique_id varchar(100),
    customer_zip_code_prefix int,
    customer_city varchar(100),
    customer_state char(2)
);

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_orders;

--create table olist_orders table with primary key and foreign key

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

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_order_reviews;

/* create table olist_order_review with foreign key
review_id and order_id has duplicate values so it cannot be primary key
*/

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

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_order_payments;

--create table olist_order_payments with foreign key

create table public.olist_order_payments 
(
    order_id varchar(100),
    payment_sequential int,
    payment_type varchar(100),
    payment_installments int,
    payment_value numeric(10,2),
    foreign key(order_id) references olist_orders(order_id)
)

--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.olist_product_name_translation;

--create table olist_product_name_translation with primary key

create table public.olist_product_name_translation
(
    product_category_name varchar(100) primary key,
    product_category_name_english varchar(100)
);

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_products;

-- create table olist_products with pimary key and foreign key

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


--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.olist_order_items;

-- create table olist_order_items with primary key and foreign keys

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



/* creating indexes for foreign keys in order to optimize performance
by reducing the amount of data to be scanned and also increasing efficiency
for join operations */


create index idx_customer_id on public.olist_orders(customer_id);
create index idx_order_id on public.olist_order_reviews(order_id);
create index idx_order_id_payment on public.olist_order_payments(order_id);
create index idx_product_category_name on public.olist_products(product_category_name);
create index idx_order_id_items on public.olist_order_items(order_id);
create index idx_product_id on public.olist_order_items(product_id);
create index idx_seller_id_items on public.olist_order_items(seller_id);



