# EMPLOYEE [DATABASE](https://github.com/datacharmer/test_db)

[EMPLOYEE TABLEAU](https://public.tableau.com/app/profile/julia8260/viz/employee-final2/LANDING_)

## Objective

The objective of this project is to perform analysis on the employee database by creating necessary relationships in the tables, including joins, relations, unions, and data blending. The project also involves creating a workbook with four dashboards based on the provided requirements.

## Project Overview

Create the necessary relationships in the NF4 database tables using joins, relations, unions, and data blending techniques.

Design a workbook with four dashboards, each serving a specific purpose.

Dashboard 1: Target Page

Include a captivating image or visualization as the main header.

Provide a brief description of the workbook's purpose and content.

Dashboard 2: Custom Type

Design the second dashboard with any type of visualization that suits the analysis requirements.

Dashboard 3: Custom Type

Design the third dashboard with any type of visualization that suits the analysis requirements.

Dashboard 4: Custom Type

Design the fourth dashboard with any type of visualization that suits the analysis requirements.

Add a navigation bar to the top of the dashboard to enhance user experience and easy navigation.

Utilize parameters, table calculations, and LOD calculations as needed in the workbook.

Maintain a consistent and concise design throughout all dashboards, including fonts, alignment, headers, appropriate legends, and filter placement.

Structure the workbook using the template covered in the course, including grouping worksheets, hiding unused sheets, organizing dimensions and measures into folders, and adding comments to calculations.

Provide an option on the landing page to choose one of two or three different color palettes, which will be applied to all dashboards for visual consistency.

## Conclusion

This project involves performing data analysis on the NF4 database by establishing relationships between tables, creating insightful dashboards, and presenting the analysis in an organized and visually appealing manner. By following the provided requirements, the resulting workbook will provide users with a comprehensive view of the data and enable them to make informed decisions based on the presented insights.

[EMPLOYEE SQL](https://github.com/vuntesmeri/Final-Project/blob/dea891fec43e6315d537d2e7d19c2de54dd5e48f/Employee_SQL.sql)

## Objective
The objective of this project is to analyze a database related to employee salaries and departments. The project includes several tasks, such as calculating average salaries, analyzing department-wise salary trends, identifying the largest department each year, finding the longest-serving manager, and identifying employees eligible for timely salary payments during a financial crisis. Additionally, a database design task is included to manage courses, involving the creation of tables, partitioning, indexing, and adding test data.

## Tasks

### Average Salary by Year:

Calculate and display the average salary of employees for each year.
Consider only employees who worked during the reporting period (from the beginning until 2005).
Average Salary by Department:

Calculate and display the average salary of employees for each department.
Include only current departments and current salaries.
Average Salary by Department and Year:

Calculate and display the average salary of employees for each department in each year.
Calculate the average salary of employees who were in a particular department in a specific year.
Largest Department and Average Salary by Year:

Identify the largest department (in terms of employee count) for each year.
Display the average salary of the largest department for each corresponding year.
Longest-Serving Manager:

Retrieve detailed information about the manager who has been serving the longest in their current position.
Top 10 Employees with Salary Difference:

Identify the top 10 current employees with the highest salary difference compared to the average salary in their respective departments.
Timely Salary Payments during Crisis:

Determine the list of employees who will receive timely salary payments during a financial crisis.
Consider a budget of 500,000 dollars allocated for salary payments.
Note that the database stores annual salary amounts, while payments are made on a monthly basis.
Database Design

### Course Management Database:

Design a database to manage courses with the following entities:
students: student_no, teacher_no, course_no, student_name, email, birth_date.
teachers: teacher_no, teacher_name, phone_no.
courses: course_no, course_name, start_date, end_date.
Implement range partitioning on the students table based on the birth_date field.
Set a composite primary key on the students table using the student_no and birth_date fields.
Create an index on the students.email field.
Create a unique index on the teachers.phone_no field.
Test Data:

Add 7-10 sample rows to each of the three tables: students, teachers, and courses.
Query Execution Plan:

Retrieve data for any specific year from the students table and note the execution plan, including the relevant partition.
Index Usage:

Retrieve data for a specific teacher phone number and observe the execution plan, verifying the index usage.
Make the teachers.phone_no index invisible and observe the execution plan again, expecting an "ALL" method.
Ultimately, leave the index in a visible status.
Duplicate Rows:

Introduce three duplicate rows in the students table.
Write a query to display the rows with duplicates.

## Conclusion

This project involves analyzing employee salary and department data, performing various calculations and queries to derive meaningful insights. It also includes designing and managing a course database with specific requirements. By completing these tasks, valuable information can be obtained regarding salary trends, department sizes, managerial tenure, and efficient data retrieval.
Data Analyzing and Visualisation
