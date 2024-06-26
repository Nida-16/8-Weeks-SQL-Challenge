CREATE DATABASE dannys_diner;
USE dannys_diner;


CREATE TABLE members 
 (
 customer_id VARCHAR(2) PRIMARY KEY NOT NULL,
 join_date DATE default(CURRENT_DATE)
 );
 
INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


CREATE TABLE menu 
 (
 product_id INT PRIMARY KEY NOT NULL,
 product_name VARCHAR(15) NOT NULL,
 price INT NOT NULL
 );
 
 INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
 
 CREATE TABLE sales 
 (
customer_id VARCHAR(2) NOT NULL,
product_id INT NOT NULL,
order_date DATE NOT NULL default(CURRENT_DATE)
 );

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
