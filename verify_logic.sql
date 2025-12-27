-- Logic Verification Script
-- Use this script to verify that the Stock Update Triggers work correctly (Update Scenario).

-- 1. Check Initial Stock of Laptop Pro (Product ID 2)
SELECT p.name, i.stock_level 
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.product_id = 2;

-- ... Note the stock level (e.g. 30) ...


-- 2. Scenario: Customer modifies an order (Reduces quantity from 5 down to 3)
-- First, ensure you have an order item to modify. 
-- (If you don't have one, run this INSERT first):
-- INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES (1, 2, 5, 1299.00);

-- Now, runs the UPDATE:
UPDATE Order_Items 
SET quantity = 3 
WHERE order_id = 1 AND product_id = 2;


-- 3. Verify Stock Automatically Increased
-- Since we reduced the order by 2 (5 -> 3), the stock should INCREASE by 2.
SELECT p.name, i.stock_level 
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.product_id = 2;
