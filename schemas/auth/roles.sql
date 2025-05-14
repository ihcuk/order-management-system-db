-- Roles Table
IF OBJECT_ID('auth.roles', 'U') IS NULL
BEGIN
    CREATE TABLE auth.roles (
        role_id INT PRIMARY KEY IDENTITY(1,1),
        role_name NVARCHAR(100) UNIQUE NOT NULL,  -- e.g., 'Admin', 'Support', 'Warehouse'
        description NVARCHAR(255)
    );

    CREATE UNIQUE INDEX IX_roles_role_name ON auth.roles(role_name);
END
GO