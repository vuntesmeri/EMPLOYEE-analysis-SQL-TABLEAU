-- 1
USE employees;
SELECT YEAR(from_date), AVG(salary)
FROM salaries
WHERE YEAR(to_date) <= 2005
GROUP BY YEAR(from_date);

-- в таблице много задвоенных строк в данном случае мы можем их изменить и построить выбоку с учетом изменений, но результат изменился незначительно (не считая 2002 год).
USE employees;
SELECT new_tab.correct_year_from, AVG(salary)
FROM(
	SELECT emp_no, salary, CASE 
				WHEN salaries.from_date LIKE '%-12-%' AND first_value(salaries.from_date) 
				OVER (PARTITION BY salaries.emp_no ORDER BY salaries.from_date) NOT LIKE '%-12-%'  THEN Year(salaries.from_date) + 1 
				ELSE YEAR(salaries.from_date) 
			 END as correct_year_from
	FROM salaries) as new_tab
WHERE new_tab.correct_year_from < 2005
GROUP BY new_tab.correct_year_from;

-- 2
USE employees;
SELECT dept_emp.dept_no, AVG(salaries.salary)
FROM employees.salaries
LEFT JOIN dept_emp
ON salaries.emp_no = dept_emp.emp_no
WHERE dept_emp.to_date LIKE '999%' AND salaries.to_date LIKE '999%'
GROUP BY dept_emp.dept_no;

-- 3
USE employees;
SELECT dept_no, s_from_year, AVG(salary)
FROM (
	SELECT  dept_emp.emp_no,
			dept_emp.dept_no,
			YEAR(dept_emp.from_date) as d_from_year, 
			YEAR(dept_emp.to_date) as d_to_year, 
			salaries.salary, 
			YEAR(salaries.from_date) as s_from_year, 
			YEAR(salaries.to_date) as s_to_year
	FROM dept_emp
	LEFT JOIN salaries
	ON dept_emp.emp_no = salaries.emp_no
	WHERE YEAR(salaries.from_date) >= YEAR(dept_emp.from_date) AND YEAR(salaries.to_date) <= YEAR(dept_emp.to_date)) as new_tab
GROUP BY new_tab.dept_no, new_tab.s_from_year
ORDER BY new_tab.dept_no;

-- 4
USE employees;
SELECT *
FROM (
	SELECT *, rank() OVER (partition by qq.s_from_year ORDER BY qq.quantity_emp DESC) as rank_dept
	FROM
	(SELECT DISTINCT s_from_year, dept_no, 
			COUNT(emp_no) OVER (PARTITION BY s_from_year, dept_no) as quantity_emp, 
            AVG(salary) OVER (PARTITION BY s_from_year, dept_no) as avg_salary
	FROM (SELECT  dept_emp.emp_no,
				  dept_emp.dept_no,
				  YEAR(dept_emp.from_date) as d_from_year, 
				  YEAR(dept_emp.to_date) as d_to_year, 
				  salaries.salary, 
				  YEAR(salaries.from_date) as s_from_year, 
				  YEAR(salaries.to_date) as s_to_year
	FROM dept_emp
	LEFT JOIN salaries
	ON dept_emp.emp_no = salaries.emp_no
	WHERE YEAR(salaries.from_date) >= YEAR(dept_emp.from_date) AND YEAR(salaries.to_date) <= YEAR(dept_emp.to_date)) as new_tab)as qq) as q
WHERE q.rank_dept = 1;

-- 5
USE employees;
SELECT @var:=emp_no, RANK() OVER (ORDER BY from_date)
FROM dept_manager
WHERE to_date LIKE '999%'
LIMIT 1;

SELECT *
FROM employees.employees
WHERE emp_no = @var;

-- 6
USE employees;
SELECT *,  RANK() OVER (ORDER BY ds.absdif DESC)
FROM (
	SELECT d.emp_no, d.dept_no, s.salary, ABS(s.salary - AVG(s.salary) OVER (PARTITION BY d.dept_no)) as absdif
	FROM (SELECT * FROM dept_emp WHERE dept_emp.to_date LIKE '999%') as d
	LEFT JOIN (SELECT * FROM salaries WHERE salaries.to_date LIKE '999%') as s
	ON d.emp_no = s.emp_no) as ds
LIMIT 10; 

-- 7
USE employees;
SELECT *
FROM (
SELECT d.dept_no, s.emp_no, s.monthsalary, SUM(s.monthsalary) OVER (PARTITION BY d.dept_no ORDER BY s.monthsalary) cum_month
	FROM (
	SELECT salaries.emp_no, salaries.salary/12 as monthsalary
	FROM salaries
	WHERE to_date LIKE '999%') as s
	LEFT JOIN 
	(SELECT dept_emp.emp_no, dept_emp.dept_no
	FROM dept_emp
	WHERE to_date LIKE '999%') as d
	ON s.emp_no = d.emp_no) as new_tab
WHERE cum_month <= 500000;


-- ДИЗАЙН БАЗЫ ДАННЫХ

-- 1
CREATE DATABASE IF NOT EXISTS school;
USE school;
DROP TABLE IF EXISTS students;
CREATE TABLE  students (
	student_no INT NOT NULL AUTO_INCREMENT, 
    teacher_no INT, 
    course_no INT, 
    student_name VARCHAR (100), 
    email VARCHAR(50), 
    birth_date DATE,
	PRIMARY KEY (student_no, birth_date),
    INDEX student_email(email)
    )
	PARTITION BY RANGE(YEAR(birth_date)) (
	PARTITION p_adult VALUES LESS THAN(1980),
	PARTITION p_youth VALUES LESS THAN(2000),
	PARTITION p_kids VALUES LESS THAN(MAXVALUE));
	
DROP TABLE IF EXISTS teachers; 
CREATE TABLE teachers (
	teacher_no INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
    teacher_name VARCHAR(100), 
    phone_no VARCHAR(20) NOT NULL,
    UNIQUE INDEX teachers_phone (phone_no)
	);
 
DROP TABLE IF EXISTS courses; 
CREATE TABLE courses (
	course_no INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
    course_name VARCHAR(100), 
    start_date DATE, 
    end_date DATE
    );

-- 2

INSERT INTO students(teacher_no, course_no, student_name, email, birth_date)
VALUES  (6, 1, 'Fedorova Maria', 'ffof@gmail.com', '1990-08-30'),
		(1, 2, 'Kudryshov Valera', 'kudiashj@gmail.com', '1970-10-12'),
		(4, 1, 'Romanuk Katerina', 'romank@ukr.net', '2000-01-20'),
		(3, 6, 'Dadalova Rada', 'radadaf@gmail.com', '2002-09-09'),
		(1, 2, 'Lasov Igor', ' lasovflm@mail.ru', '1976-07-11'),
		(5, 5, 'Minaev Alexandr', 'globat@ukr.net', '1989-10-24'),
        (2, 4, 'Stepanov Viktor', 'svik@gmail.com', '1990-08-30');

INSERT INTO teachers(teacher_name, phone_no)
VALUES  ('Polonsky Victoria', '198-78-67'),
		('Almasova Kseniya', '856-78-09'),
		('Ivanova Arina', '268-01-23'),
		('Gutin Grigoriy', '709-54-88'),
		('Avina Iryna', '781-01-99'),
		('Mustafina  Yulia', '420 19-10'),
        ('Hohlov Ruslan', '640-90-09');

INSERT INTO courses(course_name, start_date, end_date)
VALUES  ('Linax', '2021-06-20', '2021-12-06'),
		('BBI', '2009-03-12', '2009-06-26'),
		('Java Script', '2020-10-02', '2021-03-30'),
		('BackEnd ', '2020-04-22', '2020-10-04'),
		('Python', '2019-01-19', '2019-12-23'),
		('UX', '2021-04-10', '2021-10-10'),
        ('Devops', '2020-05-19', '2021-05-19');

-- 3

EXPLAIN SELECT*
FROM students
WHERE  birth_date BETWEEN  '1990-01-01' AND '1990-12-31';
-- # id	select_type	table		partitions	type possible_keys key key_len ref	rows	filtered	Extra
--   1		SIMPLE		students	p_youth		ALL									3		33.33		Using where

-- # student_no	teacher_no	course_no	student_name	email	birth_date
-- 1	6	1	Fedorova Maria	ffof@gmail.com	1990-08-30
-- 7	2	4	Stepanov Viktor	svik@gmail.com	1990-08-30

-- 4

EXPLAIN SELECT * 
FROM teachers
WHERE phone_no = '709-54-88';
-- # id	select_type	table	 partitions	type	possible_keys	key				key_len	ref		rows	filtered	Extra
-- 1	SIMPLE	    teachers 			const	teachers_phone	teachers_phone	82		const	1		100.00	

-- # teacher_no	teacher_name	phone_no
-- 4	Gutin Grigoriy	709-54-88

ALTER TABLE teachers ALTER INDEX teachers_phone INVISIBLE;

-- # id	select_type	table	partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
-- 1	SIMPLE	    teachers		    ALL					                    7	    14.29	   Using where
ALTER TABLE teachers ALTER INDEX teachers_phone VISIBLE;

-- 5

INSERT INTO students(teacher_no, course_no, student_name, email, birth_date)
VALUES  (4, 1, 'Romanuk Katerina', 'romank@ukr.net', '2000-01-20'),
		(4, 1, 'Romanuk Katerina', 'romank@ukr.net', '2000-01-20'),
        (4, 1, 'Romanuk Katerina', 'romank@ukr.net', '2000-01-20');
        
-- 6

SELECT*
FROM(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY student_name, birth_date, email) as row_d
	FROM students) as new
WHERE row_d > 1;
