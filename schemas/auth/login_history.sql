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