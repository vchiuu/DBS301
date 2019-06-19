-- *****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, May 14th 2019
-- Purpose: Lab 1 DBS301
-- *****************************************************************

-- Question 1: Which of these tables appear the widest or longest?

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOB_HISTORY; 

-- Question 1 Solution --
-- The widest table is: EMPLOYEES
-- The longest table is: EMPLOYEES


-- Question 2: Fix the following 'SELECT' statement:
-- SELECT last_name “LName”, job_id “Job Title”, 
--     Hire Date “Job Start”
--     FROM employees;

-- Question 2 Solution --
SELECT last_name "LName", job_id "Job Title", hire_date "Job Start"
FROM employees;

-- Question 3: Identify THREE coding errors in the following:
-- SELECT employee_id, last name, commission_pct Emp Comm,
-- FROM employees;

-- Question 3 Solution --
-- Error 1: no comma required at the end of the SELECT statement
-- Error 2: variable "last name" should be last_name, no spaces!
-- Error 3: name for variable commission_pct should be enclosed in "" because
-- of the uppercase and spaces 
-- Working Solution:

SELECT employee_id, last_name, commission_pct "Emp Comm"
FROM employees;

-- Question 4: What command would show the structure of the LOCATIONS table? 
-- Question 4 Solution --
-- desc LOCATIONS;

-- Question 5: Create a query to display the desired output
-- Question 5 Solution -- 
SELECT location_id "City #", city "City", state_province || ' IN THE ' || country_id "Province with Country Code"
FROM LOCATIONS;
