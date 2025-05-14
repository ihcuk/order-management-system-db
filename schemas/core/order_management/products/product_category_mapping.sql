-- Create Product-Category Mapping Table if it doesn't exist
IF OBJECT_ID('order_management.product_category_mapping', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.product_category_mapping (
        product_id INT NOT NULL,                                -- Product ID
        category_id INT NOT NULL,                               -- Category ID
        created_at DATETIME2 DEFAULT SYSDATETIME(),             -- Timestamp of the relationship creation
        PRIMARY KEY (product_id, category_id),                  -- Composite primary key to ensure uniqueness
        FOREIGN KEY (product_id) REFERENCES order_management.products(product_id),
        FOREIGN KEY (category_id) REFERENCES order_management.product_categories(category_id)
    );

    -- Indexes for 'product_category_mapping' table
    CREATE NONCLUSTERED INDEX IX_product_category_mapping_product_id ON order_management.product_category_mapping(product_id);
    CREATE NONCLUSTERED INDEX IX_product_category_mapping_category_id ON order_management.product_category_mapping(category_id);
END
GO
