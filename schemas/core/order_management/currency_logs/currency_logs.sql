-- Create Currency Logs Table if it doesn't exist
IF OBJECT_ID('order_management.currency_logs', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.currency_logs (
        log_id INT PRIMARY KEY IDENTITY(1,1),
        from_currency_code CHAR(3) NOT NULL,       -- Currency from which rate is changed
        to_currency_code CHAR(3) NOT NULL,         -- Currency to which rate is changed
        old_rate DECIMAL(18,6),                    -- Old exchange rate
        new_rate DECIMAL(18,6),                    -- New exchange rate
        changed_at DATETIME2 DEFAULT SYSDATETIME(), -- Timestamp when rate change occurred
        FOREIGN KEY (from_currency_code) REFERENCES order_management.currencies(currency_code),
        FOREIGN KEY (to_currency_code) REFERENCES order_management.currencies(currency_code)
    );

    CREATE INDEX IX_currency_logs_from_currency_code ON order_management.currency_logs(from_currency_code);
    CREATE INDEX IX_currency_logs_to_currency_code ON order_management.currency_logs(to_currency_code);
END
GO
