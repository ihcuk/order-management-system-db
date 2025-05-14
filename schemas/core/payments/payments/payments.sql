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