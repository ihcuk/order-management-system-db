-- Role-Permissions Mapping Table (many-to-many)
IF OBJECT_ID('auth.role_permissions', 'U') IS NULL
BEGIN
    CREATE TABLE auth.role_permissions (
        role_id INT NOT NULL,
        permission_id INT NOT NULL,
        PRIMARY KEY (role_id, permission_id),
        FOREIGN KEY (role_id) REFERENCES auth.roles(role_id),
        FOREIGN KEY (permission_id) REFERENCES auth.permissions(permission_id)
    );

    CREATE INDEX IX_role_permissions_role_id ON auth.role_permissions(role_id);
    CREATE INDEX IX_role_permissions_permission_id ON auth.role_permissions(permission_id);
END
GO