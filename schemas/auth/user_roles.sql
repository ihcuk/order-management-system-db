-- User-Roles Mapping Table (many-to-many)
IF OBJECT_ID('auth.user_roles', 'U') IS NULL
BEGIN
    CREATE TABLE auth.user_roles (
        user_id INT NOT NULL,
        role_id INT NOT NULL,
        PRIMARY KEY (user_id, role_id),
        FOREIGN KEY (user_id) REFERENCES auth.users(user_id),
        FOREIGN KEY (role_id) REFERENCES auth.roles(role_id)
    );

    CREATE INDEX IX_user_roles_user_id ON auth.user_roles(user_id);
    CREATE INDEX IX_user_roles_role_id ON auth.user_roles(role_id);
END
GO