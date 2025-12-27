-- Massive Data Seed (Final Robust Version)
-- Variables renamed to avoid ambiguity

-- 1. Insert 50 Customers
INSERT INTO Customers (first_name, last_name, email, phone, address)
SELECT 
    'Customer' || s.id, 
    'User' || s.id, 
    'user' || s.id || '_' || FLOOR(RANDOM()*10000) || '@example.com',
    '555-0' || s.id, 
    'Address ' || s.id || ' Main St'
FROM generate_series(1, 50) AS s(id)
WHERE NOT EXISTS (SELECT 1 FROM Customers WHERE email LIKE 'user' || s.id || '_%');

-- 2. Insert New Products 
INSERT INTO Products (name, category, price, description)
SELECT name, category, price, description
FROM (VALUES 
    ('4K Monitor', 'Electronics', 299.99, '27-inch 4K IPS Monitor'),
    ('Mechanical Keyboard', 'Electronics', 89.99, 'RGB Mechanical Keyboard'),
    ('Webcam HD', 'Electronics', 59.99, '1080p Streaming Webcam'),
    ('Smart Watch', 'Electronics', 199.99, 'Fitness tracker and smartwatch'),
    ('Leather Jacket', 'Apparel', 120.00, 'Genuine leather jacket'),
    ('Sneakers Ltd', 'Apparel', 150.00, 'Limited edition sneakers'),
    ('Yoga Mat', 'Sports', 25.00, 'Non-slip yoga mat'),
    ('Dumbbells Set', 'Sports', 50.00, 'Set of 2 dumbbells 10lbs'),
    ('Protein Powder', 'Health', 45.00, 'Whey protein chocolate 2lbs'),
    ('Vitamin C', 'Health', 15.00, '1000mg Vitamin C tablets')
) AS v(name, category, price, description)
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE name = v.name);

-- 3. Heal Inventory
INSERT INTO Inventory (product_id, stock_level)
SELECT product_id, 1000
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM Inventory);

-- 4. SAFETY: Boost ALL stock
UPDATE Inventory SET stock_level = 1000;

-- 5. Generate 150 Orders (Fixed Variables)
DO $$
DECLARE
    _cust_id INT;
    _ord_id INT;
    _prod_id INT;
    _qty INT;
    _price DECIMAL;
    i INT;
    j INT;
BEGIN
    FOR i IN 1..150 LOOP
        -- Pick Random Customer
        SELECT customer_id INTO _cust_id FROM Customers ORDER BY RANDOM() LIMIT 1;
        
        -- Insert Order
        INSERT INTO Orders (customer_id, order_date, status, total_amount)
        VALUES (
            _cust_id, 
            NOW() - (FLOOR(RANDOM() * 365) || ' days')::interval,
            'Delivered',
            0
        ) RETURNING order_id INTO _ord_id;

        -- Insert Items
        FOR j IN 1..(FLOOR(RANDOM() * 4 + 1)::int) LOOP
            -- Pick Random Product
            SELECT p.product_id, p.price INTO _prod_id, _price 
            FROM Products p 
            ORDER BY RANDOM() LIMIT 1;
            
            _qty := FLOOR(RANDOM() * 3 + 1)::int;
            
            -- Insert Item
            INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
            VALUES (_ord_id, _prod_id, _qty, _price);
        END LOOP;
    END LOOP;
END $$;

-- 6. Set Low Stock
UPDATE Inventory SET stock_level = 5 WHERE product_id = (SELECT product_id FROM Products WHERE name = '4K Monitor' LIMIT 1);
UPDATE Inventory SET stock_level = 2 WHERE product_id = (SELECT product_id FROM Products WHERE name = 'Coffee Maker' LIMIT 1);
UPDATE Inventory SET stock_level = 0 WHERE product_id = (SELECT product_id FROM Products WHERE name = 'Smartphone X' LIMIT 1);
