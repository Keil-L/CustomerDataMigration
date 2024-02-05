# CustomerDataMigration
The CustomerDataMigration.sql script is an advanced SQL-based solution designed for the seamless transfer of customer data from an existing table structure to a newly defined, more comprehensive one. This four-step process ensures data integrity and optimizes the dataset for future use, leveraging SQL's powerful data manipulation capabilities.

In the first step, the script begins by checking for the existence of the target table new_customer_data. If it does not exist, the script proceeds to create this table with a refined structure. This new table includes additional fields such as first_name, last_name, email_verified, and phone_format, which are designed to provide a more detailed and organized view of customer data. These enhancements facilitate better data management and provide a foundation for more nuanced data analysis.

The second step involves the actual migration of data from the old table old_customer_data to the new one. During this phase, the script not only transfers the data but also transforms it. Names are split into first and last names, and the current date is inserted into the created_at field. This step is crucial as it standardizes the data format, making it consistent and more usable for future applications.

In the third step, the script updates additional fields in the new table. It includes setting the email_verified flag based on the presence of a valid email format and standardizing the phone number format. This step is essential for ensuring data quality and reliability, particularly for fields that are critical for communication and customer identification.

Finally, the script logs the entire migration process in a separate migration_log table. This logging is crucial for maintaining a record of data manipulations, which is invaluable for audit trails and future reference. If any errors occur during the migration, the script is designed to roll back the transaction, ensuring that the data integrity is not compromised.

Overall, the CustomerDataMigration.sql script is a comprehensive tool that not only migrates data but also enhances its structure and quality, embodying best practices in data management and SQL scripting.
