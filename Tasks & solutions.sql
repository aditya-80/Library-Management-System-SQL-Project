-- ✅ View all tables for reference
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

------------------------------------------------------------
-- 📌 Task 1: Create a New Book Record
-- Insert the book "To Kill a Mockingbird" into the books table
------------------------------------------------------------
INSERT INTO books 
VALUES (
    '978-1-60129-456-2',        -- ISBN
    'To Kill a Mockingbird',    -- Book Title
    'Classic',                  -- Category
    6.00,                       -- Rental Price
    'yes',                      -- Availability
    'Harper Lee',               -- Author
    'J.B. Lippincott & Co.'     -- Publisher
);

-- Verify insertion
SELECT * FROM books;

------------------------------------------------------------
-- 📌 Task 2: Update an Existing Member's Address
-- Update the address of member with ID 'C101'
------------------------------------------------------------
UPDATE members 
SET member_address = '125 Main St'
WHERE member_id = 'C101';

-- Verify update
SELECT * FROM members;

------------------------------------------------------------
-- 📌 Task 3: Delete a Record from the Issued Status Table
-- Delete the record where issued_id = 'IS121'
------------------------------------------------------------
SELECT * FROM issued_status WHERE issued_id = 'IS121';
DELETE FROM issued_status WHERE issued_id = 'IS121';

-- Verify deletion
SELECT * FROM issued_status;

------------------------------------------------------------
-- 📌 Task 4: Retrieve All Books Issued by a Specific Employee
-- Get all books issued by employee with emp_id = 'E101'
------------------------------------------------------------
SELECT * FROM issued_status WHERE issued_emp_id = 'E101';

------------------------------------------------------------
-- 📌 Task 5: List Employees Who Have Issued More Than One Book
-- Use GROUP BY and HAVING to filter employees with multiple issues
------------------------------------------------------------
SELECT ist.issued_emp_id, e.emp_name 
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
GROUP BY 1, 2
HAVING COUNT(ist.issued_id) > 1;

------------------------------------------------------------
-- 📌 Task 6: Create a Summary Table Using CTAS
-- Create a table (book_cnts) showing each book and total issued count
------------------------------------------------------------
CREATE TABLE book_cnts AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

-- Verify summary table
SELECT * FROM book_cnts;

------------------------------------------------------------
-- 📌 Task 7: Retrieve All Books in a Specific Category
-- Example: Get all books under 'Classic' category
------------------------------------------------------------
SELECT * FROM books WHERE category = 'Classic';

------------------------------------------------------------
-- 📌 Task 8: Find Total Rental Income by Category
-- Sum of rental price and count of issued books grouped by category
------------------------------------------------------------
SELECT b.category, 
       SUM(b.rental_price) AS total_rental_income, 
       COUNT(*) AS total_issued_books
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;

------------------------------------------------------------
-- 📌 Task 9: List Members Who Registered in the Last 180 Days
-- Insert sample members first, then filter using date condition
------------------------------------------------------------
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C118', 'sam', '145 Main St', '2025-06-01'),
('C119', 'john', '133 Main St', '2025-05-01');

-- Get members registered within last 180 days
SELECT * FROM members 
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;

-- Verify all members
SELECT * FROM members;

------------------------------------------------------------
-- 📌 Task 10: List Employees with Their Branch Manager's Name and Branch Details
------------------------------------------------------------
SELECT e1.*, 
       b.manager_id, 
       e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b ON b.branch_id = e1.branch_id
JOIN employees AS e2 ON b.manager_id = e2.emp_id;

------------------------------------------------------------
-- 📌 Task 11: Create a Table of Books with Rental Price Above 7 USD
------------------------------------------------------------
CREATE TABLE books_price_greater_than_seven AS
SELECT * FROM books WHERE rental_price > 7;

-- Verify new table
SELECT * FROM books_price_greater_than_seven;

------------------------------------------------------------
-- 📌 Task 12: Retrieve the List of Books Not Yet Returned
-- Use LEFT JOIN and check for NULL in return_status
------------------------------------------------------------
SELECT DISTINCT ist.issued_book_name
FROM issued_status AS ist
LEFT JOIN return_status AS rst ON ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL;
