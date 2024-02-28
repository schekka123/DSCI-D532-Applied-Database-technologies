CREATE DATABASE HOMEWORK2;

-- Question 1
SELECT * from income;

-- Question 2
ALTER TABLE income
ADD COLUMN occupation_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- Question 3
-- Write a query to display distinct industries from the income table
SELECT DISTINCT Industry FROM income;

CREATE TABLE IF NOT EXISTS INDUSTRY (
    Industry_ID INT AUTO_INCREMENT,
    Industry_Name VARCHAR(255) NOT NULL UNIQUE,
    Average_Revenue DECIMAL(15,2),
    Profit_Margin_Percentage DECIMAL(5,2),
    Average_Age INT,
    Education_Required VARCHAR(255),
    PRIMARY KEY (Industry_ID)
);

-- Question 4


-- After creating Industry table, execute this insert query.

INSERT INTO INDUSTRY (Industry_Name, Average_Revenue, Profit_Margin_Percentage, Average_Age, Education_Required) VALUES 
  ('Management', 50000000.00, 10.00, 42, 'Bachelor''s'),
  ('Healthcare Professional', 80000000.00, 15.00, 45, 'Doctorate'),
  ('Legal', 30000000.00, 20.00, 37, 'Juris Doctor'),
  ('Engineering', 70000000.00, 12.00, 40, 'Bachelor''s or Master''s'),
  ('Computational', 95000000.00, 25.00, 35, 'Bachelor''s or Master''s'),
  ('Business', 60000000.00, 18.00, 38, 'Bachelor''s or MBA'),
  ('Arts', 20000000.00, 5.00, 36, 'Bachelor''s or Master of Fine Arts'),
  ('Science', 50000000.00, 15.00, 42, 'PhD'),
  ('Education', 10000000.00, 8.00, 43, 'Master''s in Education'),
  ('Protective Service', 30000000.00, 10.00, 37, 'High School Diploma'),
  ('Social Service', 15000000.00, 7.00, 39, 'Bachelor''s or Master''s in Social Work'),
  ('Sales', 45000000.00, 10.00, 35, 'High School Diploma or Bachelor''s'),
  ('Office', 25000000.00, 10.00, 40, 'High School Diploma'),
  ('Service', 10000000.00, 12.00, 34, 'Varies'),
  ('Transportation', 50000000.00, 15.00, 40, 'High School Diploma or Associate''s'),
  ('Production', 60000000.00, 8.00, 38, 'High School Diploma'),
  ('Groundskeeping', 8000000.00, 10.00, 38, 'High School Diploma'),
  ('Culinary', 20000000.00, 6.00, 36, 'Culinary Arts Degree'),
  ('Healthcare Support', 22000000.00, 12.00, 37, 'Certification or Associate''s'),
  ('Agricultural', 30000000.00, 10.00, 47, 'High School Diploma or Bachelor''s'),
  ('Technology', 120000000.00, 30.00, 32, 'Bachelor''s or Master''s in Computer Science'),
  ('Renewable Energy', 90000000.00, 20.00, 39, 'Bachelor''s in Environmental Science or Engineering');
  
  SELECT * FROM INDUSTRY;

-- Question 5 : Linking of both the tables
-- 1. Perform join between the ‘income’ and the ‘industry’ table on the industry_name field. Ensure that all the columns from the income and the industry table are retrieved

SELECT *
FROM income
JOIN INDUSTRY
ON income.Industry = INDUSTRY.Industry_Name;

-- 2. Create a view Industry_Income using the above join between the two tables created above to showcase the average of weekly income across all the industries (use the All_Weekly column). Group the results by industry_name from the industry table (4 points) 
CREATE VIEW Industry_Income AS
SELECT INDUSTRY.Industry_Name, AVG(income.All_Weekly) AS Average_Weekly_Income
FROM income
JOIN industry ON income.Industry = INDUSTRY.Industry_Name
GROUP BY INDUSTRY.Industry_Name;

-- 3. Perform one Exploratory Data Analysis on the view Industry_Income (2 points) 
SELECT 
    MIN(Average_Weekly_Income) AS Min_Weekly_Income,
    MAX(Average_Weekly_Income) AS Max_Weekly_Income,
    AVG(Average_Weekly_Income) AS Avg_Weekly_Income,
    STD(Average_Weekly_Income) AS StdDev_Weekly_Income,
    COUNT(*) AS NumberOfIndustries
FROM Industry_Income;

-- 4. Similarly, perform join on the ‘income’ and ‘industry’ tables such that all the matches from the ‘industry’ table are retrieved (2 points)
SELECT *
FROM INDUSTRY
LEFT JOIN income
ON INDUSTRY.Industry_Name = income.Industry;

-- Part 2

-- Using DESCRIBE
DESCRIBE income;

SELECT AVG(CHAR_LENGTH(occupation_id)) AS avg_length, MAX(CHAR_LENGTH(occupation_id)) AS max_length
FROM income;


SELECT occupation_id, COUNT(*)
FROM income
GROUP BY occupation_id
HAVING COUNT(*) > 1;

SELECT COUNT(*)
FROM income
WHERE occupation_id IS NULL;



-- Check if 'occupation_id' is unique
SELECT occupation_id, COUNT(*)
FROM income
GROUP BY Industry
HAVING COUNT(*) > 1;

-- Check if 'occupation_id' has any NULL values
SELECT COUNT(*)
FROM income
WHERE Industry IS NULL;

-- Part 3 : Implement Part 2 Design

-- DDL for Demographics Table
CREATE TABLE Demographics (
    individual_id INT AUTO_INCREMENT PRIMARY KEY,
    years INT NOT NULL CHECK (years >= 0),
    education_level VARCHAR(255) NOT NULL,
    marital_status VARCHAR(255) NOT NULL,
    relationship_status VARCHAR(255),
    ethnicity VARCHAR(255),
    gender VARCHAR(50) NOT NULL,
    UNIQUE (individual_id)
);

-- DDL for Sector Table
CREATE TABLE Sector (
    sector_id INT AUTO_INCREMENT PRIMARY KEY,
    sector_title VARCHAR(255) NOT NULL,
    sector_avg_revenue DECIMAL(19, 4) CHECK (sector_avg_revenue >= 0),
    sector_profit_ratio DECIMAL(5, 2) CHECK (sector_profit_ratio >= 0),
    workforce_avg_age INT CHECK (workforce_avg_age >= 0),
    required_qualification VARCHAR(255),
    UNIQUE (sector_id)
);

-- DDL for Earnings Table
CREATE TABLE Earnings (
    earnings_id INT AUTO_INCREMENT PRIMARY KEY,
    individual_id INT NOT NULL,
    sector_id INT NOT NULL,
    work_title VARCHAR(255) NOT NULL,
    gain DECIMAL(19, 4) DEFAULT 0,
    loss DECIMAL(19, 4) DEFAULT 0,
    weekly_hours INT CHECK (weekly_hours >= 0 AND weekly_hours <= 168),
    country_of_origin VARCHAR(255),
    earnings_bracket VARCHAR(255) NOT NULL,
    FOREIGN KEY (individual_id) REFERENCES Demographics(individual_id),
    FOREIGN KEY (sector_id) REFERENCES Sector(sector_id),
    UNIQUE (earnings_id)
);

-- Indexes for the Earnings Table
CREATE INDEX idx_individual_id ON Earnings(individual_id);
CREATE INDEX idx_sector_id ON Earnings(sector_id);

-- Query to get the DDL of an existing table
SHOW CREATE TABLE HOMEWORK2.Demographics;

SHOW CREATE TABLE HOMEWORK2.Earnings;

SHOW CREATE TABLE HOMEWORK2.Sector;

-- Question 4

-- Insert records into the Demographics Table
INSERT INTO Demographics (years, education_level, marital_status, relationship_status, ethnicity, gender)
VALUES (30, 'Bachelors', 'Married', 'Husband', 'White', 'Male'),
       (25, 'Masters', 'Single', 'Not_in_family', 'Black', 'Female');

-- Insert records into the Sector Table
INSERT INTO Sector (sector_title, sector_avg_revenue, sector_profit_ratio, workforce_avg_age, required_qualification)
VALUES ('Technology', 500000.00, 20.00, 32, 'Bachelors'),
       ('Healthcare', 300000.00, 15.00, 40, 'Doctorate');

-- Insert records into the Earnings Table
INSERT INTO Earnings (individual_id, sector_id, work_title, gain, loss, weekly_hours, country_of_origin, earnings_bracket)
VALUES (1, 1, 'Software Developer', 10000.00, 0.00, 40, 'USA', '>50K'),
       (2, 2, 'Physician', 20000.00, 0.00, 50, 'USA', '>50K');

-- Question 5

SELECT * FROM Demographics;

SELECT * FROM Sector;

SELECT * FROM Earnings;

















