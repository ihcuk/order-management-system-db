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