-- *****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, June 4th 2019
-- Purpose: Lab 4 DBS301
-- *****************************************************************

-- Question 1 – the difference between the Average pay and the lowest
-- pay in the company. Name this result Real Amount. Format the output
-- as currency with two decimal places:
-- Q1 SOLUTION --
SELECT ('$' || ROUND((AVG(SALARY) - MIN(SALARY)), 2)) "Real Amount"
FROM EMPLOYEES;

-- Question 2 - Display the department number and Highest(High), 
-- Lowest (Low), and Average(Avg) pay per each department. Sort the output
-- so that the department with highest average salary is shown first.
-- Format appropriately.
-- Q2 SOLUTION --
SELECT DEPARTMENT_ID "Dept ID",TO_CHAR(MAX(SALARY), '$99,999.99') "High", 
	TO_CHAR(MIN(SALARY), '$99,999.99') "Low", TO_CHAR(AVG(SALARY), '$99,999.99') "Avg"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID
ORDER BY AVG(SALARY) DESC;
-- Question 3 - Display how many people work in the same job in the same
-- department. Name these results Dept#, Job and How Many. Include only
-- jobs that involve more than one person. Sort the output so that
-- jobs with the most people involved as shown first
-- Q3 SOLUTION --
SELECT DEPARTMENT_ID "Dept#", JOB_ID "Job", COUNT(JOB_ID) "How Many"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING COUNT(JOB_ID) > 1
ORDER BY COUNT(JOB_ID) DESC;

-- Question 4 - For each job title display the job title and total 
-- amount paid each month for this type of job. Excludes title AD_PRES
-- and AD_VP and also include only jobs that rquire more than $11,000.
-- Sort the output so that the top paid jobs are shown first
-- Q4 SOLUTION --
SELECT JOB_ID "Job Title", TO_CHAR(SUM(SALARY),'$999,999.99') "Amount Paid"
FROM EMPLOYEES
GROUP BY JOB_ID
HAVING JOB_ID != 'AD_PRES' AND JOB_ID != 'AD_VP' AND SUM(SALARY) > 11000
ORDER BY SUM(SALARY) DESC;
-- Question 5 - For each manager number display how many persons he or
-- she supervises. Exclude managers with numbers 100, 101, 102 and include
-- only those managers that supervise more than two persons. Sort
-- the output so that manager numbers with the most supervised persons are
-- shown first
-- Q5 SOLUTION --
SELECT MANAGER_ID "Manager", COUNT(MANAGER_ID) "Employees"
FROM EMPLOYEES
GROUP BY MANAGER_ID
HAVING MANAGER_ID != 100 AND MANAGER_ID != 101 AND MANAGER_ID != 102 AND COUNT(MANAGER_ID) > 2;

-- Question 6 - For each department show the latest and earliest hire date, BUT
-- exclude departments 10 and 20
-- exclude those departments where the last person was hired in this decade
-- it is okay to hard code dates in this question only
-- Sort so that the latest hires are shown first
-- Q6 SOLUTION --
SELECT DEPARTMENT_ID "Dept #", TO_CHAR(MAX(HIRE_DATE), 'YY-MM-DD') "Latest", 
	TO_CHAR(MIN(HIRE_DATE), 'YY-MM-DD') "Earliest"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING DEPARTMENT_ID != 10 AND DEPARTMENT_ID != 20 AND MAX(HIRE_DATE) < TO_DATE('2009-01-01', 'YYYY-MM-DD')
ORDER BY MAX(HIRE_DATE) DESC;
