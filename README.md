# Retail Inventory & Sales Analytics Database 📊

**A high-performance PostgreSQL database system designed for retail operations, featuring automated inventory management and real-time sales analytics.**

---

## 🚀 Project Overview

This project implements a normalized relational database for a retail business. Unlike a static database, it features **event-driven automation** using PostgreSQL Triggers to manage stock levels in real-time. It also includes a suite of optimized SQL Views to drive Business Intelligence (BI) dashboards.

**Key Features:**
*   **Automated Inventory Tracking**: Custom PL/pgSQL triggers automatically reduce stock on purchase and restore stock on order cancellation/modification.
*   **Dynamic Sales Analytics**: Pre-built aggregations for Monthly Sales, Top Products, and Customer Lifetime Value.
*   **Data Integrity**: Full ACID compliance with strict Foreign Key constraints and Cascade rules.
*   **Performance**: Optimized with B-Tree indexes on high-frequency query columns (dates, foreign keys).

---

## 🛠️ Tech Stack
*   **Database**: PostgreSQL 16
*   **Language**: SQL, PL/pgSQL
*   **Tools**: pgAdmin 4, Power BI (for Visualization)

---

## 📂 Database Schema

The system is built on a normalized snowflake schema:

1.  **Products**: Catalog information (Name, Category, Price).
2.  **Inventory**: Track stock levels (One-to-One with Products).
3.  **Customers**: CRM data.
4.  **Orders**: Transaction headers (Date, Status, Total).
5.  **Order_Items**: Transaction details (Product, Quantity, Price).

---

## ⚡ Automation Logic (The "Smart" Part)

The database handles business logic internally, preventing application-layer errors.

### Inventory Trigger (`trg_manage_stock`)
*   **On INSERT** (Buy): Checks stock availability -> Decrements Inventory.
*   **On DELETE** (Cancel): Automatically refunds quantity back to Inventory.
*   **On UPDATE** (Change): Adjusts inventory based on the net difference.

---

## 📊 Analytics & Reporting

The system exposes the following Views for BI tools (like Power BI/Tableau):

| View Name | Description |
| :--- | :--- |
| `view_monthly_sales` | Trends of Revenue and Order Volume over time. |
| `view_top_selling_products` | Ranking products by Total Revenue and Units Sold. |
| `view_low_stock_alerts` | Real-time list of products needing restock (< 20 units). |
| `view_high_value_customers` | Identifying VIP customers based on lifetime spend. |

---

## 🔧 How to Run

1.  **Clone the Repository**
2.  **Run Scripts in Order**:
    ```sql
    \i schema.sql    -- Builds tables
    \i logic.sql     -- Deploys triggers/functions
    \i seed.sql      -- Populates mock data
    \i analytics.sql -- Creates reporting views
    ```
3.  **Verify**:
    ```sql
    SELECT * FROM view_top_selling_products;
    ```
