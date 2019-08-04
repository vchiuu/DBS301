-- ***********************************************************************
-- Name: VIVIAN CHIU
-- ID: 133088187
-- Date: Wednesday, July 24th 2019
-- Purpose: Lab 9 DBS301 (DDL & DML)
-- ***********************************************************************

-- Question 1 - Create table L09SalesRep and load it with data from table
-- EMPLOYEES table. Use only the equivalent columns from EMPLOYEE: RepId, 
-- FName, LName, Phone#, Salary, Commission (only for those people in 
-- department 80)

CREATE TABLE L09SalesRep AS
    SELECT EMPLOYEE_ID AS RepID, FIRST_NAME AS FName, LAST_NAME AS LName, 
        PHONE_NUMBER AS Phone#, SALARY AS Salary, COMMISSION_PCT AS COMMISSION
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = 80;

-- Question 2 - Create table L09Cust and load it with data from table
-- EMPLOYEES table.

CREATE TABLE L09Cust (
    CUST#       NUMBER(6), 
    CustName    VARCHAR2(30), 
    City        VARCHAR2(20), 
    Rating      CHAR(1), 
    Comments    VARCHAR(200), 
    SalesRep#   NUMBER(7)
    );

INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (501, 'ABC LTD.', 'Montreal', 'C', 201);
INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (502, 'Black Giant', 'Ottawa', 'B', 202);
INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (503, 'Mother Goose', 'London', 'B', 202);
INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (701, 'BLUE SKY LTD', 'Vancouver', 'B', 102);
INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (702, 'MIKE and SAM Inc.', 'Kingston', 'A', 107);
INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (703, 'RED PLANET', 'Mississauga', 'C', 107);
INSERT INTO L09Cust (CUST#, CustName, City, Rating, SalesRep#) VALUES (717, 'BLUE SKY', 'Regina', 'D', 102);

-- Question 3 - Create table L09GoodCust using columns: CustId, Name, Location, 
-- RepId

CREATE TABLE L09GoodCust AS
    SELECT CUST# AS CustId, CustName AS CustName, City AS LocationName, SalesRep# AS RepId
    FROM L09Cust
    WHERE UPPER(Rating) IN ('A', 'B');

-- Question 4 - Add a new column to L09SalesRep called JobCode that will be of
-- variable character type with a max length of 12. Do a DESCRIBE L09SalesRep
-- to ensure it executed
ALTER TABLE L09SalesRep 
    ADD JobCode VARCHAR(12);
    
DESCRIBE L09SalesRep;
-- Question 5A - Declare column Salary in table L09SalesRep as mandatory one 
-- and Column Location in table L09GoodCust as optional one
ALTER TABLE L09SalesRep 
    MODIFY(SALARY NUMBER(8,2) NOT NULL);
-- Question 5B - Lengthen FNAME in L09SalesRep to 37. Use Describe to display
-- the result
ALTER TABLE L09SalesRep
    MODIFY(FNAME VARCHAR2(37));
    
DESCRIBE L09SalesRep;
-- Question 6 - Now get rid of the column JobCode in table L09SalesRep in a
-- way that will not affect daily performance. 
ALTER TABLE L09SalesRep
    DROP COLUMN JobCode;

-- Question 7 - Declare PK constraints in both new tables --> RepId and CustId
ALTER TABLE L09SalesRep
    ADD CONSTRAINT SalesRep_RepId_PK PRIMARY KEY (RepID);

ALTER TABLE L09GoodCust
    ADD CONSTRAINT GoodCust_CustId_PK PRIMARY KEY (CustId);

-- Question 8 - Declare UK constraints in both new tables ? Phone# and Name
ALTER TABLE L09SalesRep
    ADD CONSTRAINT SalesRep_Phone#_UK UNIQUE (Phone#);
ALTER TABLE L09SalesRep
    ADD CONSTRAINT SalesRep_SalesName_UK UNIQUE (FNAME, LNAME);

ALTER TABLE L09GoodCust
    ADD CONSTRAINT GoodCust_CustName_UK UNIQUE (CustName);

-- Question 9 - Restrict amount of Salary column to be in the range 
-- [6000, 12000] and Commission to be not more than 50%.
ALTER TABLE L09SalesRep
    ADD CONSTRAINT SalesRep_Salary_CK CHECK (SALARY >= 6000 AND SALARY <= 12000)
    ADD CONSTRAINT SalesRep_Commission_CK CHECK (COMMISSION < 0.50);

-- Question 10 - Ensure that only valid RepId numbers from table L09SalesRep 
-- may be entered in the table L09GoodCust. Why this statement has failed?
--ALTER TABLE L09GoodCust
    --ADD CONSTRAINT GoodCust_RepId_FK FOREIGN KEY (RepID)
        --REFERENCES L09SalesRep (RepID);
-- The statement failed because we cannot insert NULL for the id.

-- Question 11 - Firstly write down the values for RepId column in table 
-- L09GoodCust and then make all these values blank. Now redo the question 10. 
-- Was it successful? 
UPDATE L09GoodCust
    SET RepId = '';
ALTER TABLE L09GoodCust
    ADD CONSTRAINT GoodCust_RepId_FK FOREIGN KEY (RepID)
        REFERENCES L09SalesRep (RepID);
-- Creation of Foreign Key was successful

-- Question 12 - Disable this FK constraint now and enter old values for 
-- RepId in table L09GoodCust and save them. Then try to enable your FK 
-- constraint. What happened? 
ALTER TABLE L09GoodCust
    DISABLE CONSTRAINT GoodCust_RepId_FK;

UPDATE L09GoodCust SET RepId = 202 WHERE CUSTID = 502;
UPDATE L09GoodCust SET RepId = 202 WHERE CUSTID = 503;
UPDATE L09GoodCust SET RepId = 102 WHERE CUSTID = 701;
UPDATE L09GoodCust SET RepId = 107 WHERE CUSTID = 702;

ALTER TABLE L09GoodCust
    ENABLE CONSTRAINT GoodCust_RepId_FK;
-- Enabling the foreign key failed because the table has values that
-- conflict the constraint 

-- Question 13 - Get rid of this FK constraint. Then modify your CK 
-- constraint from question 9 to allow Salary amounts from 5000 to 15000.
ALTER TABLE L09SalesRep
    DROP CONSTRAINT SalesRep_Salary_CK;
    
ALTER TABLE L09SalesRep   
    ADD CONSTRAINT SalesRep_Salary_CK CHECK (SALARY >= 5000 AND SALARY <= 15000);
    
-- Question 14 - Describe both new tables L09SalesRep and L09GoodCust 
-- and then show all constraints for these two tables by running the 
-- following query
SELECT  CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE UPPER(TABLE_NAME) IN ('L09SALESREP', 'L09GOODCUST')
ORDER BY 4,2;
