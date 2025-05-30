-- Create the Database and Tables
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Create Books table
CREATE TABLE IF NOT EXISTS Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(255) NOT NULL,
    AUTHOR VARCHAR(255),
    GENRE VARCHAR(100),
    YEAR_PUBLISHED YEAR,
    AVAILABLE_COPIES INT DEFAULT 0
);

-- Create Members table
CREATE TABLE IF NOT EXISTS Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) UNIQUE,
    PHONE_NO VARCHAR(20),
    ADDRESS VARCHAR(255),
    MEMBERSHIP_DATE DATE
);

-- Create BorrowingRecords table
CREATE TABLE IF NOT EXISTS BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE NOT NULL,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

-- Step 2: Insert Sample Data
INSERT INTO Books (BOOK_ID, TITLE, AUTHOR, GENRE, YEAR_PUBLISHED, AVAILABLE_COPIES) VALUES
(1, 'Wings of Fire', 'A.P.J. Abdul Kalam', 'Autobiography', 1999, 4),
(2, 'The White Tiger', 'Aravind Adiga', 'Contemporary Fiction', 2008, 2),
(3, 'Gitanjali', 'Rabindranath Tagore', 'Poetry', 1910, 3),
(4, 'Midnight’s Children', 'Salman Rushdie', 'Magic Realism', 1981, 2),
(5, 'An Era of Darkness', 'Shashi Tharoor', 'Non-fiction', 2016, 5);

INSERT INTO Members (MEMBER_ID, NAME, EMAIL, PHONE_NO, ADDRESS, MEMBERSHIP_DATE) VALUES
(101, 'Alice Johnson', 'alice@example.com', '1234567890', '123 Maple St', '2023-01-10'),
(102, 'Bob Smith', 'bob@example.com', '2345678901', '456 Oak St', '2023-02-15'),
(103, 'Charlie Brown', 'charlie@example.com', '3456789012', '789 Pine St', '2023-03-20'),
(104, 'David Wilson', 'david@example.com', '4567890123', '321 Elm St', '2023-04-25');


INSERT INTO BorrowingRecords (BORROW_ID, MEMBER_ID, BOOK_ID, BORROW_DATE, RETURN_DATE) VALUES
(1001, 101, 1, '2023-04-01', NULL),
(1002, 101, 2, '2023-03-15', '2023-04-10'),
(1003, 102, 3, '2023-04-05', NULL),
(1004, 103, 4, '2023-02-20', '2023-03-22'),
(1005, 103, 5, '2023-04-10', NULL);

-- Information Retrieval Queries
-- a) Books currently borrowed by MEMBER_ID = 101
SELECT b.TITLE, b.AUTHOR, br.BORROW_DATE
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
WHERE br.MEMBER_ID = 101 AND br.RETURN_DATE IS NULL;

-- b) Members with overdue books (>30 days, not returned)
SELECT m.MEMBER_ID, m.NAME, br.BORROW_DATE
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
WHERE br.RETURN_DATE IS NULL AND br.BORROW_DATE < CURDATE() - INTERVAL 30 DAY;

-- c) Books by genre with available copy count
SELECT GENRE, TITLE, AVAILABLE_COPIES
FROM Books
ORDER BY GENRE, TITLE;

-- d) Most borrowed book(s)
SELECT b.TITLE, COUNT(*) AS borrow_count
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY br.BOOK_ID, b.TITLE
ORDER BY borrow_count DESC
LIMIT 1;

-- e) Members who borrowed books from at least 3 different genres
SELECT br.MEMBER_ID, m.NAME
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
GROUP BY br.MEMBER_ID, m.NAME
HAVING COUNT(DISTINCT b.GENRE) >= 3;

-- Reporting and Analytics

-- a) Total books borrowed per month
SELECT DATE_FORMAT(BORROW_DATE, '%Y-%m') AS borrow_month, COUNT(*) AS total_borrowed
FROM BorrowingRecords
GROUP BY borrow_month
ORDER BY borrow_month;

-- b) Top 3 most active members
SELECT m.MEMBER_ID, m.NAME, COUNT(*) AS borrow_count
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
GROUP BY m.MEMBER_ID, m.NAME
ORDER BY borrow_count DESC
LIMIT 3;

-- c) Authors with books borrowed at least 10 times
SELECT b.AUTHOR, COUNT(*) AS borrow_count
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY b.AUTHOR
HAVING borrow_count >= 10;

-- d) Members who have never borrowed a book
SELECT m.MEMBER_ID, m.NAME
FROM Members m
LEFT JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
WHERE br.BORROW_ID IS NULL;



















