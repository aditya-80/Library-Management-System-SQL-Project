-- ============================================
-- Insert issued book records for the last 30 days
-- ============================================
INSERT INTO issued_status (
    issued_id, 
    issued_member_id, 
    issued_book_name, 
    issued_date, 
    issued_book_isbn, 
    issued_emp_id
)
VALUES
    -- Issued 24 days ago
    ('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 DAY, '978-0-553-29698-2', 'E108'),

    -- Issued 13 days ago
    ('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 DAY, '978-0-553-29698-2', 'E109'),

    -- Issued 7 days ago
    ('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 DAY, '978-0-14-143951-8', 'E107'),

    -- Issued 32 days ago (outside 30-day range but included intentionally)
    ('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 DAY, '978-0-375-50167-0', 'E101');


-- ============================================
-- Add a new column 'book_quality' in return_status table
-- Default value set to 'good'
-- ============================================
ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(15) DEFAULT 'good';


-- ============================================
-- Update 'book_quality' for specific returned books
-- Mark as 'Damaged' for the given issued IDs
-- ============================================
UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id IN ('IS112', 'IS117', 'IS118')
LIMIT 3;
