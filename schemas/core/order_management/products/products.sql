-- Create Products Table if it doesn't exist
IF (OBJECT_ID('order_management.products', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.products (
        product_id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(200) NOT NULL,
        description NVARCHAR(MAX),
        price DECIMAL(10,2) NOT NULL,
        currency_code CHAR(3) NOT NULL,
        stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT SYSDATETIME(),
        updated_at DATETIME2 DEFAULT SYSDATETIME(),
        FOREIGN KEY (currency_code) REFERENCES order_management.currencies(currency_code)
    );
    -- Indexes for performance
    CREATE NONCLUSTERED INDEX IX_products_name ON order_management.products(name);
    CREATE NONCLUSTERED INDEX IX_products_is_active ON order_management.products(is_active);
END
GO