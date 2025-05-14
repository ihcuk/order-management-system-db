-- Create FX Rates Table if it doesn't exist
IF OBJECT_ID('order_management.fx_rates', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.fx_rates (
        fx_rate_id INT PRIMARY KEY IDENTITY(1,1),
        from_currency_code CHAR(3) NOT NULL,           -- Currency code from which conversion is happening
        to_currency_code CHAR(3) NOT NULL,             -- Currency code to which conversion is happening
        rate DECIMAL(18,6) NOT NULL,                   -- Exchange rate between two currencies
        effective_date DATETIME2 NOT NULL,             -- Date when this rate was effective
        created_at DATETIME2 DEFAULT SYSDATETIME(),   -- Timestamp of rate entry
        FOREIGN KEY (from_currency_code) REFERENCES order_management.currencies(currency_code),
        FOREIGN KEY (to_currency_code) REFERENCES order_management.currencies(currency_code)
    );

    CREATE INDEX IX_fx_rates_from_currency_code ON order_management.fx_rates(from_currency_code);
    CREATE INDEX IX_fx_rates_to_currency_code ON order_management.fx_rates(to_currency_code);
    CREATE INDEX IX_fx_rates_effective_date ON order_management.fx_rates(effective_date);
END
GO
