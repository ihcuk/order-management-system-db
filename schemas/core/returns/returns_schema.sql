-- Create schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'returns')
BEGIN
    EXEC('CREATE SCHEMA returns');
END
GO

-- Returns Table
IF OBJECT_ID('returns.returns', 'U') IS NULL
BEGIN
    CREATE TABLE returns.returns (
        return_id INT PRIMARY KEY IDENTITY(1,1),
        order_item_id INT NOT NULL,
        return_date DATETIME2 DEFAULT SYSDATETIME(),
        reason NVARCHAR(255),
        status NVARCHAR(50) CHECK (status IN ('requested', 'approved', 'rejected', 'refunded', 'restocked')),
        refund_amount DECIMAL(10,2),
        FOREIGN KEY (order_item_id) REFERENCES order_management.order_items(order_item_id)
    );
    CREATE NONCLUSTERED INDEX IX_returns_order_item_id ON returns.returns(order_item_id);
    CREATE NONCLUSTERED INDEX IX_returns_status ON returns.returns(status);
END
GO
