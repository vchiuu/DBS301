-- *****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, May 28th 2019
-- Purpose: Lab 3 DBS301
-- *****************************************************************

-- Question 1 – Display tomorrow's date in the following format:
-- January 10th of year 2019 and label the column "Tomorrow" 
SELECT TRIM(TO_CHAR(SYSDATE+1, 'Month'))||' '||
	TO_CHAR(SYSDATE +1, 'fmddth "of year" YYYY') "Tomorrow" 
FROM DUAL; -- or you can use employees but, dual only has single row

-- Question 2 - For employees in departments 20,50,and 60 display
-- last name, first name, salary, salary increased by 4% and 
-- salary difference 
SELECT LAST_NAME "Last Name", FIRST_NAME "First Name", TO_CHAR(SALARY, '$99,999') AS "Salary",
	TO_CHAR(SALARY*1.04, '$99,999') AS "Good Salary",
	TO_CHAR(((SALARY*1.04)- SALARY)*12, '$99,999') AS "Annual Pay Increase"
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 20 OR DEPARTMENT_ID = 50 OR DEPARTMENT_ID = 60;

-- Question 3 - Display employee's full name and job title:
-- LASTNAME,FIRSTNAME is JOBTITLE as "Employee Jobs" for only
-- lastname ending in S and first name starting with C or K 
SELECT UPPER(LAST_NAME)|| ', ' || UPPER(FIRST_NAME) || ' is ' || JOB_ID "Employee Jobs"
FROM EMPLOYEES 
WHERE LAST_NAME LIKE '%s' AND (FIRST_NAME like 'C%' OR FIRST_NAME LIKE 'K%');

-- Question 4 - Display lastname,hire date and calculated "Years Worked"
-- between hire date and today for employees hired before 1997 
SELECT LAST_NAME "Last Name", TO_CHAR(HIRE_DATE, 'YY-MM-DD') "Hire Date" , 
	ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) "Years Worked"
FROM EMPLOYEES
WHERE HIRE_DATE < TO_DATE('1997-01-01', 'YYYY-MM-DD')
ORDER BY ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12);

-- Question 5 - Display city names,country codes, and province names
-- for cities starting with S and has at least 8 characters in their
-- name. If city oes not have a province, use "Unknown Province" 
SELECT CITY "City", COUNTRY_ID "Country", 
	COALESCE(STATE_PROVINCE, 'Unknown Province') "Province"
FROM LOCATIONS
WHERE LENGTH(CITY) >= 8 AND CITY LIKE 'S%';

-- Question 6 - Display last name, hire date,and salary review date
-- first Thursday after a year of service for those hired after 2017:
-- THURSDAY, August the Thirty-First of year 2018, sorting by review
-- date
SELECT LAST_NAME "Last Name", TO_CHAR(HIRE_DATE,'YY-MM-DD') "Hire Date",
TO_CHAR(NEXT_DAY(HIRE_DATE + 365,'THURSDAY'), 'DAY "," Month ddspth "of year" YYYY') "Review Date"
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('2016-12-31', 'YYYY-MM-DD')
ORDER BY NEXT_DAY(HIRE_DATE + 365, 'THURSDAY');
