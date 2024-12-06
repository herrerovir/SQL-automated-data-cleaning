# ⚙️ Automated SQL data cleaning

This repository contains an automated data cleaning project using SQL within MySQL Workbench. 

## Table of content
 - [Intro](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Introduction)
 - [Goal](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Goal)
 - [Project Overview](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Project-Overview)
 - [Dependencies](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Dependencies)
 - [Technical skills](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Technical-skills)
 - [Dataset](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Data-set)
 - [Create stored procedure](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Create-stored-procedure)
 - [Data copy and transformation](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Data-cleaning-duplicates-removal)
 - [Data cleaning: duplicate removal](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Data-copy-and-transformation)
 - [Data cleaning: data standardization](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Data-cleaning-data-standardization)
 - [Data cleaning scheduling](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Data-cleaning-scheduling)
 - [Data cleaning in real-time](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Data-cleaning-in-real-time)
 - [Validation](https://github.com/herrerovir/SQL-automated-data-cleaning/blob/main/README.md#Validation)

## Introduction
Task automation consists of using technology to manage repetitive, mundane and time-consuming tasks in order to improve productivity. Automation aims to optimize workflows, reduce manual effort and human intervention, and improve efficiency while freeing the individual for higher value tasks. 

The advantages of automating boring and time-consuming tasks are:
- Clean and standardize data
- Error reduction
- Efficiency
- Reliability
- Productivity
- Scalability

## Goal
The main objective of this project is to automate the cleaning and preprocessing workflow of a given data set. 

The goal of this automation is to ensure data quality and consistency by removing duplicates, correcting typos and standardizing data. The process is implemented using SQL stored procedures, events and triggers, ensuring that the data cleaning workflow is run automatically each time data is added to the dataset and periodically every 30 days.

## Project overview
1. Create stored procedure
2. Data copy and transformation
3. Data cleaning
    - duplicate removal
    - data standardization
4. Data cleaning scheduling
5. Data cleaning in real-time
6. Validation 

## Dependencies
The following software is required to carry out this project:

* MySQL Workbench 8.0 CE

## Technical skills
The following skills were used throughout the implementation of this project:

* Data definition
* Data manipulation
* Data querying

## Dataset
The US-geographic-location dataset from the U.S household income project is used for this project. This dataset consists of 32292 rows and 16 columns.

The dataset for this project can be found uploaded in this repository as US-geographic-location.cvs.

## Create stored procedure
A stored procedure named copy_and_clean_data was used to automate the data cleaning process. 

Stored procedures in MySQL are precompiled SQL code that is stored on the database server. They allow the user to organize complex SQL queries and logic into a single unit that can be executed multiple times without having to recompile the code each time.

## Data copy and transformation
This automated project is part of the US Household Income project, so the database was already created and the original datasets loaded into MySQL Workbench. To create the schema and load the dataset into the workbench, see the readme file for that project [HERE](https://github.com/herrerovir/SQL-US-household-income).

The first step of the project was to create a new table that will contain the cleaned data. All the data contained in the original dataset is copied into the new table and a timestamp is added to keep track of when the data was processed.

## Data cleaning: duplicate removal
Duplicate data were identified and removed using a subquery that assigned row numbers based on the Id and timestamp. Rows with a number greater than one were removed to maintain unique entries.

## Data cleaning: data standardization
To maintain data uniformity and integrity, typos have been corrected and data have been standardized:
- Fix of misspellings in state names
- Standardize type names
- Fix typos in place names
- Convert all text entries to uppercase for consistency

## Data cleaning scheduling
To schedule the data cleaning process, an SQL event name run_data_cleaning was implemented to run the cleaning procedure copy_and_clean_data every 30 days. This ensures that the data remains up-to-date and is cleaned regularly.

## Data cleaning in real-time
To ensure that new data added to the data set is immediately cleaned, a SQL trigger named transfer_clean_data is implemented. This procedure ensures that all the data (recentrly added or not) in cleaned. 

## Validation
At the end of the project, SQL queries are provided to verify the effectiveness of the cleaning process by checking for remaining duplicates 
and summarizing data counts.
