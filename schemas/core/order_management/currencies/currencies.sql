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