-- Create Transactions Table if it doesn't exist
IF OBJECT_ID('order_management.transactions', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.transactions (
        transaction_id INT PRIMARY KEY IDENTITY(1,1),
        order_id INT NOT NULL,                           -- Reference to the order
        transaction_amount DECIMAL(18,2) NOT NULL,       -- Amount in the base currency
        transaction_currency_code CHAR(3) NOT NULL,      -- Currency in which the transaction is made
        fx_rate_id INT,                                  -- Link to FX rate used for conversion (if applicable)
        converted_amount DECIMAL(18,2),                  -- Amount converted to another currency (if applicable)
        conversion_date DATETIME2 DEFAULT SYSDATETIME(),  -- Date when conversion occurred
        FOREIGN KEY (transaction_currency_code) REFERENCES order_management.currencies(currency_code),
        FOREIGN KEY (fx_rate_id) REFERENCES order_management.fx_rates(fx_rate_id)
    );

    CREATE INDEX IX_transactions_order_id ON order_management.transactions(order_id);
    CREATE INDEX IX_transactions_transaction_currency_code ON order_management.transactions(transaction_currency_code);
END
GO
