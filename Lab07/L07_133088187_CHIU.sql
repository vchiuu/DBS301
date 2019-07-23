*****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Friday, July 5th 2019
-- Purpose: Lab 7 DBS301 (Set Operators)
-- **************************************************************

-- Question 1 - The HR Department needs a list of Department IDs
-- for departments that do not contain the job ID of ST_CLERK. 
-- Use a set operator to create this report
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
    UNION
SELECT DEPARTMENT_ID
FROM EMPLOYEES
WHERE JOB_ID != 'ST_CLERK';

-- Question 2 - Same departments requests a list of countries
-- that have no departments located in them. Display country ID
-- and the country name. Use set operators.
SELECT COUNTRY_ID, COUNTRY_NAME
FROM (SELECT COUNTRY_ID
        FROM COUNTRIES
            MINUS
      SELECT COUNTRY_ID
        FROM LOCATIONS)
    JOIN COUNTRIES USING (COUNTRY_ID);


-- Question 3 - The Vice President needs very quickly a list of 
-- departments 10, 50, 20 in that order. Job id and department id
-- are to be displayed
SELECT DISTINCT(JOB_ID), DEPARTMENT_ID
FROM (SELECT DEPARTMENT_ID
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID IN (10,50,20)
            INTERSECT
      SELECT DEPARTMENT_ID
        FROM EMPLOYEES)
   JOIN EMPLOYEES
   USING(DEPARTMENT_ID)
ORDER BY 
    CASE DEPARTMENT_ID
        WHEN 10 THEN 1
        WHEN 50 THEN 2
        WHEN 20 THEN 3
    END;
-- VERSION 2 (if using distinct is cheating)
SELECT JOB_ID, DEPARTMENT_ID
FROM (SELECT DEPARTMENT_ID
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID IN (10,50,20)
            INTERSECT
      SELECT DEPARTMENT_ID
        FROM EMPLOYEES)
   JOIN (SELECT JOB_ID, DEPARTMENT_ID
            FROM EMPLOYEES
                UNION
         SELECT JOB_ID, DEPARTMENT_ID
            FROM EMPLOYEES)
   USING(DEPARTMENT_ID)
ORDER BY 
    CASE DEPARTMENT_ID
        WHEN 10 THEN 1
        WHEN 50 THEN 2
        WHEN 20 THEN 3
    END;
    
-- Question 4 - Create a statement that lists the employeeIDs and
-- JobIDs of those employees who currently have a job title that 
-- is the same as their job title when they were initially hired
-- by the company (that is, they changed jobs but have now gone
-- back to doing their original job).
SELECT EMPLOYEE_ID, JOB_ID
FROM (SELECT EMPLOYEE_ID -- this is not correct.
        FROM EMPLOYEES
            MINUS
      SELECT EMPLOYEE_ID
        FROM JOB_HISTORY)
    JOIN EMPLOYEES USING (EMPLOYEE_ID)
ORDER BY EMPLOYEE_ID;

-- Question 5 - The HR department needs a SINGLE report with the
-- following specifications:
-- a. last name and department id of all employees regardless of
-- whether they belong to a department or not
-- b. department id and department name of all departments
-- regardless of whether they have employees in them or not
-- Write a compound query to accomplish this
SELECT LAST_NAME, DEPARTMENT_ID, DEPARTMENT_NAME
FROM (SELECT DEPARTMENT_ID
        FROM EMPLOYEES
            UNION
      SELECT DEPARTMENT_ID
        FROM DEPARTMENTS)
    FULL OUTER JOIN EMPLOYEES USING (DEPARTMENT_ID)
    FULL OUTER JOIN DEPARTMENTS USING (DEPARTMENT_ID);
