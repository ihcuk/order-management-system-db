-- Create Orders Table if it doesn't exist
IF (OBJECT_ID('order_management.orders', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.orders (
        order_id INT PRIMARY KEY IDENTITY(1,1),
        customer_id INT NOT NULL,
        order_date DATETIME2 DEFAULT SYSDATETIME(),
        status VARCHAR(50) CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
        total_amount DECIMAL(10,2) NOT NULL,
        currency_code CHAR(3),
        shipping_address_id INT,
        billing_address_id INT,
        FOREIGN KEY (customer_id) REFERENCES order_management.customers(customer_id),
        FOREIGN KEY (currency_code) REFERENCES order_management.currencies(currency_code),
        FOREIGN KEY (shipping_address_id) REFERENCES order_management.addresses(address_id),
        FOREIGN KEY (billing_address_id) REFERENCES order_management.addresses(address_id)
    );
    -- Indexes for performance
    CREATE NONCLUSTERED INDEX IX_orders_customer_id ON order_management.orders(customer_id);
    CREATE NONCLUSTERED INDEX IX_orders_status ON order_management.orders(status);
    CREATE NONCLUSTERED INDEX IX_orders_total_amount ON order_management.orders(total_amount);
END
GO