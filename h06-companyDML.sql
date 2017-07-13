

-- File: companyDML-b-solution 
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance.pdf; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-b.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-b.out
SET ECHO ON
-- ------------------------------------------------------------
-- 
-- Name: < Vincent Ball >
--
-- -------------------------------------------------------------
--
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10B)
Find the ssn and last name of every employee whose ssn contains two consecutive 8's, and has a supervisor. Sort the results by ssn.
*/
select ssn, Lname
from Employee E
where ssn LIKE '%88%' AND Super_ssn IS NOT null
order by ssn;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11B)
For every employee who works for more than 20 hours on any project that is controlled by the research department: Find the ssn, project number,  and number of hours. Sort the results by ssn.
*/
select DISTINCT W.essn, W.pno, W.hours
from Project P , Works_On W, Department D
where W.hours > 20  and W.pno= P.pnumber and P.dnum= 5 
order by W.essn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12B)
Write a query that consists of one block only.
For every employee who works less than 10 hours on any project that is controlled by the department he works for: Find the employee's lname, his department number, project number, the number of the department controlling it, and the number of hours he works on that project. Sort the results by lname.
*/
select E.lname, E.dno, W.pno, P.dnum, W.hours
from Employee E, Works_On W, Project P
where E.ssn = W.essn and W.hours < 10 
and W.pno = P.pnumber and P.dnum = E.dno
order by E.lname;
--
-- JOINING 4 TABLES -------------------------
--
/*(13B)
For every employee who works on any project that is located in Houston: Find the employees ssn and lname, and the names of his/her dependent(s) and their relationship(s) to the employee. Notice that there will be one row per qualyfing dependent. Sort the results by employee lname.
*/
select DISTINCT E.ssn, E.lname, D.dependent_name, D.relationship
from Employee E, Project P, Dependent D, Works_On W
where W.essn = E.ssn AND W.pno = P.pnumber AND P.plocation = 'Houston' AND D.essn = E.ssn
order by E.lname;
--
-- SELF JOIN -------------------------------------------
--
/*(14B)
Write a query that consists of one block only.
For every employee who works for a department that is different from his supervisor's department: Find his ssn, lname, department number; and his supervisor's ssn, lname, and department number. Sort the results by ssn.  
*/
select E1.ssn, E1.lname , E1.dno, E2.ssn, E2.lname , E2.dno
from Employee E1, Employee E2
where E1.super_ssn = E2.ssn and E1.dno <> E2.dno
order by E1.ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE --------------------
--
/*(15B)
Find pairs of employee lname's such that the two employees in the pair work on the same project for the same number of hours. List every pair once only. Sort the result by the lname in the left column in the result. 
*/
select E1.lname , E2.lname
from Employee E1, Employee E2, Works_On W1, Works_On W2
where E1.ssn = W1.essn and E2.ssn = W2.essn 
and W1.pno = W2.pno
and W1.hours = W2.hours
and E1.lname < E2.lname
order by E1.lname;
--
/*(16B)
For every employee who has more than one dependent: Find the ssn, lname, and number of dependents. Sort the result by lname
*/
select E.ssn, E.lname, COUNT(*)
from Employee E, Dependent D
where E.ssn = D.essn
GROUP BY E.ssn, E.lname
HAVING COUNT(*) > 1
order by E.lname;
-- 
/*(17B)
For every project that has more than 2 employees working on and the total hours worked on it is less than 40: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/
select P.pnumber, P.pname, count(*), sum(hours)
from   Project P, Works_On W
where  P.pnumber = W.pno
group by P.pnumber, P.pname
having count(*)>2 and sum(hours) < 40
order by P.pnumber;
--
-- CORRELATED SUBQUERY --------------------------------
--
/*(18B)
For every employee whose salary is above the average salary in his department: Find the dno, ssn, lname, and salary. Sort the results by department number.
*/
SELECT UNIQUE E.dno, E.ssn, E.lname, E.salary
FROM employee E, 
       (SELECT E.dno, AVG (E.salary) avg
       FROM employee E, employee E1
       WHERE E.dno = E1.dno 
       GROUP BY E.dno ) T
WHERE E.salary > T.AVG 
ORDER BY E.dno;
--
-- CORRELATED SUBQUERY -------------------------------
--
/*(19B)
For every employee who works for the research department but does not work on any one project for more than 20 hours: Find the ssn and lname. Sort the results by lname
*/
select E.ssn, E.lname
from Employee E, Department D
where E.dno = D.dnumber AND D.dname = 'Research' AND 20 >= (select MAX(W.hours)
  from Works_On W
  where E.ssn = W.essn)
order by E.lname;
--
-- DIVISION ---------------------------------------------
--
/*(20B) Hint: This is a DIVISION query
For every employee who works on every project that is controlled by department 4: Find the ssn and lname. Sort the results by lname
*/
select ssn, lname
from employee
where not exists ( (select pnumber from project where dnum = 4)
                   MINUS 
                   (select pno from works_on where essn = ssn)
                 )
order by lname;
--
SET ECHO OFF
SPOOL OFF



