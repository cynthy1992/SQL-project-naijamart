CREATE TABLE naijcustomers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
);

CREATE TABLE naijamart_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES naijamart_customers(customer_id)
);

CREATE TABLE naijamart_order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(150),
    category VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
        REFERENCES naijamart_orders(order_id)
);

CREATE TABLE naijamart_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT
);

select * from naijamart_customers;

SELECT full_name, city, signup_date
FROM naijamart_customers
ORDER BY signup_date DESC
LIMIT 5;

SELECT product_name, category, unit_price
FROM naijamart_products
ORDER BY unit_price DESC
LIMIT 5;

SELECT order_status, COUNT(order_id) AS total_orders
FROM naijamart_orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM naijamart_products
WHERE category IN ('Electronics', 'Home Appliances')
GROUP BY category
ORDER BY avg_price DESC;

SELECT 
    o.order_id, 
    c.full_name, 
    o.order_date, 
    o.order_status
FROM naijamart_orders o
JOIN naijamart_customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id ASC;

SELECT 
    c.full_name, 
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM naijamart_customers c
JOIN naijamart_orders o ON c.customer_id = o.customer_id
JOIN naijamart_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 10;

SELECT c.full_name, c.city, c.state, c.signup_date
FROM naijamart_customers c
LEFT JOIN naijamart_orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.signup_date ASC;

SELECT p.product_name, p.category, p.unit_price
FROM naijamart_products p
LEFT JOIN naijamart_order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

ALTER TABLE naijamart_order_items
ALTER COLUMN product_id TYPE integer USING product_id::integer;
select * from naijamart_order_items;

SELECT 
    TO_CHAR(o.order_date, 'YYYY-MM') AS order_month, -- Use TO_CHAR(o.order_date, 'YYYY-MM') if using PostgreSQL
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM naijamart_orders o
JOIN naijamart_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY order_month
ORDER BY order_month ASC;

WITH CategoryRevenue AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM naijamart_products p
    JOIN naijamart_order_items oi ON p.product_id = oi.product_id
    JOIN naijamart_orders o ON oi.order_id = o.order_id
    WHERE o.order_status <> 'Cancelled'
    GROUP BY p.category, p.product_name
)
SELECT 
    category,
    product_name,
    total_revenue,
    RANK() OVER(PARTITION BY category ORDER BY total_revenue DESC) AS revenue_rank
FROM CategoryRevenue
ORDER BY category ASC, revenue_rank ASC;
