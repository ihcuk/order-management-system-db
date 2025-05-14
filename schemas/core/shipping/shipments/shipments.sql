-- Shipments
IF OBJECT_ID('shipping.shipments', 'U') IS NULL
BEGIN
    CREATE TABLE shipping.shipments (
        shipment_id INT PRIMARY KEY IDENTITY(1,1),
        order_id INT NOT NULL,
        provider_id INT,
        tracking_number NVARCHAR(100),
        shipped_date DATETIME2,
        estimated_delivery_date DATETIME2,
        actual_delivery_date DATETIME2,
        status NVARCHAR(50) CHECK (status IN ('pending', 'shipped', 'in_transit', 'delivered', 'returned')),
        FOREIGN KEY (order_id) REFERENCES order_management.orders(order_id),
        FOREIGN KEY (provider_id) REFERENCES shipping.providers(provider_id)
    );
    CREATE NONCLUSTERED INDEX IX_shipments_order_id ON shipping.shipments(order_id);
    CREATE NONCLUSTERED INDEX IX_shipments_tracking_number ON shipping.shipments(tracking_number);
END
GO