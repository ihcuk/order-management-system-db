-- Permissions Table (defining actions on resources)
IF OBJECT_ID('auth.permissions', 'U') IS NULL
BEGIN
    CREATE TABLE auth.permissions (
        permission_id INT PRIMARY KEY IDENTITY(1,1),
        permission_name NVARCHAR(100) UNIQUE NOT NULL,  -- e.g., 'view_order', 'edit_product'
        description NVARCHAR(255)
    );

    CREATE UNIQUE INDEX IX_permissions_permission_name ON auth.permissions(permission_name);
END
GO