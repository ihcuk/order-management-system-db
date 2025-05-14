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