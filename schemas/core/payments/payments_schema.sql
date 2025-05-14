-- Create Payments Schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'payments')
BEGIN
    EXEC('CREATE SCHEMA payments');
END
GO

-- Create Payments Table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'payments' AND schema_id = SCHEMA_ID('payments'))
BEGIN
    CREATE TABLE payments.payments (
        payment_id INT PRIMARY KEY IDENTITY(1,1),
        order_id INT NOT NULL,
        payment_date DATETIME2 DEFAULT SYSDATETIME(),
        amount DECIMAL(10,2) NOT NULL,
        method VARCHAR(50),
        status VARCHAR(50) CHECK (status IN ('pending', 'completed', 'failed')),
        transaction_reference VARCHAR(100),
        FOREIGN KEY (order_id) REFERENCES order_management.orders(order_id)
    );

    -- Indexes
    CREATE NONCLUSTERED INDEX IX_payments_order_id ON payments.payments(order_id);
    CREATE NONCLUSTERED INDEX IX_payments_status ON payments.payments(status);
    CREATE NONCLUSTERED INDEX IX_payments_payment_date ON payments.payments(payment_date);
    CREATE NONCLUSTERED INDEX IX_payments_transaction_reference ON payments.payments(transaction_reference);
END
GO

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

-- Create Coupons Table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'coupons' AND schema_id = SCHEMA_ID('payments'))
BEGIN
    CREATE TABLE payments.coupons (
        coupon_id INT PRIMARY KEY IDENTITY(1,1),
        coupon_code VARCHAR(50) UNIQUE NOT NULL,
        discount_id INT NOT NULL,
        usage_limit INT NOT NULL,
        FOREIGN KEY (discount_id) REFERENCES payments.discounts(discount_id)
    );

    -- Indexes
    CREATE UNIQUE NONCLUSTERED INDEX IX_coupons_code ON payments.coupons(coupon_code);
    CREATE NONCLUSTERED INDEX IX_coupons_discount_id ON payments.coupons(discount_id);
END
GO
