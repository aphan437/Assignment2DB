use jbret088;
DROP TABLE IF EXISTS USER;
DROP TABLE IF EXISTS BOOK;
DROP TABLE IF EXISTS AUTHOR;
DROP TABLE IF EXISTS BOOKAUTHOR;
DROP TABLE IF EXISTS READBOOK;


CREATE TABLE USER (
    email VARCHAR(30) PRIMARY KEY,
    date_added DATE,
    nickname VARCHAR(20),
    profile VARCHAR(20)
) ENGINE InnoDB;

CREATE TABLE BOOK (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    book_year INT,
    num_raters INT DEFAULT 0, 
    rating DECIMAL(2,1)
) ENGINE InnoDB;

CREATE TABLE AUTHOR (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(40),
    first_name VARCHAR(20) NOT NULL,  
    middle_name VARCHAR(20)
) ENGINE InnoDB;


CREATE TABLE BOOKAUTHOR (
    author_id   INT,
    book_id     INT,
    PRIMARY KEY (author_id, book_id),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id)
) ENGINE InnoDB;

CREATE TABLE READBOOK (
    book_id     INT,
    email       VARCHAR(30),
    date_read   DATE,
    rating      INT,
    PRIMARY KEY (book_id, email),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id),
    FOREIGN KEY (email) REFERENCES USER(email)
) ENGINE InnoDB;

INSERT INTO USER (email, date_added, nickname, profile) VALUES
('alice@mail.com', '2023-01-01', 'Alice', 'Reader'),
('bob@mail.com', '2023-01-02', 'Bob', 'Enthusiast'),
('carol@mail.com', '2023-01-03', 'Carol', 'Novice'),
('dave@mail.com', '2023-01-04', 'Dave', 'Scholar'),
('eve@mail.com', '2023-01-05', 'Eve', 'Critic'),
('frank@mail.com', '2023-01-06', 'Frank', 'Collector'),
('grace@mail.com', '2023-01-07', 'Grace', 'Librarian'),
('heidi@mail.com', '2023-01-08', 'Heidi', 'Historian'),
('ivan@mail.com', '2023-01-09', 'Ivan', 'Student'),
('judy@mail.com', '2023-01-10', 'Judy', 'Professor');

INSERT INTO BOOK (book_year, num_raters, rating) VALUES
(2001, 0, 0.0),
(2002, 0, 0.0),
(2003, 0, 0.0),
(2004, 0, 0.0),
(2005, 0, 0.0),
(2006, 0, 0.0),
(2007, 0, 0.0),
(2008, 0, 0.0),
(2009, 0, 0.0),
(2010, 0, 0.0);

INSERT INTO AUTHOR (last_name, first_name, middle_name) VALUES
('Smith', 'John', NULL),
('Johnson', 'Jane', 'Doe'),
('Williams', 'Gary', NULL),
('Brown', 'Lisa', 'Marie'),
('Jones', 'Chris', NULL),
('Garcia', 'Maria', NULL),
('Miller', 'David', 'Lee'),
('Davis', 'Angela', NULL),
('Rodriguez', 'Jose', NULL),
('Martinez', 'Patricia', 'Ann'),
('Hernandez', 'Luis', NULL);

INSERT INTO BOOKAUTHOR (author_id, book_id) VALUES
(1, 1),
(2, 2), 
(3, 3), 
(4, 4),
(5, 5), 
(6, 6),
(7, 7), 
(8, 8), 
(9, 9),
(10, 10), 
(11, 8);

INSERT INTO READBOOK (book_id, email, date_read, rating) VALUES
(1, 'alice@mail.com', '2023-03-01', 8),
(2, 'bob@mail.com', '2023-03-02', 7),
(3, 'carol@mail.com', '2023-03-03', 9),
(4, 'dave@mail.com', '2023-03-04', 6),
(5, 'eve@mail.com', '2023-03-05', 10),
(6, 'frank@mail.com', '2023-03-06', 5),
(7, 'grace@mail.com', '2023-03-07', 8),
(8, 'heidi@mail.com', '2023-03-08', 9),
(9, 'ivan@mail.com', '2023-03-09', 7),
(10, 'judy@mail.com', '2023-03-10', 6);


/* ------ After inserting a READBOOK entry, update BOOK table rating ------ */
DELIMITER $$
CREATE TRIGGER after_readbook_insert
AFTER INSERT ON READBOOK
FOR EACH ROW
BEGIN
    UPDATE BOOK
    SET num_raters = num_raters + 1,
        rating = (rating * num_raters + NEW.rating) / (num_raters + 1)
    WHERE book_id = NEW.book_id;
END $$
DELIMITER ;


/* ------ After deleting a READBOOK entry, update BOOK table rating back to default ------ */
DELIMITER $$
CREATE TRIGGER after_readbook_delete
AFTER DELETE ON READBOOK
FOR EACH ROW
BEGIN
    UPDATE BOOK
    SET num_raters = num_raters - 1,
        rating = (rating * (num_raters + 1) - OLD.rating) / num_raters
    WHERE book_id = OLD.book_id AND num_raters > 0;
END $$
DELIMITER ;

/* ------ create an index for faster lookups of READBOOK by date_read ------ */
CREATE INDEX idx_date_read ON READBOOK(date_read);

/* ------ create a view for easy access of the list of books with their average rating and number of raters ------ */
CREATE VIEW BookDetails AS
SELECT b.book_id, b.book_year, b.num_raters, b.rating
FROM BOOK b;
