-- Retail Inventory & Sales Analytics Database Analytics

-- =============================================
-- 1. Sales Reports
-- =============================================

-- View: Monthly Sales Summary
CREATE OR REPLACE VIEW view_monthly_sales AS
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM Orders
WHERE status != 'Cancelled'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month DESC;

-- =============================================
-- 2. Product Performance
-- =============================================

-- View: Top Selling Products
CREATE OR REPLACE VIEW view_top_selling_products AS
SELECT 
    p.name AS product_name,
    p.category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.price_at_purchase) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_revenue DESC;

-- =============================================
-- 3. Inventory Insights
-- =============================================

-- View: Low Stock Alerts (threshold < 20)
CREATE OR REPLACE VIEW view_low_stock_alerts AS
SELECT 
    p.name AS product_name,
    i.stock_level,
    p.category,
    i.last_updated
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.stock_level < 20
ORDER BY i.stock_level ASC;

-- =============================================
-- 4. Customer Insights
-- =============================================

-- View: High Value Customers
CREATE OR REPLACE VIEW view_high_value_customers AS
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_amount) AS lifetime_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status != 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING SUM(o.total_amount) > 1000
ORDER BY lifetime_value DESC;
