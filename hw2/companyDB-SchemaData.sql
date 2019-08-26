-- company Sample Database
-- Version 1.0

-- SHOW VARIABLES;
-- SELECT @@GLOBAL.sql_mode;
-- SELECT @@SESSION.sql_mode;

-- SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;					/* Default : 1 (ON) */
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;		/* Default : 1 (ON) */	

DROP SCHEMA IF EXISTS company;

CREATE SCHEMA company DEFAULT CHARACTER SET utf8;
USE company;

DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS dependent;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS dept_locations;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS works_on;



-------------------------------------------
-- Schema
-------------------------------------------

CREATE TABLE employee (
	Ssn 		CHAR(9) 		NOT NULL,
	Fname 		VARCHAR(15) 	NOT NULL,
	Minit 		CHAR(1),
	Lname 		VARCHAR(15) 	NOT NULL,
	Bdate 		DATE,
	Address 	VARCHAR(30),
	Sex 		CHAR(1),
	Salary 		DECIMAL(10,2),
	Super_ssn 	CHAR(9),
	Dno 		INT(11) 		NOT NULL,		/* FK */
	PRIMARY KEY (Ssn),
	INDEX 		idx_Super_ssn	(Super_ssn ASC),
	INDEX 		idx_Dno 		(Dno ASC),   
	CONSTRAINT 	fk_employee_employee	FOREIGN KEY (Super_ssn)	REFERENCES employee (Ssn)
    										ON DELETE CASCADE
											ON UPDATE CASCADE,
	CONSTRAINT 	fk_department_employee	FOREIGN KEY (Dno)		REFERENCES department (Dnumber) 
											ON DELETE CASCADE
											ON UPDATE CASCADE
											/* FOREIGN_KEY_CHECKS=1이면, 두번째 FK 제약조건에서 에러 발생함. */
);

CREATE TABLE dependent (
	Essn			CHAR(9) 	NOT NULL,
	Dependent_name	VARCHAR(15)	NOT NULL,
	Sex 			CHAR(1),
	Bdate 			DATE,
	Relationship	VARCHAR(8),
	PRIMARY KEY 	(Essn, Dependent_name),
	CONSTRAINT		fk_employee_dependent	FOREIGN KEY (Essn)	REFERENCES employee (Ssn)
												ON DELETE CASCADE
												ON UPDATE CASCADE
);

CREATE TABLE department (
	Dnumber 		INT(11) 	NOT NULL,
	Dname 			VARCHAR(15) NOT NULL,
	Mgr_ssn 		CHAR(9) 	NOT NULL,		/* FK */
	Mgr_start_date	DATE,
	PRIMARY KEY 	(Dnumber),
	UNIQUE INDEX 	idx_Dname 	(Dname ASC),
	INDEX 			idx_Mgr_ssn (Mgr_ssn ASC),
	CONSTRAINT 		fk_employee_department	FOREIGN KEY (Mgr_ssn)	REFERENCES employee (Ssn)
												ON DELETE CASCADE
												ON UPDATE CASCADE
);

CREATE TABLE dept_locations (
	Dnumber			INT(11) 	NOT NULL,
	Dlocation		VARCHAR(15) NOT NULL,
	PRIMARY KEY 	(Dnumber, Dlocation),
	CONSTRAINT 		fk_departtment_locations	FOREIGN KEY (Dnumber)	REFERENCES department (Dnumber)
												ON DELETE CASCADE
												ON UPDATE CASCADE
);

CREATE TABLE project (
	Pnumber			INT(11) 	NOT NULL,
	Pname			VARCHAR(15) NOT NULL,
	Plocation 		VARCHAR(15),
	Dnum 			INT(11) 	NOT NULL,		/* FK */
    PRIMARY KEY 	(Pnumber),
	UNIQUE INDEX	idx_Pname 	(Pname ASC),
	INDEX 			idx_Dnum 	(Dnum ASC),
	CONSTRAINT 		fk_department_project	FOREIGN KEY (Dnum)	REFERENCES department (Dnumber)
												ON DELETE CASCADE
												ON UPDATE CASCADE
);

CREATE TABLE works_on (
	Essn 			CHAR(9) 	NOT NULL,
	Pno	 			INT(11) 	NOT NULL,
	Hours			DECIMAL(3,1),
	PRIMARY KEY 	(Essn, Pno),
	INDEX 			idx_Pno 	(Pno ASC),
	CONSTRAINT 		fk_employee_works_on 	FOREIGN KEY (Essn) 	REFERENCES employee (Ssn)
												ON DELETE CASCADE
												ON UPDATE CASCADE,  
    CONSTRAINT 		fk_project_works_on		FOREIGN KEY (Pno)	REFERENCES project (Pnumber)
												ON DELETE CASCADE
												ON UPDATE CASCADE
);


-------------------------------------------
-- Data
-------------------------------------------

--  Data for employee (8 instances)

INSERT INTO employee VALUES
('123456789', 'John', 'B', 'Smith', '1965-01-09', '731 Fondren, Houston, TX','M',30000,'333445555',5),
('333445555', 'Franklin', 'T', 'Wong', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000.0, '888665555', 5),
('453453453', 'Joyce', 'A', 'English', '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000.0, '987654321', 5),
('666884444', 'Ramesh', 'K', 'Narayan', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000.0, '333445555', 5),
('888665555', 'James', 'E', 'Borg', '1937-11-10', '450 Stone, Houston, TX', 'M', 55000.0, NULL, 1),
('987654321', 'Jennifer', 'S', 'Wallace', '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000.0, '888665555', 4),
('987987987', 'Ahmad', 'V', 'Jabbar', '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000.0, '987654321', 4),
('999887777', 'Alicia', 'J', 'Zelaya', '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000.0, '987654321', 4);

--  Data for dependant (7 instances)

INSERT INTO dependent VALUES
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse');

--  Data for department (3 instances)

INSERT INTO department VALUES
(1, 'Headquarters', '888665555', '1981-06-19'),
(4, 'Administration', '987654321', '1995-01-01'),
(5, 'Research', '333445555', '1988-05-22');

--  Data for dept_locations (5 instances)

INSERT INTO dept_locations VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Houston'),
(5, 'Sugarland');

--  Data for project (6 instances)

INSERT INTO project VALUES
(1, 'ProductX', 'Bellaire', 5),
(2, 'ProductY', 'Sugarland', 5),
(3, 'ProductZ', 'Houston', 5),
(10, 'Computerization', 'Stafford', 4),
(20, 'Reorganization', 'Houston', 1),
(30, 'Newbenefits', 'Stafford', 4);

--  Data for works_on (16 instances)

INSERT INTO works_on VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('666884444', 3, 40.0),
('888665555', 20, NULL),
('987654321', 20, 15.0),
('987654321', 30, 20.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('999887777', 10, 10.0),
('999887777', 30, 30.0);

-- test 

SELECT * FROM employee;

-- Q1 이름(Fname, Minit, Lname)이‘John B. Smith’인 사원의 생년월일과 주소를 검색하시오

SELECT Bdate, Address FROM employee
WHERE Fname='John' and Minit='B' and Lname='Smith';

-- Q2 부서번호가 5인 부서에 근무하는 모든 사원의 모든 컬럼을 검색하시오

SELECT * 
FROM employee
WHERE Dno=5;

-- Q3 ‘Research’ 부서에 근무하는 모든 사원의 이름, 그리고 주소를 검색하시오.

SELECT Fname, Minit, Lname, Address
FROM employee e JOIN department d ON e.Dno=d.Dnumber
WHERE d.Dname='Research';

-- Q4 ‘Stafford’에 위치한 모든 프로젝트에 대해서 ,프로젝트 번호, 담당 부서번호, 부서관리자의 이름을 검색하시오.

SELECT p.Pnumber, p.Dnum, e.Fname, e.Minit, e.Lname
FROM project p JOIN department d on p.Dnum=d.Dnumber 
	JOIN employee e ON d.Mgr_ssn=e.Ssn
WHERE p.Plocation='Stafford';

-- Q5 각 사원에 대해 사원의 이름과 성별, 그리고 직속 상사의 이름과 성별을 검색하시오. 
-- 단, 직속 상사가 없는 직원도 검색하시오. 출력 컬럼은 사원의 이름과 성별, 그리고 직속 상사의 이름과 
-- 성별 순으로 하며, 테이블 데이터는 사원 이름 중 Fname의 오름차순으로 나타내시오

SELECT e.Fname, e.Minit, e.Lname, e.Sex, s.Fname, s.Minit, s.Lname, s.Sex
FROM employee e LEFT JOIN employee s ON e.Super_ssn=s.Ssn 
ORDER BY e.Fname;

-- Q6 사원‘Franklin Wong’이 직접 관리하는 사원의 이름을 검색하시오. 
-- 테이블 데이터는 사원이름중 Fname의 오름차순으로 나타내시오.

SELECT e.Fname, e.Minit, e.Lname
FROM employee e JOIN employee s ON e.Super_ssn = s.SSN
WHERE s.Fname = 'Franklin' AND s.Lname='Wong'
ORDER BY Fname;

-- Q7 사원의 Ssn과 부서의 Dname에 대한 모든 조합을 생성하시오. 
-- 출력 컬럼은 Ssn, Dname 순으로 나열하며, 테이블 데이터는 Ssn과 Dname의 오름차순으로 출력하시오.

SELECT e.ssn, d.Dname
FROM employee e CROSS JOIN department d
ORDER BY e.Ssn, d.Dname;

-- Q8 성이 ‘Wong’인 사원이 일하는 프로젝트, 
-- 혹은 성이 ‘Wong’인 사원이 관리하는 부서에서 진행하는 프로젝트의 번호를 검색하시오. 
-- 테이블 데이터는 프로젝트 번호의 오름차순으로 나타내시오. -> Union

SELECT DISTINCT w.Pno
FROM EMPLOYEE e JOIN EMPLOYEE s ON e.Super_ssn=s.Ssn JOIN WORKS_ON w 
				ON w.ESSN =e.Ssn or w.ESSN = e.Super_ssn 
WHERE e.Lname='Wong' or s.Lname='Wong'
ORDER BY w.Pno;


-- Q9 주소에 ‘Houston, TX’이 들어있는 모든 사원의 이름을 검색하시오. 
-- 출력 컬럼은 사원의 이름, 주소 순으로 하며, 테이블 데이터는 이름 중 Fname의 오름차순으로 나타내시오.

SELECT Fname, Minit, Lname, Address
FROM EMPLOYEE 
WHERE Address like '% Houston, TX' 
ORDER BY Fname;

-- Q10 ‘ProductX’ 프로젝트에 참여하는 모든 사원의 이름, 그리고 그들의 급여를10% 올린 경우의 급여를 구하시오.

SELECT e.Fname, e.Minit, e.Lname, e.Salary*1.1 Salary
FROM EMPLOYEE e JOIN WORKS_ON w ON e.SSN = w.Essn JOIN PROJECT p ON w.Pno=p.Pnumber
WHERE p.Pname='ProductX';

-- Q11 모든 부서 이름, 부서에 소속한 사원의 이름, 그리고 각 사원이 진행하는 프로젝트 이름의 리스트를 검색하시오. 
-- 테이블 데이터는 부서 이름의 내림차순, 그리고 각 부서 내에서 사원이름의 오름차순, 프로젝트 이름의 오름차순으로 나타내시오.
SELECT d.Dname, e.Fname, e.Minit, e.Lname, p.Pname
FROM DEPARTMENT d LEFT JOIN EMPLOYEE e ON d.Dnumber = e.Dno  LEFT JOIN WORKS_ON w 
			ON e.Ssn=w.Essn JOIN PROJECT p ON w.Pno=p.Pnumber
ORDER BY d.Dname Desc, e.Fname, e.Minit, e.Lname, p.Pname ;

-- Q12 5번부서에 근무하는 사원중에서 ,ProjectX 프로젝트에 주당 10시간 이상 일하는 사원의 이름과 주당 근무시간을 검색하시오.

SELECT e.Fname, e.Minit, e.Lname, w.Hours
FROM EMPLOYEE e JOIN WORKS_ON w ON e.Ssn=w.Essn JOIN PROJECT p ON w.Pno = P.Pnumber
WHERE e.Dno=5 and p.Pname='ProductX' and w.Hours>=10;

-- Q13 배우자가 있는 사원수를 검색하시오.

SELECT count(*)
FROM EMPLOYEE e JOIN DEPENDENT d ON e.Ssn=d.Essn
WHERE d.Relationship='Spouse';

-- 아래 질의는 배우자가 2명 이상일 때 잘못 작동
-- select count(*)
-- from dependent
-- where Relationship = 'Spouse';

-- Q14 부양가족이 있는 사원에 대해, 부양 가족수를 구하시오. 
-- 출력으로 사원의 이름과 부양가족수 (컬럼 이름은 Num Of Dependents로 할 것)를 나열하시오.

SELECT e.Fname, e.Minit, e.Lname, count(*) "Num Of Dependents"
FROM EMPLOYEE e JOIN DEPENDENT d ON e.Ssn=d.Essn
GROUP BY e.Ssn	-- 집단함수에 쓰려고 group by ex. count
ORDER BY 1, 2, 3, 4 ;

-- Q15 모든 사원에 대해, 부양 가족의 이름과 관계를 구하시오. 이때 부양가족이 없는 사원도 포함합니다.
 -- 출력 컬럼은 사원의 이름, 부양 가족과의 관계, 부양 가족의 이름순으로 나열하시오. 
 -- 테이블 데이터는 사원 이름중Fname, Minit, Lname의 오름차순으로 나타내시오
SELECT e.Fname, e.Minit, e.Lname, d.Relationship, d.Dependent_name
FROM EMPLOYEE e LEFT JOIN DEPENDENT d ON e.Ssn=d.Essn 
ORDER BY 1, 2, 3;

-- Q16 모든 사원에 대해, 부양 가족수를 구하고, 이때 부양가족이 없는 사원은 부양가족 수를 0으로 표시하시오. 
-- 출력 컬럼은 사원의 이름과 부양 가족수(NumOfDependents) 순으로 나열하시오. 
-- 테이블 데이터는 부양 가족수의 내림차순, 이름 중 Fname의 오름차순으로 나타내시오.
-- COALESCE 중요!! 여기서는 count를 썼기에 0 포함
SELECT e.Fname, e.Minit, e.Lname, COALESCE(COUNT(d.Essn), 0) "NumOfDependents" 
FROM EMPLOYEE e LEFT JOIN DEPENDENT d ON e.Ssn=d.Essn
GROUP BY e.Ssn
ORDER BY 4 Desc, 1;

-- Q17 부양가족이 없는 사원의 이름을 구하시오. 테이블 데이터는 이름 중 Fname의 오름차순으로 나타내시오.

SELECT e.Fname, e.Minit, e.Lname 
FROM EMPLOYEE e
WHERE e.Ssn NOT IN ( SELECT d.Essn FROM DEPENDENT d)
ORDER BY 1;

-- Q18 자녀가 있는 사원에 대해, 부양 가족수를 구하시오. 출력컬럼으로 사원의 이름과 부양가족수(NumOfDependents) 
-- 순으로 나열하시오. 테이블 데이터는 이름 중 Fname의 오름차순으로 나타내시오.
SELECT new.Fname, new.Minit, new.Lname, COUNT(new.Ssn) "NumOfDependents"
FROM DEPENDENT d JOIN (SELECT DISTINCT e.Fname, e.Minit, e.Lname, e.Ssn FROM EMPLOYEE e 
						RIGHT JOIN DEPENDENT d1 ON e.ssn=d1.essn WHERE d1.Relationship 
                        In ("Daughter", "Son")) new ON d.essn=new.Ssn
GROUP BY new.Ssn
ORDER BY new.Fname; 

-- with temp as		//시험에서는 with 못씀(테이블 생성) -> 서브쿼리
-- (
-- 		select distinct Essn
--		from dependent
--		where Relationship in ('Son', 'Daughter')

-- select e.Fname, eMinit, e.Lname, count(*) as NumOfDependents
-- from temp t
--		join employee e on t.Essn = e.Ssn
--		join dependent d on e.Ssn = d.Essn
-- group by 
                        
                        
-- Q19 각 부서에 대해, 부서의 위치와 같은 곳에서 진행되는 프로젝트를 검색하시오. 
-- 출력 컬럼은 부서 명칭, 부서위치, 프로젝트명칭, 프로젝트 위치 순으로 나열하시오. 
-- 테이블 데이터는 부서명칭과 프로젝트명칭은 오름차순으로 나타내시오.
SELECT dep_table.Dname, dep_table.Dlocation, p.Pname, p.Plocation
FROM PROJECT p JOIN (SELECT d.Dname, d.Dnumber, dl.Dlocation FROM DEPARTMENT d JOIN 
					DEPT_LOCATIONS dl ON d.Dnumber=dl.Dnumber) dep_table
						ON p.Plocation=dep_table.Dlocation and p.Dnum=dep_table.Dnumber	
ORDER BY dep_table.Dname, p.Pname;

                     
                        




-- SET SQL_MODE=@OLD_SQL_MODE;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

