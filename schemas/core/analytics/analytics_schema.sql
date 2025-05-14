-- Create schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'analytics')
BEGIN
    EXEC('CREATE SCHEMA analytics');
END
GO

-- Daily Sales Summary
IF OBJECT_ID('analytics.daily_sales', 'U') IS NULL
BEGIN
    CREATE TABLE analytics.daily_sales (
        sales_date DATE PRIMARY KEY,
        total_orders INT,
        total_revenue DECIMAL(12,2),
        total_refunds DECIMAL(12,2),
        net_revenue AS (total_revenue - total_refunds) PERSISTED
    );
END
GO
