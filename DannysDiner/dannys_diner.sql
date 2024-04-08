-- Q1 What is the total amount each customer spent at the restaurant? 
SELECT s.customer_id, SUM(m.price) AS total_spend
FROM sales AS s JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- Q2 How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) 
FROM sales
GROUP BY customer_id;


-- Q3 What was the first item from the menu purchased by each customer?
WITH first_order_cte AS 
(SELECT s.customer_id AS cust_id, m.product_name AS first_order, 
DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS sale_rank
FROM sales AS s JOIN menu AS m 
ON s.product_id=m.product_id)
SELECT cust_id, first_order 
FROM first_order_cte 
WHERE sale_rank=1
GROUP BY cust_id, first_order;


-- Q4 What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT s.product_id, m.product_name, COUNT(s.product_id) AS order_frequency
FROM sales AS s JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.product_id
ORDER BY order_frequency DESC LIMIT 1;


-- Q5 Which item was the most popular for each customer?
WITH purchase_counts_cte AS 
(SELECT s.customer_id AS cust_id, s.product_id, m.product_name AS prod_name, 
COUNT(m.product_id) AS purchase_frequency,
RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(m.product_id) DESC) AS frequency_rank
FROM sales AS s JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY s.customer_id,s.product_id)
SELECT cust_id, prod_name, purchase_frequency
FROM purchase_counts_cte
WHERE frequency_rank=1;


-- Q6 Which item was purchased first by the customer after they became a member?
WITH first_order_after_membership_cte AS 
(SELECT s.customer_id AS cust_id, s.order_date AS order_date, m.join_date, menu.product_name AS prod_name,
RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS purchase_chronology
FROM sales AS s JOIN members AS m 
ON s.customer_id = m.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date >= m.join_date)
SELECT  cust_id, order_date, prod_name
FROM first_order_after_membership_cte
WHERE purchase_chronology=1;

-- Q7 Which item was purchased just before the customer became a member?
WITH last_order_before_membership_cte AS 
(SELECT s.customer_id AS cust_id, s.order_date AS order_date, m.join_date, menu.product_name AS prod_name,
ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS purchase_chronology
FROM sales AS s JOIN members AS m 
ON s.customer_id = m.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date < m.join_date)
SELECT  cust_id, order_date, prod_name
FROM last_order_before_membership_cte
WHERE purchase_chronology=1;


-- Q8 What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id AS cust_id, COUNT(s.customer_id) AS order_quantity, SUM(menu.price) AS revenue
FROM sales AS s JOIN members AS m 
ON s.customer_id = m.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;


-- Q9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- how many points would each customer have?
WITH points_cte AS 
(SELECT s.customer_id AS cust_id, 
CASE 
	WHEN m.product_name='sushi' THEN m.price*20 
	ELSE m.price*10 END AS points
FROM sales AS s JOIN menu AS m
ON s.product_id = m.product_id)
SELECT  cust_id, SUM(points) 
FROM points_cte
GROUP BY cust_id;


-- Q10 In the first week after a customer joins the program (including their join date)
-- they earn 2x points on all items, not just sushi
-- how many points do customer A and B have at the end of January?
WITH points_cte AS 
(SELECT s.customer_id AS cust_id, s.order_date AS order_date,
CASE
	WHEN s.order_date BETWEEN members.join_date AND members.join_date+6 THEN m.price*20
	WHEN m.product_name='sushi' THEN m.price*20
	ELSE m.price*10 END AS points
FROM sales AS s JOIN menu AS m
ON s.product_id = m.product_id
JOIN members
ON s.customer_id = members.customer_id)
SELECT  cust_id, SUM(points) 
FROM points_cte
WHERE order_date <= '2021-01-31'
GROUP BY cust_id;