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