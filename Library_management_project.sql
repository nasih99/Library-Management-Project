-- Library Management system project 2

CREATE DATABASE LM_project;
USE LM_project;

-- Creating branch table

CREATE TABLE branch 
(
			branch_id VARCHAR(10) PRIMARY KEY,
			manager_id VARCHAR(15),
			branch_address VARCHAR(25),
			contact_no VARCHAR(15)
	);
    
CREATE TABLE employees
(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),
	position VARCHAR(15),
	salary INT,
	branch_id VARCHAR(15)
);



CREATE TABLE books(
	isbn VARCHAR(30) PRIMARY KEY,
	book_title VARCHAR(100),
	category VARCHAR(20),
	rental_price FLOAT,
	status VARCHAR(10),	author VARCHAR(50),
	publisher VARCHAR(70)

);


CREATE TABLE members(
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(30),
	member_address VARCHAR(50),
	reg_date DATE

);


CREATE TABLE issued_status(
	issued_id VARCHAR(20) PRIMARY KEY,
	issued_member_id VARCHAR(10),
	issued_book_name VARCHAR(100),
	issued_date DATE,
	issued_book_isbn VARCHAR(30),
	issued_emp_id VARCHAR(10)

);


CREATE TABLE return_status(
	return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(10),
	return_book_name VARCHAR(100),
	return_date DATE,
	return_book_isbn VARCHAR(30)

);


-- FOREIGN KEY

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY(issued_member_id)
REFERENCES members(member_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY(issued_book_isbn)
REFERENCES books(isbn);


ALTER TABLE issued_status
ADD CONSTRAINT fk_embloyees
FOREIGN KEY(issued_emp_id)
REFERENCES employees(emp_id);


ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY(branch_id)
REFERENCES branch(branch_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY(issued_id)
REFERENCES issued_status(issued_id);


SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM employees;


-- Project Task 

-- CRUD Operatation

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main st'
WHERE  member_id = 'C101';



-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status 
WHERE issued_id = 'IS121';



-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM employees
WHERE emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
	issued_emp_id,
	COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;


-- CTAS(Creat Table As Select)

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**


CREATE TABLE book_issued_cnt
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issued_cnt;


-- Data Analysis and Findings

-- Task 7. Retrieve All Books 'Classic' Category.alter

SELECT * FROM books
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category.

SELECT
	b.category,
	SUM(b.rental_price) AS total_rental_price,
	COUNT(*) AS count
FROM books AS b
JOIN 
issued_status AS ist 
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;


-- Task 9: List Members Who Registered in the Last 180 Days.


SELECT *
FROM members
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;

INSERT INTO
	members(member_id, member_name, member_address, reg_date)
VALUES
	('C117', 'sam', '278 North st', '2025-10-20'),
    ('C127', 'guruji', '788 South st', '2025-10-19'),
    ('C126', 'john', '288 West st', '2025-10-22');

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT
	e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees AS e1
JOIN 
branch AS b
ON b.branch_id = e1.branch_id
JOIN 
employees AS e2
ON e2.emp_id = b.manager_id;


-- Task 11: Create a Table of Books with Rental Price Above 7 USD.


CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7;

SELECT * FROM expensive_books;


-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT DISTINCT ist.issued_book_name
FROM issued_status AS ist
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;




-- Advanced SQL Problems


/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.*/


SELECT
	m.member_id,
    m.member_name,
    b.book_title,
    ist.issued_date,
    CURRENT_DATE - issued_date AS over_dues_days
FROM issued_status AS ist
JOIN
members AS m 
ON m.member_id = ist.issued_member_id
JOIN 
books AS b
ON b.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rst
ON rst.issued_id = ist.issued_id
WHERE 
	rst.return_date IS NULL 
    AND 
    (CURRENT_DATE - issued_date) > 30
ORDER BY 1




/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).*/

DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(15),
    IN p_book_quality VARCHAR(50)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(50);

    -- Insert into return status 
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- Get book details
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;

    -- Show confirmation message
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
END $$

DELIMITER ;

CALL add_return_records('RS138', 'IS135', 'Good');
CALL add_return_records('RS102', 'IS140', 'Damaged');
CALL add_return_records('RS103', 'IS142', 'Good');
CALL add_return_records('RS104', 'IS150', 'Average');
CALL add_return_records('RS105', 'IS155', 'Excellent');


/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued,
the number of books returned, and the total revenue generated from book rentals.*/


CREATE TABLE branch_report AS 
SELECT 
	b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rst.return_id) AS number_book_returned,
    SUM(bk.rental_price) AS total_rental_revenue
FROM issued_status AS ist
JOIN employees AS e
	ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
	ON b.branch_id = e.branch_id
LEFT JOIN return_status AS rst
	ON rst.issued_id = ist.issued_id
JOIN books AS bk
	ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id,b.manager_id;

SELECT * FROM branch_report;


/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members
containing members who have issued at least one book in the last 2 months.*/


CREATE TABLE active_members AS
SELECT * FROM members 
WHERE member_id IN (
					SELECT DISTINCT issued_member_id 
					FROM issued_status 
					WHERE issued_date >= CURRENT_DATE - INTERVAL 2 MONTH 
);

SELECT * FROM active_members;

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.*/

SELECT 
	e.emp_name,
    b.branch_id,
    b.branch_address,
    COUNT(ist.issued_id) AS number_book_issued 
FROM issued_status AS ist 
JOIN employees AS e
	ON e.emp_id = ist.issued_emp_id
JOIN branch AS b 
	ON b.branch_id = e.branch_id 
GROUP BY e.emp_name, b.branch_id, b.branch_address
ORDER BY number_book_issued DESC
LIMIT 3;



/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table.
Display the member name, book title, and the number of times they've issued damaged books.*/
 
 
 SELECT
	m.member_name,
    bk.book_title,
    COUNT(*) AS count_damaged_book_title
FROM issued_status as ist 
JOIN members AS m
	ON m.member_id = ist.issued_member_id
JOIN books AS bk
	ON bk.isbn = ist.issued_book_isbn
JOIN return_status as rs
	ON rs.issued_id = ist.issued_id
WHERE rs.book_quality = 'Damaged'
GROUP BY m.member_name, bk.book_title
HAVING COUNT(*) > 0;

    
 
/*Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes').
 If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_memb*/
    


DELIMITER $$

CREATE PROCEDURE issue_book(
	IN p_issued_book VARCHAR(20),
    IN p_issued_member_id VARCHAR(30),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)

BEGIN 
	DECLARE v_status VARCHAR(10);
    
    
    -- check if the book is available 
    
    SELECT status INTO v_status 
    FROM books 
    WHERE isbn = p_issued_book_isbn;
    
    IF v_status = 'yes' THEN 
		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES(p_issued_book, p_issued_member_id, CURRENT_DATE(), p_issued_book_isbn, p_issued_emp_id);
        
        -- update book status into no 
        
		UPDATE books 
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;
        
        SELECT CONCAT('Book record added successfully for book ISBN: ', p_issued_book_isbn) AS message;
	ELSE 
		SELECT CONCAT('Sorry, the requested book is unavailable. ISBN: ', p_issued_book_isbn) AS message;
        
	END IF;

END$$

DELIMITER ;
 
CALL issue_book('IS200', 'C105', '978-0-553-29698-2', 'E102');
CALL issue_book('IS202', 'C101', '978-0-307-58837-1', 'E101');
CALL issue_book('IS201', 'C110', '978-0-375-41398-8', 'E103');

     

-- End of Project 

    
    
