-- Retail Inventory & Sales Analytics Database Logic
-- 2.0 Updated to handle stock restoration on deletions

-- =============================================
-- 1. Automating Stock Updates (Robust)
-- =============================================

-- Drop existing trigger/function if they exist to avoid conflicts
DROP TRIGGER IF EXISTS trg_reduce_stock ON Order_Items;
DROP TRIGGER IF EXISTS trg_manage_stock ON Order_Items;
DROP FUNCTION IF EXISTS update_inventory_stock;

-- Function: Manage stock levels (Decrease on Buy, Increase on Cancel/Delete)
CREATE OR REPLACE FUNCTION manage_inventory_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Handle Adding Items (Buying)
    IF (TG_OP = 'INSERT') THEN
        -- Optional: Check stock availability (already checked implicitly by logic, but good practice)
        IF (SELECT stock_level FROM Inventory WHERE product_id = NEW.product_id) < NEW.quantity THEN
            RAISE EXCEPTION 'Insufficient stock for product_id %', NEW.product_id;
        END IF;

        UPDATE Inventory
        SET stock_level = stock_level - NEW.quantity,
            last_updated = NOW()
        WHERE product_id = NEW.product_id;
        
        RETURN NEW;

    -- Handle Removing Items (Deleting/Cancelling order)
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE Inventory
        SET stock_level = stock_level + OLD.quantity,
            last_updated = NOW()
        WHERE product_id = OLD.product_id;
        
        RETURN OLD;

    -- Handle Updates (Changing quantity in an existing order)
    ELSIF (TG_OP = 'UPDATE') THEN
        UPDATE Inventory
        SET stock_level = stock_level + OLD.quantity - NEW.quantity,
            last_updated = NOW()
        WHERE product_id = NEW.product_id;
        
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Fires on INSERT, UPDATE, or DELETE
CREATE TRIGGER trg_manage_stock
AFTER INSERT OR UPDATE OR DELETE ON Order_Items
FOR EACH ROW
EXECUTE FUNCTION manage_inventory_stock();


-- =============================================
-- 2. Automating Order Totals (Robust)
-- =============================================

DROP TRIGGER IF EXISTS trg_update_order_total ON Order_Items;
DROP TRIGGER IF EXISTS trg_update_order_total_robust ON Order_Items;

-- Function: Recalculate total amount for an order
CREATE OR REPLACE FUNCTION calculate_order_total()
RETURNS TRIGGER AS $$
DECLARE
    target_order_id INT;
BEGIN
    -- Determine which order_id to update based on the operation
    IF (TG_OP = 'DELETE') THEN
        target_order_id := OLD.order_id;
    ELSE
        target_order_id := NEW.order_id;
    END IF;

    -- Check if the Order still exists (in case the Order itself was deleted, we don't need to update it)
    PERFORM 1 FROM Orders WHERE order_id = target_order_id;
    IF FOUND THEN
        UPDATE Orders
        SET total_amount = (
            SELECT COALESCE(SUM(quantity * price_at_purchase), 0)
            FROM Order_Items
            WHERE order_id = target_order_id
        )
        WHERE order_id = target_order_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Fires on INSERT, UPDATE, or DELETE
CREATE TRIGGER trg_update_order_total
AFTER INSERT OR UPDATE OR DELETE ON Order_Items
FOR EACH ROW
EXECUTE FUNCTION calculate_order_total();
