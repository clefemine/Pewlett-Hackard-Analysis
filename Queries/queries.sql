SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
	FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
	FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
	 FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no,
	first_name,
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info;

SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
	INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
	INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT ri.emp_no,
ri.first_name,
ri.last_name,
di.dept_name	
 INTO sales_info
FROM retirement_info as ri
left JOIN dept_info AS di
ON (ri.emp_no = di.emp_no);

SELECT * FROM sales_info
WHERE dept_name IN ('Sales', 'Development');


-- List of current retire employees and with job title
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ti.title,
	ti.from_date,
	ti.to_date,
	sa.salary
INTO retire_title_info
FROM retirement_info as ri
INNER JOIN titles as ti
ON (ri.emp_no=ti.emp_no)
INNER JOIN salaries as sa
ON (ri.emp_no=sa.emp_no)
WHERE (ti.to_date = '9999-01-01');

SELECT * FROM retire_title_info;
DROP TABLE retire_title_info;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 salary,
 from_date,
 title
INTO retirees_current_title
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 salary,
 from_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retire_title_info
 ) tmp WHERE rn = 1
ORDER BY emp_no;

DROP TABLE retirees_current_title;

--Count the number of current retiring employees based on their job title
SELECT COUNT(rct.emp_no), rct.title
INTO retiree_count
FROM retirees_current_title as rct
GROUP BY rct.title
ORDER BY rct.title;

DROP TABLE retiree_count;

-- Create new table for current employees per title
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO employee_title_count
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no=ti.emp_no)
WHERE (ti.to_date = '9999-01-01');

DROP TABLE employee_title_count;

-- partition out duplicate current employees with past titles
SELECT emp_no,
 first_name,
 last_name,
 from_date,
 title
INTO current_titles
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 from_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM employee_title_count
 ) tmp WHERE rn = 1
ORDER BY emp_no;

DROP TABLE current_titles;

--Count the current employees per job title
SELECT COUNT(ct.emp_no), ct.title
INTO title_count
FROM current_titles as ct
GROUP BY ct.title;

DROP TABLE title_count;

-- Create new table for eligible current employees for mentor program
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date,
	e.birth_date
INTO eligible_mentors
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no=ti.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (ti.to_date = '9999-01-01');

DROP TABLE eligible_mentors_info;

-- Partition the data to show only most recent title per eligible employee
SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 to_date
INTO eligible_mentors_info
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 to_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM eligible_mentors
 ) tmp WHERE rn = 1
ORDER BY emp_no;