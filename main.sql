SELECT * FROM view_top_selling_products;

SELECT name, stock_level FROM Inventory 
JOIN Products ON Inventory.product_id = Products.product_id 
WHERE name = 'Smartphone X';



-- Create a new order for Customer 1
INSERT INTO Orders (customer_id, status) VALUES (1, 'Pending');
-- Add 5 Smartphones to that order (Assuming Order ID is 4, as we seeded 3 previously)
-- We use a subquery to get the latest Order ID automatically
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) 
VALUES (
    (SELECT MAX(order_id) FROM Orders), 
    1, -- Product ID 1 (Smartphone X)
    5, -- Quantity
    699.99
);


--  Check stock again:
SELECT name, stock_level FROM Inventory 
JOIN Products ON Inventory.product_id = Products.product_id 
WHERE name = 'Smartphone X';


-- View Customer 1's Orders for "Smartphone X"
SELECT 
    o.order_id,
    o.order_date,
    p.name AS product_name,
    oi.quantity
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.customer_id = 1 
  AND p.name = 'Smartphone X';


DELETE FROM Orders 
WHERE order_id IN (
    SELECT o.order_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE o.customer_id = 1 
      AND p.name = 'Smartphone X'
);






-- update the order
-- Let's test the scenario where a customer changes their mind (e.g., "I only want 3 items, not 5").
SELECT p.name, i.stock_level 
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.product_id = 2;
-- or
SELECT stock_level FROM Inventory WHERE product_id = 2;


INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) 
VALUES (2, 2, 5, 1299.00); 
-- (We use Order ID 1 for simplicity, or pick any existing ID)


UPDATE Order_Items 
SET quantity = 3 
WHERE order_id = 2 AND product_id = 2 AND quantity = 5;


-- verify
SELECT p.name, i.stock_level 
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.product_id = 2;


DELETE FROM Orders 
WHERE order_id IN (
    SELECT o.order_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE o.customer_id = 1 
      AND p.name = 'Laptop Pro'
);