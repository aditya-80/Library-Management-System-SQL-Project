-- Library Management System Project

------------------------------------------------------------
-- Step 1: Create the Database and Use It
------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS library;
USE library;

------------------------------------------------------------
-- Step 2: Create Table: branch
-- Stores branch details of the library
------------------------------------------------------------
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,     -- Unique ID for branch
    manager_id VARCHAR(10),                -- Manager ID (will link to employees table)
    branch_address VARCHAR(30),            -- Address of the branch
    contact_no VARCHAR(15)                 -- Contact number
);

------------------------------------------------------------
-- Step 3: Create Table: employees
-- Stores employee details, linked to branch
------------------------------------------------------------
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,        -- Employee ID
    emp_name VARCHAR(30),                  -- Employee Name
    position VARCHAR(30),                  -- Position (e.g., Manager, Clerk)
    salary DECIMAL(10,2),                  -- Salary
    branch_id VARCHAR(10),                 -- Foreign key referencing branch
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

------------------------------------------------------------
-- Step 4: Create Table: members
-- Stores library member details
------------------------------------------------------------
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,     -- Unique Member ID
    member_name VARCHAR(30),               -- Member Name
    member_address VARCHAR(30),            -- Member Address
    reg_date DATE                          -- Registration Date
);

------------------------------------------------------------
-- Step 5: Create Table: books
-- Stores book details
------------------------------------------------------------
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(50) PRIMARY KEY,          -- ISBN number (Unique identifier for books)
    book_title VARCHAR(80),                -- Title of the book
    category VARCHAR(30),                  -- Book category (e.g., Fiction, Classic)
    rental_price DECIMAL(10,2),            -- Rental price of the book
    status VARCHAR(10),                    -- Availability status (e.g., yes/no)
    author VARCHAR(30),                    -- Author name
    publisher VARCHAR(30)                  -- Publisher name
);

------------------------------------------------------------
-- Step 6: Create Table: issued_status
-- Stores information about issued books
------------------------------------------------------------
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issued_id VARCHAR(10) PRIMARY KEY,         -- Unique ID for issued record
    issued_member_id VARCHAR(30),              -- Foreign key referencing member
    issued_book_name VARCHAR(80),              -- Name of the issued book
    issued_date DATE,                          -- Date of issue
    issued_book_isbn VARCHAR(50),              -- ISBN of issued book
    issued_emp_id VARCHAR(10),                 -- Employee who issued the book
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn)
);

------------------------------------------------------------
-- Step 7: Create Table: return_status
-- Stores information about returned books
------------------------------------------------------------
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,         -- Unique ID for return record
    issued_id VARCHAR(30),                     -- Issued ID to track which issue record it belongs to
    return_book_name VARCHAR(80),              -- Name of the returned book
    return_date DATE,                          -- Date of return
    return_book_isbn VARCHAR(50),              -- ISBN of returned book
    FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
