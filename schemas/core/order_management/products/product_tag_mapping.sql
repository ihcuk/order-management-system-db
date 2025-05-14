-- Create Product-Tag Mapping Table if it doesn't exist
IF OBJECT_ID('order_management.product_tag_mapping', 'U') IS NULL
BEGIN
    CREATE TABLE order_management.product_tag_mapping (
        product_id INT NOT NULL,                                 -- Product ID
        tag_id INT NOT NULL,                                     -- Tag ID
        created_at DATETIME2 DEFAULT SYSDATETIME(),              -- Timestamp of the relationship creation
        PRIMARY KEY (product_id, tag_id),                        -- Composite primary key to ensure uniqueness
        FOREIGN KEY (product_id) REFERENCES order_management.products(product_id),
        FOREIGN KEY (tag_id) REFERENCES order_management.product_tags(tag_id)
    );

    -- Indexes for 'product_tag_mapping' table
    CREATE NONCLUSTERED INDEX IX_product_tag_mapping_product_id ON order_management.product_tag_mapping(product_id);
    CREATE NONCLUSTERED INDEX IX_product_tag_mapping_tag_id ON order_management.product_tag_mapping(tag_id);
END
GO
