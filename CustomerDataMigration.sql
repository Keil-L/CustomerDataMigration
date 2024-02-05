
-- Start transaction for data migration
BEGIN TRY
    BEGIN TRANSACTION;

    -- Step 1: Create New Table Structure
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'new_customer_data')
    BEGIN
        CREATE TABLE new_customer_data (
            id INT PRIMARY KEY,
            first_name NVARCHAR(50),
            last_name NVARCHAR(50),
            email NVARCHAR(100),
            email_verified BIT DEFAULT 0,
            phone NVARCHAR(20),
            phone_format NVARCHAR(20),
            address NVARCHAR(255),
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
    END

    -- Step 2: Migrate and Transform Data
    INSERT INTO new_customer_data (id, first_name, last_name, email, phone, address, created_at)
    SELECT
        id,
        LEFT(name, CHARINDEX(' ', name) - 1) AS first_name, -- Extracting first name
        SUBSTRING(name, CHARINDEX(' ', name) + 1, 100) AS last_name, -- Extracting last name
        email,
        phone,
        address,
        GETDATE() -- Current date as created_at
    FROM 
        old_customer_data;

    -- Step 3: Update Additional Fields
    -- Email verification and phone format standardization
    UPDATE new_customer_data
    SET 
        email_verified = CASE WHEN email LIKE '%@%' THEN 1 ELSE 0 END,
        phone_format = CONCAT('+', REPLACE(REPLACE(phone, '-', ''), ' ', '')),
        updated_at = GETDATE();

    -- Step 4: Log the migration
    INSERT INTO migration_log (operation, source_table, target_table, timestamp)
    VALUES ('DATA MIGRATION', 'old_customer_data', 'new_customer_data', CURRENT_TIMESTAMP);

    -- Commit the transaction
    COMMIT TRANSACTION;
    PRINT 'Data migration completed successfully.';
END TRY
BEGIN CATCH
    -- Rollback transaction in case of an error
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Error handling
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

-- End of the script
