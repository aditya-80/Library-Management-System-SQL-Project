-- Display all records from main tables
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

--------------------------------------------------------------------------------
-- Task 13: Identify Members with Overdue Books
-- Requirement: Find members who have overdue books (assume 10000-day return period).
-- Display: member_id, member_name, book_title, issue_date, and days overdue.
--------------------------------------------------------------------------------

SELECT CURRENT_DATE;  -- Check current system date

SELECT 
    ist.issued_member_id, 
    m.member_name, 
    b.book_title, 
    ist.issued_date, 
    CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status AS ist
INNER JOIN members AS m 
    ON m.member_id = ist.issued_member_id
INNER JOIN books AS b 
    ON b.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs 
    ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL                          -- Book not returned
    AND (CURRENT_DATE - ist.issued_date) > 10000   -- Overdue more than 10000 days
ORDER BY 1;

--------------------------------------------------------------------------------
-- Task 14: Update Book Status on Return
-- Requirement: When a book is returned, update the status of that book to 'Yes'.
--------------------------------------------------------------------------------

-- Check specific issued record
SELECT * FROM issued_status WHERE issued_book_isbn = '978-0-330-25864-8';

-- Check the book record
SELECT * FROM books WHERE isbn = '978-0-451-52994-2';

-- Example update to mark a book as unavailable
UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';

-- Check return status
SELECT * FROM return_status WHERE issued_id = 'IS130';

-- Insert a return record
INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
VALUES ('RS125', 'IS130', CURRENT_DATE, 'Good');

-- Verify return record
SELECT * FROM return_status WHERE issued_id = 'IS130';

--------------------------------------------------------------------------------
-- Stored Procedure: add_return_records
-- Purpose: Insert a return record and update the book status to 'yes'.
--------------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- 1. Insert into return_status
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    -- 2. Get ISBN and Book Name from issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- 3. Update book availability
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- 4. Show confirmation message
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;

END$$

DELIMITER ;

-- Test the procedure
CALL add_return_records('RS138', 'IS135', 'Good');
CALL add_return_records('RS148', 'IS140', 'Good');

--------------------------------------------------------------------------------
-- Task 15: Branch Performance Report
-- Requirement: For each branch, show:
--    - Number of books issued
--    - Number of books returned
--    - Total revenue generated from rentals
--------------------------------------------------------------------------------

CREATE TABLE branch_reports AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_of_books_issued,
    COUNT(rs.return_id) AS number_of_books_returned,
    SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
INNER JOIN employees AS e 
    ON e.emp_id = ist.issued_emp_id
INNER JOIN branch AS b 
    ON b.branch_id = e.branch_id
LEFT JOIN return_status AS rs 
    ON rs.issued_id = ist.issued_id
INNER JOIN books AS bk 
    ON bk.isbn = ist.issued_book_isbn
GROUP BY b.branch_id, b.manager_id;

SELECT * FROM branch_reports;

--------------------------------------------------------------------------------
-- Task 16: Create Active Members Table (CTAS)
-- Requirement: Create a table with members who issued at least one book in the last 2 months.
--------------------------------------------------------------------------------

CREATE TABLE active_members AS
SELECT *
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= CURRENT_DATE - INTERVAL 2 MONTH
);

SELECT * FROM active_members;

--------------------------------------------------------------------------------
-- Task 17: Top 3 Employees by Book Issues Processed
-- Requirement: Find top 3 employees who processed the most book issues, showing their name and branch.
--------------------------------------------------------------------------------

SELECT 
    e.emp_name, 
    b.branch_name,
    COUNT(ist.issued_id) AS books_issued
FROM employees AS e
INNER JOIN issued_status AS ist
    ON e.emp_id = ist.issued_emp_id
INNER JOIN branch AS b
    ON b.branch_id = e.branch_id
GROUP BY e.emp_name, b.branch_name
ORDER BY books_issued DESC
LIMIT 3;

--------------------------------------------------------------------------------
-- Task 18: Stored Procedure issue_book
-- Purpose: Issue a book if available; if not, return an error message.
--------------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(30),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    -- Check if the book is available
    SELECT status INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        -- Insert into issued_status
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURDATE(), p_issued_book_isbn, p_issued_emp_id);

        -- Update the book status to 'no'
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Display confirmation message
        SELECT CONCAT('Book issued successfully for ISBN: ', p_issued_book_isbn) AS message;

    ELSE
        -- Display message when the book is unavailable
        SELECT CONCAT('Sorry, the book is not available. ISBN: ', p_issued_book_isbn) AS message;
    END IF;
END$$

DELIMITER ;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');



