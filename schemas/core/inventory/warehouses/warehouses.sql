-- Warehouses
IF OBJECT_ID('inventory.warehouses', 'U') IS NULL
BEGIN
    CREATE TABLE inventory.warehouses (
        warehouse_id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100),
        location NVARCHAR(200)
    );
END
GO