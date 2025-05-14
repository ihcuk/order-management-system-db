-- Create Product Tags Table if it doesn't exist
IF OBJECT_ID('order_management.product_tags', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.product_tags (
        tag_id INT PRIMARY KEY IDENTITY(1,1),                  -- Unique Tag ID
        tag_name NVARCHAR(100) UNIQUE NOT NULL,                 -- Name of the tag (e.g., "New", "Sale", "Best Seller")
        created_at DATETIME2 DEFAULT SYSDATETIME()              -- Timestamp of tag creation
    );

    -- Index for 'product_tags' table
    CREATE NONCLUSTERED INDEX IX_product_tags_name ON order_management.product_tags(tag_name);
END
GO
