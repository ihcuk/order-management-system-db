-- Create Addresses Table if it doesn't exist
IF (OBJECT_ID('order_management.addresses', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.addresses (
        address_id INT PRIMARY KEY IDENTITY(1,1),
        customer_id INT NOT NULL,
        address_line1 NVARCHAR(255) NOT NULL,
        address_line2 NVARCHAR(255),
        city NVARCHAR(100),
        state NVARCHAR(100),
        country_code CHAR(2),
        pincode CHAR(10),
        FOREIGN KEY (customer_id) REFERENCES order_management.customers(customer_id),
        FOREIGN KEY (country_code) REFERENCES order_management.countries(country_code)
    );
    -- Indexes for performance
    CREATE NONCLUSTERED INDEX IX_addresses_customer_id ON order_management.addresses(customer_id);
    CREATE NONCLUSTERED INDEX IX_addresses_pincode ON order_management.addresses(pincode);
END
GO