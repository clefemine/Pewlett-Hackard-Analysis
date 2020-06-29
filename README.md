# Pewlett-Hackard-Analysis

## Project Overview

Pewlett Hackard has assigned the task of determining which of their employees per title will be retiring and which employees will be eligible for a mentorship program. 
-  Create a table that inner joins current employees information with their title and salary.
-  Partition table so a table is created with employees' current title.
-  Count the amount of current soon to be retiring employees per title.
-  Count the amount of current employees per title.
-  Create a new table with all current employees information including title and birthdate. Filter Table by birth date to show only employees born in 1965.
-  Partition table with current employees with filtered birthdates so that the title reflects their current title.

## Resources

-  Data sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv
-  Software: PgAdmin 4, Postgres 10.8, Visual Studio Code 1.46.1

## Summary

To create the table with current retiring employees and their information the "Inner Join" function was used on retirement_info.csv, titles.csv, and salary.csv. All files share emp_no (employee number) key so they could merge. The table produced the columns that contained; employee number, first name, last name, job title, salary, from date and to date. This presented a challenge because the table it produce contained retired employees who no longer worked with Pewlett Hackard. To solve this problem a filter was set with the "Where" command to only provide employees whose "to date" show that they are currently working. After solving this issue it is then noticed that the employees contain duplicates. This is then solved by partitioning the data and filter only the most current position per employees (refer to: retiree_current_title.csv). Using the count function and group by function the amount can be calculated for the amount of retiring employees per job title, which yielded a new table (refer to: current_retirees_count.csv). Another table was made using a similar method as the first but instead of using retirement_info.csv the employees.csv was used to count the amount of current employees per job title (refer to: title_count.csv). 

To find the list of eligible employees for the mentorship program only the employee.csv and the titles.csv had to be "Inner join" so that the table would contain all necessarty data which included; employee number, first name, last name, job title, salary, from date, to date, and birth date. Similarly as before this data needs a "Where" filter for current employees, but it also needs to include an "And" clause that filters the birth year of 1965. Following this procedure there needs to be a "Partition by" function included so that only an employee's current job title is present and there are no duplicates (refer to: eligible_mentors_info.csv). 

## Results

Our findings show that over 30,000 employees will be retiring from Pewlett Hackard. All with varying job titles. This will be small fraction compared to the amount of current employees. There are 1,549 current employees that qualify for the mentorship program. This information could be supplemented by making a table and count of the most recent hires of employees to know whether there will be enough mentors per new employee. If not then it might be best to extend the birth date range for qualifying mentors. The data is also limiting in regards to know the gender of retirees and potential mentors. Finding out this information could help create some cohesion in the workplace and create a diversity in mentorships.
