********************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, June 11th 2019
-- Purpose: Assignment 1
-- *****************************************************************
-- Question 1 – Display the employee number, full employee name, job,
-- and hire date of all employees hired in May or November of any 
-- year, with the most recently hired employees displayed first [Completed]
-- Q1 SOLUTION -- 
SELECT EMPLOYEE_ID, SUBSTR(LAST_NAME || ', '|| FIRST_NAME,0,25) "Full Name", JOB_ID,
    '[' || TRIM(TO_CHAR(HIRE_DATE, 'Month')) || ' '|| 
    TO_CHAR(LAST_DAY(HIRE_DATE), 'fmddth "of" YYYY') || ']' "Start Date"
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'MM') = 11 OR TO_CHAR(HIRE_DATE, 'MM') = 5
ORDER BY HIRE_DATE DESC;

-- Question 2 - List the employee number, full name, job, and the 
-- modified salary for all employees whose monthly earning (without
-- this increase) is outside the range $5,000 - $10,000 and who are
-- employed as Vice Presidents or Managers (President is not counted)
-- Q2 SOLUTION --
SELECT 'Emp# ' || EMPLOYEE_ID || ' named ' || FIRST_NAME || ' ' || 
    LAST_NAME || ' who is ' || JOB_ID || ' will have a new salary of $' ||
        CASE
            WHEN JOB_ID LIKE '%VP' THEN SALARY * 1.25
            WHEN JOB_ID LIKE '%MAN' THEN SALARY * 1.18
            WHEN JOB_ID LIKE '%MGR' THEN SALARY * 1.18
            ELSE SALARY 
        END
    AS "Employees with Pay Increase"
FROM EMPLOYEES
WHERE (SALARY < 5000 OR SALARY > 10000) AND 
    (JOB_ID LIKE '%VP' OR JOB_ID LIKE '%MAN' OR JOB_ID LIKE '%MGR')
ORDER BY SALARY DESC;

-- Question 3 - Display the employee last name, salary, job title, 
-- and manager# of all employees not earning a commission or if they
-- work in the SALES department, but only if their total monthly 
-- salary with $1000 include bonus and commission (if earned) is
-- greater than $15,000
-- Q3 SOLUTION --
SELECT E.LAST_NAME, E.SALARY "Salary", E.JOB_ID,
   COALESCE(TO_CHAR(E.MANAGER_ID), 'NONE') "Manager#", 
   TO_CHAR((E.SALARY+1000)*12, '$999,999.99') "Total Income"
FROM EMPLOYEES E JOIN DEPARTMENTS D USING (DEPARTMENT_ID)
WHERE COMMISSION_PCT IS NULL OR (D.DEPARTMENT_NAME = 'Sales' AND (SALARY *(1+NVL(COMMISSION_PCT,0))+1000) > 15000)
ORDER BY SALARY DESC;

-- Question 4 - Display department id, job id, and the lowest salary 
-- for the combination under the alias Lowest Dept/Job Pay, but only if
-- that Lowest Pay falls in the range $6000 - $18000. Exclude people who
-- work as some kind of Representative job from this query and departments
-- IT and SALES as well.
-- Q4 SOLUTION --
SELECT E.DEPARTMENT_ID, E.JOB_ID, MIN(E.SALARY) "Lowest Dept/Job Pay"
FROM EMPLOYEES E JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
GROUP BY E.DEPARTMENT_ID, E.JOB_ID, D.DEPARTMENT_NAME
HAVING MIN(E.SALARY) >= 6000 AND MIN(SALARY) <= 18000
    AND E.JOB_ID NOT LIKE '%REP'
    AND D.DEPARTMENT_NAME NOT IN ('IT','Sales')
ORDER BY E.DEPARTMENT_ID, E.JOB_ID;

-- Question 5 - Display last name, salary and job for all employees who
-- earn more than all lowest paid employees per department outside US
-- locations
-- Q5 SOLUTION --
SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEES 
WHERE SALARY > ALL (SELECT MIN(SALARY)
                    FROM EMPLOYEES E
                    JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
                    JOIN LOCATIONS L ON (D.LOCATION_ID = L.LOCATION_ID)
                    GROUP BY E.DEPARTMENT_ID, D.LOCATION_ID, L.COUNTRY_ID
                    HAVING COUNTRY_ID NOT IN 'US')
    AND JOB_ID NOT LIKE '%VP' AND JOB_ID NOT LIKE '%PRES'
ORDER BY JOB_ID ASC;

-- Question 6 - Who are the employees (show last name, salary and job) who 
-- work either in IT or MARKETING department and earn more than the worst 
-- paid person in the ACCOUNTING department
-- Q6 SOLUTION --
SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT MIN(SALARY)
                    FROM EMPLOYEES
                    WHERE DEPARTMENT_ID = 110)
    AND (DEPARTMENT_ID = 20 OR DEPARTMENT_ID = 60)
ORDER BY LAST_NAME;

-- Q6 SOLUTION (V2) --
SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT MIN(SALARY)
                    FROM EMPLOYEES
                    WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                                            FROM DEPARTMENTS
                                            WHERE DEPARTMENT_NAME = 'Accounting'))
    AND (DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                            FROM DEPARTMENTS
                            WHERE DEPARTMENT_NAME = 'IT')
        OR DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                            FROM DEPARTMENTS
                            WHERE DEPARTMENT_NAME = 'Marketing'))
ORDER BY LAST_NAME;


-- Question 7 - Display alphabetically the full name, job, salary (formatted
-- as a currency amount incl. thousand separator, but no decimals) and 
-- department number for each employee who earns less than the best paid
-- unionized employee (i.e. not the president nor any manager nor any VP),
-- who work in either SALES or MARKETING department
-- Q7 SOLUTION --
SELECT (FIRST_NAME || ' '|| LAST_NAME) "Employee", JOB_ID, 
    LPAD(TO_CHAR(SALARY, '$99,999'), 15, '=') AS "Salary", DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY < (SELECT MAX(SALARY)
                FROM EMPLOYEES
                WHERE JOB_ID NOT LIKE '%MAN' AND JOB_ID NOT LIKE '%MGR'
                  AND JOB_ID NOT LIKE '%VP' AND JOB_ID NOT LIKE '%PRES')
    AND (DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                         FROM DEPARTMENTS
                         WHERE DEPARTMENT_NAME = 'Sales')
        OR DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                             FROM DEPARTMENTS
                             WHERE DEPARTMENT_NAME = 'Marketing'))
ORDER BY FIRST_NAME;

-- Question 8 - "Tricky One" Display department name, city and number of
-- different jobs in each department. If city is null, you should print 
-- 'Not Assigned Yet'
SELECT COALESCE(D.DEPARTMENT_NAME, 'No Department') "Department Name",
        SUBSTR(COALESCE(L.CITY, 'Not Assigned Yet'), 0, 25) "City",
        COUNT(DISTINCT (E.JOB_ID))"# of Jobs" 
FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D USING (DEPARTMENT_ID)
    RIGHT OUTER JOIN LOCATIONS L USING (LOCATION_ID)
GROUP BY D.DEPARTMENT_NAME, L.CITY;
