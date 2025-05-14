-- Create Discounts Table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'discounts' AND schema_id = SCHEMA_ID('payments'))
BEGIN
    CREATE TABLE payments.discounts (
        discount_id INT PRIMARY KEY IDENTITY(1,1),
        discount_code VARCHAR(50) UNIQUE NOT NULL,
        discount_percentage DECIMAL(5,2) CHECK (discount_percentage BETWEEN 0 AND 100),
        start_date DATETIME2,
        end_date DATETIME2
    );

    -- Indexes
    CREATE UNIQUE NONCLUSTERED INDEX IX_discounts_code ON payments.discounts(discount_code);
    CREATE NONCLUSTERED INDEX IX_discounts_start_end ON payments.discounts(start_date, end_date);
END
GO