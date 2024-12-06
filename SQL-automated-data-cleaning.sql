/* US geographic location - Automated data cleaning project by Virginia Herrero */

/* This project consists of creating an automated data cleaning process for the U.S. geographic location dataset.
   
   This dataset is used as part of the U.S. Household Income project.
   
   The main goal is to ensure data quality and consistency by removing duplicates, fixing typos, and standardizing the data. 
   
   The process is implemented using SQL stored procedures, events, and triggers, ensuring that the data cleaning steps are executed 
   automatically after each data insertion and periodically every 30 days.
   
   This project enhances data reliability, making it suitable for further analysis and reporting, ensuring accurate and actionable insights from 
   the cleaned dataset.
*/

-- Set up the delimiter for the store procedure
DELIMITER $$

-- Drop procedure if it already exists to avoid duplication errors
DROP PROCEDURE IF EXISTS copy_and_clean_data;

-- Create a stored procedure to copy and clean data
CREATE PROCEDURE copy_and_clean_data()
BEGIN
    -- Create a table for the cleaned data if it doesn't already exist
    CREATE TABLE IF NOT EXISTS `us_geographic_location_cleaned` (
      `row_id` int DEFAULT NULL,
      `Id` int DEFAULT NULL,
      `State_Code` int DEFAULT NULL,
      `State_Name` text,
      `State_ab` text,
      `County` text,
      `City` text,
      `Place` text,
      `Type` text,
      `Primary` text,
      `Zip_Code` int DEFAULT NULL,
      `Area_Code` int DEFAULT NULL,
      `TimeStamp` TIMESTAMP DEFAULT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

    -- Copy the data from the original table to the cleaned table with a current timestamp
    INSERT INTO `us_geographic_location_cleaned`
    SELECT * , CURRENT_TIMESTAMP
    FROM us_geographic_location;

    -- Data Cleaning Workflow
    -- 1. Remove duplicates
    -- Delete duplicated rows based on the 'Id' and 'TimeStamp' fields
    DELETE 
    FROM us_geographic_location_cleaned 
    WHERE row_id IN 
    (
        SELECT row_id
        FROM (
            SELECT row_id, Id,
			ROW_NUMBER() OVER (PARTITION BY Id, `TimeStamp` ORDER BY Id, `TimeStamp`) AS Row_num
            FROM us_geographic_location_cleaned
            ) AS Duplicates
        WHERE Row_num > 1);

    -- 2. Standardize data
    -- Fix typos
    UPDATE us_geographic_location_cleaned
    SET State_Name = 'Georgia'
    WHERE State_Name = 'georia';
    
    UPDATE us_geographic_location_staging
	SET State_Name = 'Alabama'
	WHERE State_Name = 'alabama';
    
    UPDATE us_geographic_location_cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';

	UPDATE us_geographic_location_cleaned 
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_geographic_location_cleaned
	SET Place = 'Autaugaville'
	WHERE County = 'Autauga County'
	AND City = 'Vinemont';

    -- Convert strings to uppercase for consistency
    UPDATE us_geographic_location_cleaned
    SET County = UPPER(County);

    UPDATE us_geographic_location_cleaned
    SET City = UPPER(City);

    UPDATE us_geographic_location_cleaned
    SET Place = UPPER(Place);

    UPDATE us_geographic_location_cleaned
    SET State_Name = UPPER(State_Name);

END $$
DELIMITER ;

select * from us_geographic_location_cleaned;

-- Call the stored procedure to clean the data
CALL copy_and_clean_data();

-- Create an event to schedule the cleaning procedure every 30 days
DROP EVENT IF EXISTS run_data_cleaning;
CREATE EVENT run_data_cleaning
    ON SCHEDULE EVERY 30 DAY
    DO CALL copy_and_clean_data();

-- Create a trigger to run the data cleaning procedure when new data is inserted into the table
DELIMITER $$
CREATE TRIGGER transfer_clean_data
    AFTER INSERT ON us_household_income.us_geographic_location
    FOR EACH ROW 
BEGIN
    CALL copy_and_clean_data();
END $$
DELIMITER ;

-- Check latest timestamps pull
SELECT DISTINCT `TimeStamp`
FROM us_geographic_location_cleaned;

-- Check data to validate everything run correctly
-- Check if there is any duplicated values
SELECT row_id, Id, Row_num
FROM (
    SELECT row_id, Id,
	ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) AS Row_num
    FROM us_geographic_location_cleaned
) Duplicates
WHERE Row_num > 1;

-- Count the number of rows in the cleaned table
SELECT COUNT(row_id)
FROM us_geographic_location_cleaned;

-- Count occurrences of each state name in the cleaned table
SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned
GROUP BY State_Name;