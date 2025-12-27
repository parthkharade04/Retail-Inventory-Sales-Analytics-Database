-- Retail Inventory & Sales Analytics Database Schema

-- Drop tables if they exist to start fresh
DROP TABLE IF EXISTS Order_Items CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Inventory CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;

-- 1. Customers Table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Products Table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Inventory Table
CREATE TABLE Inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT UNIQUE NOT NULL REFERENCES Products(product_id) ON DELETE CASCADE,
    stock_level INT NOT NULL CHECK (stock_level >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES Customers(customer_id) ON DELETE SET NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(10, 2) DEFAULT 0.00
);

-- 5. Order_Items Table
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES Products(product_id) ON DELETE SET NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10, 2) NOT NULL
);

-- Indexes for Performance Optimization
CREATE INDEX idx_products_category ON Products(category);
CREATE INDEX idx_orders_customer ON Orders(customer_id);
CREATE INDEX idx_orders_date ON Orders(order_date);
CREATE INDEX idx_order_items_order ON Order_Items(order_id);
CREATE INDEX idx_order_items_product ON Order_Items(product_id);

COMMENT ON TABLE Customers IS 'Stores customer personal and contact information';
COMMENT ON TABLE Products IS 'Catalog of items sold by the retail store';
COMMENT ON TABLE Inventory IS 'Tracks current stock levels for each product';
COMMENT ON TABLE Orders IS 'Header information for customer orders';
COMMENT ON TABLE Order_Items IS 'Individual line items for each order';
