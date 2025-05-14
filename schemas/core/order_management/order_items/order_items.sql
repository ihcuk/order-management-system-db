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