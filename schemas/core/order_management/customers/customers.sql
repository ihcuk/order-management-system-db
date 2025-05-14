-- Create Customers Table if it doesn't exist
IF (OBJECT_ID('order_management.customers', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.customers (
        customer_id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) NOT NULL,
        primary_email VARCHAR(254) NOT NULL UNIQUE,
        secondary_email VARCHAR(254),
        primary_phone VARCHAR(20) UNIQUE,
        secondary_phone VARCHAR(20),
        state NVARCHAR(100),
        country_code CHAR(2),
        pincode CHAR(10),
        created_at DATETIME2 DEFAULT SYSDATETIME(),
        updated_at DATETIME2 DEFAULT SYSDATETIME(),
        FOREIGN KEY (country_code) REFERENCES order_management.countries(country_code)
    );
    -- Indexes for performance
    CREATE NONCLUSTERED INDEX IX_customers_email ON order_management.customers(primary_email);
    CREATE NONCLUSTERED INDEX IX_customers_phone ON order_management.customers(primary_phone);
END
GO