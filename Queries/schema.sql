-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
     emp_no int NOT NULL,
	 birth_date date NOT NULL,
     first_name VARCHAR NOT NULL,
	 last_name VARCHAR NOT NULL,
	 hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR (4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (title)
);

COPY departments FROM '/Users/cristinalefemine/Public/departments.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM '/Users/cristinalefemine/Public/employees.csv' DELIMITER ',' CSV HEADER;
COPY dept_manager FROM '/Users/cristinalefemine/Public/dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM '/Users/cristinalefemine/Public/salaries.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM '/Users/cristinalefemine/Public/dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM '/Users/cristinalefemine/Public/titles.csv' DELIMITER ',' CSV HEADER;