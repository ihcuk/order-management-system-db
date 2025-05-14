-- Create Currencies Table if it doesn't exist
IF (OBJECT_ID('order_management.currencies', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.currencies (
        currency_code CHAR(3) PRIMARY KEY,
        currency_name NVARCHAR(100) NOT NULL
    );
    -- Sample data (can be modified or removed)
    INSERT INTO order_management.currencies (currency_code, currency_name)
    VALUES
        ('USD', 'US Dollar'),
        ('INR', 'Indian Rupee'),
        ('GBP', 'British Pound'),
        ('CAD', 'Canadian Dollar');
END
GO

-- Alter existing currencies table to add additional fields if not exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'order_management' AND TABLE_NAME = 'currencies' AND COLUMN_NAME = 'symbol')
BEGIN
    ALTER TABLE order_management.currencies
    ADD symbol NVARCHAR(10), -- Currency symbol (e.g., $, €, £)
        is_active BIT DEFAULT 1, -- Whether the currency is active
        created_at DATETIME2 DEFAULT SYSDATETIME(); -- Timestamp of creation
END
GO