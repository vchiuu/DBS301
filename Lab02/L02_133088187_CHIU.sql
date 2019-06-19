-- *****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, May 21st 2019
-- Purpose: Lab 2 DBS301
-- *****************************************************************

-- Question 1 – Display the employee_id, last name and salary of 
-- employees earning in the range of $8,000 to $10000 inclusive.
-- Sort the output by top salaries first and then by last name.
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY BETWEEN 8000 AND 10000
ORDER BY SALARY DESC, LAST_NAME ASC; 

-- Question 2 – Modify previous query (#1) to display only Programmers
-- or Sales Representatives (same sorting)
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE (SALARY BETWEEN 8000 AND 10000) AND (JOB_ID = 'IT_PROG' OR JOB_ID = 'SA_REP')
ORDER BY SALARY DESC, LAST_NAME ASC; 

-- Question 3 - find high salary and low salary employees. 
-- Modify Q2 to display the same job titles for people who earn outside
-- the range of $8,000 to $11000 exclusive (same sorting)
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE (JOB_ID = 'IT_PROG' OR JOB_ID = 'SA_REP') AND (SALARY > 11000 OR SALARY < 8000)
ORDER BY SALARY;

-- Question 4 - Display the last name, job_id and salary of employees 
-- hired after 2016 (listing newest hired first)
SELECT LAST_NAME "Last Name", SALARY "Salary", JOB_ID "Job Title", HIRE_DATE "Started"
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('31-DEC-16', 'DD-Mon-YY')
ORDER BY HIRE_DATE DESC;

-- Question 5 - Modify Q4 to display only employees earning more than
-- $12,000 and hired before 2017 (listing alpha job title then, highest salary)
SELECT LAST_NAME "Last Name", SALARY "Salary", JOB_ID "Job Title", HIRE_DATE "Started"
FROM EMPLOYEES
WHERE SALARY > 12000 AND HIRE_DATE < TO_DATE('01-JAN-17', 'DD-Mon-YY')
ORDER BY SALARY DESC, JOB_ID DESC;

-- Question 6 - Display the job titles and full names of employees whose
-- first name contains an ‘c’ or ‘C’ anywhere. 
SELECT JOB_ID "Job Title", FIRST_NAME || ' ' || LAST_NAME "Full Name"
FROM EMPLOYEES
WHERE FIRST_NAME LIKE '%c%' OR FIRST_NAME LIKE '%C%';

-- Question 7 - Create a report to display last name, salary, and commission
-- percent for all employees that earn a commission and a salary less than 9000.
SELECT LAST_NAME "Last Name", SALARY "Salary", COMMISSION_PCT "Commission"
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL AND SALARY < 9000; 

-- Question 8 - From Q7, put the report in order of descending salaries.
SELECT LAST_NAME "Last Name", SALARY "Salary", COMMISSION_PCT "Commission"
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL AND SALARY < 9000
ORDER BY SALARY DESC;

-- Question 9 - From Q8, use a numeric value instead of a column name to sort.
SELECT LAST_NAME "Last Name", SALARY "Salary", COMMISSION_PCT "Commission"
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL AND SALARY < 9000
ORDER BY 2 DESC;
