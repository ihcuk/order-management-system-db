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