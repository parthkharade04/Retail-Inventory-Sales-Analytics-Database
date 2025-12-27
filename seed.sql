-- Seed Data for Retail Inventory & Sales Analytics Database

-- 1. Insert Customers
INSERT INTO Customers (first_name, last_name, email, phone, address) VALUES
('John', 'Doe', 'john.doe@example.com', '555-0101', '123 Maple St, Springfield, IL'),
('Jane', 'Smith', 'jane.smith@example.com', '555-0102', '456 Oak Ave, Metropolis, NY'),
('Michael', 'Johnson', 'michael.j@example.com', '555-0103', '789 Pine Rd, Gotham, NJ'),
('Emily', 'Davis', 'emily.davis@example.com', '555-0104', '321 Elm St, Star City, CA'),
('David', 'Wilson', 'david.wilson@example.com', '555-0105', '654 Cedar Ln, Central City, MO');

-- 2. Insert Products
INSERT INTO Products (name, category, price, description) VALUES
('Smartphone X', 'Electronics', 699.99, 'High-end smartphone with 128GB storage'),
('Laptop Pro', 'Electronics', 1299.00, 'Powerful laptop for professionals'),
('Wireless Earbuds', 'Electronics', 149.50, 'Noise-cancelling wireless earbuds'),
('Running Shoes', 'Apparel', 89.99, 'Lightweight running shoes size 10'),
('Cotton T-Shirt', 'Apparel', 19.99, '100% Cotton basic t-shirt'),
('Jeans Classic', 'Apparel', 49.99, 'Classic fit blue jeans'),
('Coffee Maker', 'Home & Kitchen', 79.99, 'Programmable coffee maker 12-cup'),
('Blender High-Speed', 'Home & Kitchen', 120.00, 'High-speed blender for smoothies'),
('Desk Lamp', 'Home & Kitchen', 35.00, 'LED desk lamp with adjustable brightness'),
('Gaming Chair', 'Furniture', 250.00, 'Ergonomic gaming chair with lumbar support');

-- 3. Insert Inventory
-- Linking to products by ID (Assuming sequential IDs 1-10 from above)
INSERT INTO Inventory (product_id, stock_level) VALUES
(1, 50),  -- Smartphone X
(2, 30),  -- Laptop Pro
(3, 100), -- Wireless Earbuds
(4, 75),  -- Running Shoes
(5, 200), -- Cotton T-Shirt
(6, 60),  -- Jeans Classic
(7, 40),  -- Coffee Maker
(8, 25),  -- Blender
(9, 80),  -- Desk Lamp
(10, 15); -- Gaming Chair

-- 4. Create some initial Orders (Historical Data)
INSERT INTO Orders (customer_id, order_date, status, total_amount) VALUES
(1, CURRENT_TIMESTAMP - INTERVAL '10 days', 'Delivered', 0), -- John Doe
(2, CURRENT_TIMESTAMP - INTERVAL '5 days', 'Shipped', 0),   -- Jane Smith
(3, CURRENT_TIMESTAMP - INTERVAL '1 day', 'Pending', 0);    -- Michael Johnson

-- 5. Insert Order Items for those orders
-- Order 1: John buys a Laptop and a Mouse (Mouse not in list, let's say Earbuds)
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 2, 1, 1299.00), -- 1x Laptop Pro
(1, 3, 2, 149.50);  -- 2x Wireless Earbuds

-- Order 2: Jane buys Running Shoes and T-Shirt
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(2, 4, 1, 89.99),   -- 1x Running Shoes
(2, 5, 3, 19.99);   -- 3x Cotton T-Shirt

-- Order 3: Michael buys a Gaming Chair
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(3, 10, 1, 250.00); -- 1x Gaming Chair

-- NOTE: The total_amount in Orders table is currently 0. 
-- In the next step, we will create a function/trigger to update this automatically,
-- or we can run a manual update for this seed data.
-- For now, let's manually update the seed totals to be consistent.
UPDATE Orders SET total_amount = 1598.00 WHERE order_id = 1; -- 1299 + (149.50*2)
UPDATE Orders SET total_amount = 149.96 WHERE order_id = 2;  -- 89.99 + (19.99*3)
UPDATE Orders SET total_amount = 250.00 WHERE order_id = 3;  -- 250.00
