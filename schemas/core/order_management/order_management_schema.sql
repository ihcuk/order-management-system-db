-- Create Schema if it doesn't exist
IF (SCHEMA_ID('order_management') IS NULL)
BEGIN
    EXEC('CREATE SCHEMA order_management');
END
GO

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

-- Create Countries Table if it doesn't exist
IF (OBJECT_ID('order_management.countries', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.countries (
        country_code CHAR(2) PRIMARY KEY,
        country_name NVARCHAR(100) NOT NULL
    );
    -- Sample data (can be modified or removed)
    INSERT INTO order_management.countries (country_code, country_name)
    VALUES
        ('US', 'United States'),
        ('IN', 'India'),
        ('GB', 'United Kingdom'),
        ('CA', 'Canada');
END
GO

-- Create Currencies Table if it doesn't exist
IF (OBJECT_ID('order_management.currencies', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.currencies (
        currency_code CHAR(3) PRIMARY KEY,
        currency_name NVARCHAR(100) NOT NULL
    );
    -- Sample data (can be modified or removed)
    INSERT INTO order_management.currencies (currency_code, currency_name)
    VALUES
        ('USD', 'US Dollar'),
        ('INR', 'Indian Rupee'),
        ('GBP', 'British Pound'),
        ('CAD', 'Canadian Dollar');
END
GO

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

-- Create Order Items Table if it doesn't exist
IF (OBJECT_ID('order_management.order_items', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.order_items (
        order_item_id INT PRIMARY KEY IDENTITY(1,1),
        order_id INT NOT NULL,
        product_id INT NOT NULL,
        quantity INT NOT NULL CHECK (quantity > 0),
        unit_price DECIMAL(10,2) NOT NULL,
        total_price AS (quantity * unit_price) PERSISTED,
        FOREIGN KEY (order_id) REFERENCES order_management.orders(order_id),
        FOREIGN KEY (product_id) REFERENCES order_management.products(product_id)
    );
    -- Indexes for performance
    CREATE NONCLUSTERED INDEX IX_order_items_order_id ON order_management.order_items(order_id);
    CREATE NONCLUSTERED INDEX IX_order_items_product_id ON order_management.order_items(product_id);
    CREATE NONCLUSTERED INDEX IX_order_items_quantity ON order_management.order_items(quantity);
END
GO