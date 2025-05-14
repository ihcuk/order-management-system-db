-- Create auth schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'auth')
BEGIN
    EXEC('CREATE SCHEMA auth');
END
GO

-- Users Table
IF OBJECT_ID('auth.users', 'U') IS NULL
BEGIN
    CREATE TABLE auth.users (
        user_id INT PRIMARY KEY IDENTITY(1,1),
        username NVARCHAR(100) UNIQUE NOT NULL,
        password_hash NVARCHAR(255) NOT NULL,  -- Store hashed passwords
        email NVARCHAR(254) UNIQUE,  -- Unique email for users
        is_active BIT DEFAULT 1,  -- Whether the user account is active
        created_at DATETIME2 DEFAULT SYSDATETIME(),
        last_login DATETIME2,
        created_by INT,  -- Optionally track who created the user
        FOREIGN KEY (created_by) REFERENCES auth.users(user_id)  -- Self-reference for user creation
    );

    CREATE UNIQUE INDEX IX_users_username ON auth.users(username);
    CREATE INDEX IX_users_email ON auth.users(email);
END
GO

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

-- Audit Logs Table (tracking who did what and when)
IF OBJECT_ID('auth.audit_logs', 'U') IS NULL
BEGIN
    CREATE TABLE auth.audit_logs (
        log_id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT NOT NULL,
        action NVARCHAR(255) NOT NULL,  -- e.g., 'updated order', 'deleted product'
        entity_type NVARCHAR(100) NOT NULL,  -- e.g., 'order', 'product'
        entity_id INT NOT NULL,            -- ID of the entity being modified
        old_data NVARCHAR(MAX),           -- Previous state (for update actions)
        new_data NVARCHAR(MAX),           -- New state (for update actions)
        timestamp DATETIME2 DEFAULT SYSDATETIME(),
        FOREIGN KEY (user_id) REFERENCES auth.users(user_id)
    );

    CREATE INDEX IX_audit_logs_user_id ON auth.audit_logs(user_id);
    CREATE INDEX IX_audit_logs_entity_type ON auth.audit_logs(entity_type);
    CREATE INDEX IX_audit_logs_timestamp ON auth.audit_logs(timestamp);
END
GO

-- Login History Table (tracking user login sessions)
IF OBJECT_ID('auth.login_history', 'U') IS NULL
BEGIN
    CREATE TABLE auth.login_history (
        login_id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT NOT NULL,
        login_timestamp DATETIME2 DEFAULT SYSDATETIME(),
        ip_address NVARCHAR(45),  -- For IPv6 support
        device_info NVARCHAR(255), -- e.g., browser, OS, etc.
        success BIT,  -- True if login was successful, False if failed
        FOREIGN KEY (user_id) REFERENCES auth.users(user_id)
    );

    CREATE INDEX IX_login_history_user_id ON auth.login_history(user_id);
    CREATE INDEX IX_login_history_timestamp ON auth.login_history(login_timestamp);
END
GO
