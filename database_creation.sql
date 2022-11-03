drop table "HOMEUSER"."AUTHOR" cascade constraints PURGE;
drop table "HOMEUSER"."BOOK" cascade constraints PURGE; 
drop table "HOMEUSER"."CUSTOMER" cascade constraints PURGE; 
drop table "HOMEUSER"."SHIPPING_METHOD" cascade constraints PURGE;
drop table "HOMEUSER"."CUST_ORDER" cascade constraints PURGE;
drop table "HOMEUSER"."ORDER_STATUS" cascade constraints PURGE;
drop table "HOMEUSER"."ORDER_HISTORY" cascade constraints PURGE;

create table author
(
    author_id NUMBER(2),
    author_name VARCHAR2(100),
    CONSTRAINT pk_author_ahmed_ben PRIMARY KEY (author_id)
);
 
CREATE TABLE book (
    book_id NUMBER(2),
    title VARCHAR2(400),
    language varchar2(30),
    num_pages NUMBER(5),
    publication_year NUMBER(4),
	price DECIMAL(6,2),
	author_id NUMBER(2),
	b_category varchar2(50),
	quantity NUMBER(5),
    CONSTRAINT pk_book PRIMARY KEY (book_id),
	CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES author (author_id)
);
 
CREATE TABLE customer (
    customer_id NUMBER(2),
    first_name VARCHAR2(200),
    last_name VARCHAR2(200),
	address VARCHAR2(30),
	address_id NUMBER(2),
	gender VARCHAR2(20),
	age NUMBER(2),
	country VARCHAR2(30),
    CONSTRAINT pk_customer PRIMARY KEY (customer_id)
);

 
CREATE TABLE shipping_method (
    method_id NUMBER(2),
    method_name VARCHAR2(100),
    cost DECIMAL(10, 2),
    CONSTRAINT pk_shipmethod PRIMARY KEY (method_id)
);
 
 CREATE TABLE order_status (
    status_id NUMBER(2),
    status_value VARCHAR2(20),
    CONSTRAINT pk_orderstatus PRIMARY KEY (status_id)
);
 
 
CREATE TABLE cust_order (
    order_id NUMBER(2),
    order_date DATE,
    customer_id NUMBER,
	book_id NUMBER(2),
	method_id NUMBER(2),
	total_price decimal(6,2),
    CONSTRAINT pk_custorder PRIMARY KEY (order_id),
    CONSTRAINT fk_order_cust12 FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
	CONSTRAINT fk_ol_book15 FOREIGN KEY (book_id) REFERENCES book (book_id),
	CONSTRAINT fk_ol_shipping FOREIGN KEY (method_id) REFERENCES shipping_method (method_id)
); 
 

CREATE TABLE order_history (
    history_id NUMBER(2),
    order_id NUMBER(2),
    status_id NUMBER(2),
    status_date DATE,
    CONSTRAINT pk_orderhist PRIMARY KEY (history_id),
    CONSTRAINT fk_oh_order FOREIGN KEY (order_id) REFERENCES cust_order (order_id),
    CONSTRAINT fk_oh_status FOREIGN KEY (status_id) REFERENCES order_status (status_id)
);