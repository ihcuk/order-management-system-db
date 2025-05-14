-- Shipping Providers
IF OBJECT_ID('shipping.providers', 'U') IS NULL
BEGIN
    CREATE TABLE shipping.providers (
        provider_id INT PRIMARY KEY IDENTITY(1,1),
        provider_name NVARCHAR(100) NOT NULL,
        contact_email NVARCHAR(100),
        tracking_url_template NVARCHAR(300)
    );
END
GO