use aphan437;
DROP TABLE IF EXISTS user_info;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS book_author;
DROP TABLE IF EXISTS read_book;


CREATE TABLE user_info (
email VARCHAR(30),
date_added DATE,
nickname VARCHAR(20),
profile VARCHAR(20)
) ENGINE InnoDB;

CREATE TABLE book (
book_id INT,
book_year INT,
num_raters INT,
rating DOUBLE
) ENGINE InnoDB;

CREATE TABLE author (
author_id INT,
last_name VARCHAR(40),
first_name VARCHAR(20) NOT NULL,
middle_name VARCHAR(20)
) ENGINE InnoDB;

CREATE TABLE book_author () ENGINE InnoDB;

CREATE TABLE read_book () ENGINE InnoDB;