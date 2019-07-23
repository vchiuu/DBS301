*****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, July 2nd 2019
-- Purpose: Lab 6 DBS301 (Sub-Select)
-- **************************************************************

-- Question 1 - Set autocommit on so that updates, deletes, and 
-- inserts are automatically committed before you exit oracle
SET AUTOCOMMIT ON;

-- Question 2 - Create an INSERT statement to add yourself as 
-- employee with a NULL salary, 0.21 commission pct, in department
-- 90, and Manager 100. You start TODAY.
INSERT INTO EMPLOYEES VALUES (55, 'Vivian', 'Chiu', 'VCHIU', 
    '416.566.9055', '02-JUL-19', 'IT_PROG', NULL, 0.21, 100, 90);

-- Question 3 - Create an UPDATE statement to change the salary
-- of the employees with last names Matos and Whalen to be 2500
UPDATE EMPLOYEES
SET SALARY = 2500
WHERE LAST_NAME IN ('Matos', 'Whalen');

-- Question 4 - Display the last names of all employees who are
-- in the same department as the employee named Abel
SELECT LAST_NAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES
                        WHERE LAST_NAME = 'Abel');

-- Question 5 - Display the last name of the lowest paid employees
SELECT LAST_NAME
FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);

-- Question 6 - Display the city that the lowest paid employee(s)
-- are located in
SELECT L.CITY
FROM LOCATIONS L JOIN DEPARTMENTS D ON (L.LOCATION_ID = D.LOCATION_ID)
JOIN EMPLOYEES E ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);
                
-- Question 7 - Display the last name, department_id and salary of
-- the lowest paid employee(s) in each city
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE (DEPARTMENT_ID, SALARY) IN (SELECT DEPARTMENT_ID, MIN(SALARY)
                                    FROM EMPLOYEES
                                    GROUP BY DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID;

-- Question 8 - Display the last name of the lowest paid employee(s)
-- in each city
SELECT E.LAST_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D USING (DEPARTMENT_ID)
JOIN LOCATIONS L USING (LOCATION_ID)
WHERE (L.CITY, E.SALARY) IN (SELECT L.CITY, MIN(E.SALARY)
                        FROM EMPLOYEES E JOIN DEPARTMENTS D USING (DEPARTMENT_ID)
                        JOIN LOCATIONS L ON (L.LOCATION_ID = D.LOCATION_ID)
                        GROUP BY L.CITY);

-- Question 9 - Display last name and salary for all employees who
-- earn less than the lowest salary in ANY department. Sort the
-- output by top salaries first and then by last name
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT MIN(SALARY)
                    FROM EMPLOYEES
                    GROUP BY DEPARTMENT_ID)
ORDER BY SALARY DESC, LAST_NAME; 

-- Question 10 - Display the last name, job title and salary for all
-- employees whose salary matches any of the salaries from the IT
-- department. Do NOT use Join method. Sort the output by salary 
-- ascending first and then by last_name
SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE SALARY = ANY (SELECT SALARY
                    FROM EMPLOYEES
                    WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                                            FROM DEPARTMENTS
                                            WHERE DEPARTMENT_NAME = 'IT'))
AND DEPARTMENT_ID <> (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'IT')
ORDER BY SALARY ASC, LAST_NAME;
