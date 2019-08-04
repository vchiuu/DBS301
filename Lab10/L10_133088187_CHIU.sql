-- ***********************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Wednesday, July 31st 2019
-- Purpose: Lab 10 DBS301 (Transactional SQL)
-- ***********************************************************************

-- Question 1 - Create a table L10Cities from LOCATIONS table, for LOCATION_ID
-- numbers less than 2000
CREATE TABLE L10Cities AS
    SELECT LOCATION_ID, STREET_ADDRESS,POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID
    FROM LOCATIONS
    WHERE LOCATION_ID < 2000;

-- Question 2 - Create a table L10Towns from LOCATIONS table, for LOCATION_ID 
-- numbers less than 1500
CREATE TABLE L10Towns AS
    SELECT LOCATION_ID, STREET_ADDRESS,POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID
    FROM LOCATIONS
    WHERE LOCATION_ID < 1500;
    
-- Question 3 - Now, empty your RECYCLE BIN. Then, remove your L10Towns table and
-- check that it is there.
PURGE RECYCLEBIN;

DROP TABLE L10Towns;

SHOW RECYCLEBIN;

-- Question 4 - Restore your table L10Towns from recycle bin and describe it. 
-- Check what is in your recycle bin now.

FLASHBACK TABLE L10Towns TO BEFORE DROP;

SHOW RECYCLEBIN;
-- Recyclebin object is invalid because it does not exist when there are no items
-- in the recycle bin. 

-- Question 5 - Now remove table L10Towns so that does NOT remain in the recycle bin.
-- Check that is really NOT there and then try to restore it. Explain what happened?
DROP TABLE L10Towns PURGE;
-- SELECT * FROM L10Towns; // Error: "table or view does not exist"
-- FLASHBACK TABLE L10Towns TO BEFORE DROP; // Error: "object not in RECYCLE BIN
-- SHOW RECYCLEBIN; // Error: Object "" is INVALID, it may not be described.
-- The table was removed and also removed from the recycle bin. Therefore, 

-- Question 6 - Create simple view called CAN_CITY_VU, based on table L10Cities so 
-- that will contain only columns Street_Address, Postal_Code, City and State_Province
-- for locations only in CANADA. Then display all data from this view.
CREATE OR REPLACE VIEW CAN_CITY_VU AS
    SELECT STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE
    FROM L10Cities
    WHERE COUNTRY_ID = 'CA';

SELECT * FROM CAN_CITY_VU;

-- Question 7 - Modify your simple view so that will have following aliases instead
-- of original column names: Str_Adr, P_Code, City and Prov and also will include 
-- cities from ITALY as well. Then display all data from this view. 
CREATE OR REPLACE VIEW CAN_CITY_VU AS
    SELECT STREET_ADDRESS AS "Str_Adr", POSTAL_CODE AS "P_Code", CITY AS "City",
		STATE_PROVINCE AS "Prov"
    FROM L10Cities
    WHERE COUNTRY_ID = 'CA';

SELECT * FROM CAN_CITY_VU;

-- Question 8 - Create complex view called vwCity_DName_VU, based on tables 
-- LOCATIONS and DEPARTMENTS, so that will contain only columns Department_Name, 
-- City and State_Province for locations in ITALY or CANADA. Include situations 
-- even when city does NOT have department established yet. Then display all data
-- from this view.
CREATE OR REPLACE VIEW vwCity_DName_VU AS
    SELECT DEPARTMENT_NAME, CITY, STATE_PROVINCE
    FROM DEPARTMENTS D RIGHT OUTER JOIN LOCATIONS L ON (D.LOCATION_ID = L.LOCATION_ID)
    WHERE UPPER(COUNTRY_ID) IN ('CA', 'IT');

SELECT * FROM vwCity_DName_VU;

-- Question 9 - Modify your complex view so that will have following aliases 
-- instead of original column names: DName, City and Prov and also will include 
-- all cities outside United States. Include situations even when city does NOT have 
-- department established yet. Then display all data from this view.
CREATE OR REPLACE VIEW vwCity_DName_VU AS
    SELECT DEPARTMENT_NAME AS "DName", CITY AS "City", STATE_PROVINCE AS "Prov"
    FROM DEPARTMENTS D RIGHT OUTER JOIN LOCATIONS L ON (D.LOCATION_ID = L.LOCATION_ID)
    WHERE UPPER(COUNTRY_ID) IN ('CA', 'IT');

SELECT * FROM vwCity_DName_VU;
-- Question 10 - Create a transaction, ensuring a new transaction is started, and 
-- include all the SQL statements required to merge the Marketing and Sales departments
-- into a single department “Marketing and Sales”.  Create a new department such that 
-- the history of employees departments remains intact.  The Sales staff will change 
-- locations to the existing Marketing department’s location.  All staff from both 
-- previous departments will change to the new department.  
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME) VALUES (200, 'Marketing and Sales');

SAVEPOINT CHGSALESLOCATION;

UPDATE DEPARTMENTS SET LOCATION_ID = 1800 WHERE UPPER(DEPARTMENT_NAME) = 'SALES';
UPDATE DEPARTMENTS SET LOCATION_ID = 1800 WHERE UPPER(DEPARTMENT_NAME) = 'MARKETING AND SALES';

SAVEPOINT CHGDEPARTMENTS;
UPDATE EMPLOYEES SET DEPARTMENT_ID = 200 WHERE DEPARTMENT_ID IN (20,80);

COMMIT;

-- Question 11 - Check in the Data Dictionary what Views (their names and definitions) 
-- are created so far in your account. Then drop your vwCity_DName_VU and check Data 
-- Dictionary again. What is different?
SELECT * FROM ALL_OBJECTS WHERE object_type = 'VIEW';
SELECT * FROM ALL_OBJECTS WHERE object_type = 'VIEW' AND LOWER(object_name) = 'vwCity_DName_VU';
DROP VIEW vwCity_DName_VU;
SELECT * FROM ALL_OBJECTS WHERE object_type = 'VIEW' AND LOWER(object_name) = 'vwCity_DName_VU';
