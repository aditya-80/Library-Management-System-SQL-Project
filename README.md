# 📚 Library Management System – SQL Project
## ✅ Overview

This project implements a Library Management System using SQL.
It is designed to manage essential library operations such as:
1. Maintaining records of branches, employees, members, and books.
2. Tracking issued books and returned books.
3. Performing various queries, reports, and stored procedures to analyze and automate operations.

The project is split into four main files:
1. Library Project SQL.sql → Database creation & schema design.
2. insert_queries.sql → Inserts and table modifications.
3. task & solutions.sql → Practical queries and operations.
4. advanced_tasks.sql (extension from task & solutions) → Stored procedures & analytical reports.

## 🏗️ Database Schema

The system consists of the following main tables:
- branch → Stores library branch details.
- employees → Stores employee information, linked to branches.
- members → Stores library members and registration details.
- books → Stores book records (ISBN, title, category, rental price, status, etc.).
- issued_status → Tracks book issues (member, book, employee, date).
- return_status → Tracks book returns (issued record, return date, book quality).

## 📂 Files in the Project
1️⃣ Library Project SQL.sql

- Creates the library database.
- Defines and relates all main tables.
- Sets up primary keys, foreign keys, and constraints.

2️⃣ insert_queries.sql

- Inserts sample data for testing (members, branches, employees, books, issues, returns).
- Demonstrates ALTER, UPDATE, DELETE operations.
- Adds new column book_quality in return_status.

3️⃣ task & solutions.sql

- Implements real-world tasks using SQL queries:
- Insert, update, and delete operations.
- Queries for issued/returned books.
- Revenue and rental summaries.
- Category-wise and employee-wise reports.
- Active members and overdue book detection.
- Creating derived tables with CTAS.

4️⃣ advanced_tasks.sql (extension)

- Implements stored procedures:
-   add_return_records → Inserts return record & updates book availability.
-   issue_book → Issues a book only if available, otherwise throws error message.
- Creates branch performance reports.
- Identifies top employees and active members.

## 🛠️ Features Implemented

📌 CRUD operations → Add, update, delete members/books/issues.
📌 Relational integrity with primary/foreign keys.
📌 Reports & Analytics → Revenue, overdue books, employee performance.
📌 Stored Procedures for automation (issue/return handling).
📌 Business queries for library insights.

## 🚀 How to Use

1. Import all .sql files into your MySQL/MariaDB environment.
2. Run Library Project SQL.sql to create the schema.
3. Run insert_queries.sql to load sample data.
4. Run queries from task & solutions.sql for hands-on tasks.
5. Use stored procedures in advanced_tasks.sql for automation.

## 📊 Example Queries

List all books in the ‘Classic’ category: 
  SELECT * FROM books WHERE category = 'Classic';


Find employees who issued more than one book:
  SELECT ist.issued_emp_id, e.emp_name 
  FROM issued_status AS ist
  JOIN employees AS e ON e.emp_id = ist.issued_emp_id
  GROUP BY 1, 2
  HAVING COUNT(ist.issued_id) > 1;


Check members who registered in the last 180 days:
  SELECT * FROM members 
  WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;

## 📌 Future Improvements
- Add user authentication for staff and members.
- Integrate with a front-end system (web app / GUI).
- Implement fines/penalties for overdue books.
- Enhance reporting with visual dashboards (e.g., Power BI).

