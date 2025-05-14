-- Create Countries Table if it doesn't exist
IF (OBJECT_ID('order_management.countries', 'U') IS NULL)
BEGIN
    CREATE TABLE order_management.countries (
        country_code CHAR(2) PRIMARY KEY,
        country_name NVARCHAR(100) NOT NULL
    );
    -- Sample data (can be modified or removed)
    INSERT INTO order_management.countries (country_code, country_name)
    VALUES
        ('US', 'United States'),
        ('IN', 'India'),
        ('GB', 'United Kingdom'),
        ('CA', 'Canada');
END
GO