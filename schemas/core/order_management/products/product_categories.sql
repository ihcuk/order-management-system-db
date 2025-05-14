-- Create Product Categories Table if it doesn't exist
IF OBJECT_ID('order_management.product_categories', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.product_categories (
        category_id INT PRIMARY KEY IDENTITY(1,1),             -- Unique Category ID
        category_name NVARCHAR(100) NOT NULL,                   -- Name of the category (e.g., Electronics, Clothing)
        description NVARCHAR(255),                              -- Description of the category
        parent_category_id INT NULL,                            -- Parent category for hierarchical categories
        created_at DATETIME2 DEFAULT SYSDATETIME(),             -- Timestamp of category creation
        updated_at DATETIME2 DEFAULT SYSDATETIME(),             -- Timestamp of last update
        FOREIGN KEY (parent_category_id) REFERENCES order_management.product_categories(category_id)  -- Recursive relationship for subcategories
    );

    -- Indexes for 'product_categories' table
    CREATE NONCLUSTERED INDEX IX_product_categories_name ON order_management.product_categories(category_name);
    CREATE NONCLUSTERED INDEX IX_product_categories_parent_id ON order_management.product_categories(parent_category_id);
END
GO
