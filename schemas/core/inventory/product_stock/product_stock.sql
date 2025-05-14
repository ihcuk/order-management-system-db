-- Product Stock
IF OBJECT_ID('inventory.product_stock', 'U') IS NULL
BEGIN
    CREATE TABLE inventory.product_stock (
        stock_id INT PRIMARY KEY IDENTITY(1,1),
        product_id INT NOT NULL,
        warehouse_id INT NOT NULL,
        quantity INT NOT NULL CHECK (quantity >= 0),
        FOREIGN KEY (product_id) REFERENCES order_management.products(product_id),
        FOREIGN KEY (warehouse_id) REFERENCES inventory.warehouses(warehouse_id)
    );
    CREATE NONCLUSTERED INDEX IX_product_stock_product_id ON inventory.product_stock(product_id);
    CREATE NONCLUSTERED INDEX IX_product_stock_warehouse_id ON inventory.product_stock(warehouse_id);
END
GO