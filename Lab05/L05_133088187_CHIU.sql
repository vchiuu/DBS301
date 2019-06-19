*****************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Tuesday, June 11th 2019
-- Purpose: Lab 5 DBS301
-- *****************************************************************
-- PART A - SIMPLE JOINS
-- Question 1 – Display the department name, city, street address, 
-- and postal code for departments sorted by city and department name
-- Q1 SOLUTION -- 
SELECT D.DEPARTMENT_NAME "DEPARTMENT", L.CITY, L.STREET_ADDRESS "ADDRESS",
    L.POSTAL_CODE "Postal Code"
FROM DEPARTMENTS D, LOCATIONS L
WHERE D.LOCATION_ID = L.LOCATION_ID
ORDER BY L.CITY, D.DEPARTMENT_NAME;

-- Question 2 - Display the full name of employees as a single field
-- using a format of "Last, First", their hire date, salary, department
-- name, and city, but only for departments with names starting with 
-- an A or I sorted by department and employee name
-- Q2 SOLUTION -- 
SELECT (E.LAST_NAME || ', ' || E.FIRST_NAME)"EMPLOYEE", E.HIRE_DATE "HIRED", 
    E.SALARY, D.DEPARTMENT_NAME "DEPARTMENT", L.CITY
FROM EMPLOYEES E, LOCATIONS L, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.LOCATION_ID = L.LOCATION_ID
    AND (D.DEPARTMENT_NAME LIKE 'A%' OR D.DEPARTMENT_NAME LIKE 'I%')
ORDER BY D.DEPARTMENT_NAME, E.LAST_NAME;

-- Question 3 - Display the full name of the manager of each department in 
-- states/provinces of Ontario, New Jersey and Washington along with the
-- department name, city, postal code, and province name. Sort the output
-- by city and then by department name
-- Q3 SOLUTION -- 
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME"MANAGER", D.DEPARTMENT_NAME, 
    L.CITY, L.POSTAL_CODE, L.STATE_PROVINCE
FROM DEPARTMENTS D JOIN LOCATIONS L ON (D.LOCATION_ID = L.LOCATION_ID)
    JOIN EMPLOYEES E ON (D.MANAGER_ID = E.EMPLOYEE_ID) 
WHERE L.STATE_PROVINCE LIKE 'Ontario' OR L.STATE_PROVINCE LIKE 'New Jersey' 
   OR L.STATE_PROVINCE LIKE 'Washington'
ORDER BY L.CITY, D.DEPARTMENT_NAME;

-- Question 4 - Display employee's last name and employee number along with
-- their manager's last name and manager number for employees in department 
-- 20, 50 and 60. Label the columns Employee, Emp#, Manager, and Mgr# 
-- Q4 SOLUTION -- 
SELECT E.LAST_NAME "Employee", E.EMPLOYEE_ID "Emp#", M.LAST_NAME "Manager", M.EMPLOYEE_ID
FROM EMPLOYEES E JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID
WHERE E.DEPARTMENT_ID = 20 OR E.DEPARTMENT_ID = 50 OR E.DEPARTMENT_ID = 60;

-- Question 5 - Display the department name, city, street address, postal code
-- and country name for all Departments. Use the JOIN and USING form of syntax
-- Sort the output by department name descending
-- Q5 SOLUTION -- 
SELECT D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS, L.POSTAL_CODE, C.COUNTRY_NAME
FROM DEPARTMENTS D JOIN LOCATIONS L USING (LOCATION_ID)
    JOIN COUNTRIES C USING (COUNTRY_ID)
ORDER BY D.DEPARTMENT_NAME DESC;


-- Question 6 - Display full name of the employees, their hire date and salary
-- together with their department name, but only for departments which names start
-- with A or I. 
-- Q6 SOLUTION -- 
SELECT (E.FIRST_NAME || ' \ '|| E.LAST_NAME) "EMPLOYEE", 
    TO_CHAR(E.HIRE_DATE, 'YY-MM-DD') "HIRE DATE", 
    TO_CHAR(E.SALARY, '$99,999.99') "SALARY", D.DEPARTMENT_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME LIKE 'A%' OR D.DEPARTMENT_NAME LIKE 'I%'
ORDER BY D.DEPARTMENT_NAME, E.LAST_NAME;

-- Question 7 - Display full name of the manager of each department in 
-- provinces Ontario, New Jersey and Washington plus department name, city, 
-- postal code, and province name
-- Q7 SOLUTION --
SELECT E.LAST_NAME || ', '|| E.FIRST_NAME "Manager", D.DEPARTMENT_NAME "Dept",
L.CITY "City", L.POSTAL_CODE "PC", L.STATE_PROVINCE "State/Prov."
FROM DEPARTMENTS D LEFT OUTER JOIN EMPLOYEES E
    ON D.MANAGER_ID = E.EMPLOYEE_ID
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
WHERE L.STATE_PROVINCE LIKE 'Ontario' OR L.STATE_PROVINCE LIKE 'New Jersey'
OR L.STATE_PROVINCE LIKE 'Washington'
ORDER BY L.CITY, D.DEPARTMENT_NAME;

-- Question 8 - Display the department name and Highest, Lowest and Average
-- pay per each department. Name these results High, Low and Avg.
-- Q8 SOLUTION -- 
SELECT D.DEPARTMENT_NAME "DEPT", TO_CHAR(MAX(E.SALARY), '$99,999.99') "Highest", 
    TO_CHAR(MIN(E.SALARY), '$99,999.99') "Lowest", 
    TO_CHAR(AVG(E.SALARY), '$99,999.99') "Avg"
FROM EMPLOYEES E JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
GROUP BY (D.DEPARTMENT_NAME)
ORDER BY AVG(E.SALARY) DESC;

-- Question 9 -Display the employee last name and employee number along with 
-- their manager’s last name and manager number. Label the columns Employee, 
-- Emp#, Manager, and Mgr#, respectively. Include also employees who do NOT 
-- have a manager and also employees who do NOT supervise anyone
-- Q9 SOLUTION -- 
SELECT E.LAST_NAME "Employee", E.EMPLOYEE_ID "Emp#", M.LAST_NAME "Manager",
    M.EMPLOYEE_ID "Mgr#"
FROM EMPLOYEES E FULL OUTER JOIN EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID

