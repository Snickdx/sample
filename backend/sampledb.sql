-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 06, 2017 at 12:49 AM
-- Server version: 5.7.17
-- PHP Version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `sampledb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `sampledb`;

# Privileges for `sample`@`%`

CREATE USER 'sample'@'localhost' IDENTIFIED BY 'sample';

GRANT USAGE ON *.* TO 'sample'@'%';

GRANT ALL PRIVILEGES ON `sampledb`.* TO 'sample'@'%';

GRANT ALL PRIVILEGES ON `sample\_%`.* TO 'sample'@'%';


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sampledb`
--

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `authorId` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `DOB` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `author`:
--

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`authorId`, `name`, `DOB`) VALUES
(1, 'Jk Rowling', '1978-02-08'),
(2, 'Ian Flemming', '1965-02-08'),
(3, 'Niccolò Machiavelli', '1469-05-03');

-- --------------------------------------------------------

--
-- Table structure for table `book`
--

CREATE TABLE `book` (
  `bookId` int(11) NOT NULL,
  `title` varchar(20) NOT NULL,
  `authorId` int(11) NOT NULL,
  `published` date NOT NULL,
  `borrowed` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `book`:
--   `authorId`
--       `author` -> `authorId`
--

--
-- Dumping data for table `book`
--

INSERT INTO `book` (`bookId`, `title`, `authorId`, `published`, `borrowed`) VALUES
(1, 'Harry Potter 1', 1, '2017-02-05', 0),
(2, 'Harry Potter 2', 1, '2016-12-13', 0),
(3, 'James Bond 1', 2, '2017-01-09', 0),
(4, 'The Prince', 3, '2016-12-21', 0),
(5, 'James Bond 2', 2, '2017-02-16', 0),
(6, 'Harry Potter 3', 1, '2017-02-01', 0),
(7, 'The Art of War', 3, '2017-02-01', 0);

-- --------------------------------------------------------

--
-- Table structure for table `bookreturn`
--

CREATE TABLE `bookreturn` (
  `returnId` int(11) NOT NULL,
  `bookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `loanId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `bookreturn`:
--   `bookId`
--       `book` -> `bookId`
--   `userId`
--       `user` -> `userId`
--   `loanId`
--       `loan` -> `loanId`
--

--
-- Dumping data for table `bookreturn`
--

INSERT INTO `bookreturn` (`returnId`, `bookId`, `userId`, `date`, `loanId`) VALUES
(1, 1, 1, '2017-02-05 19:14:25', 19),
(2, 2, 1, '2017-02-05 19:14:33', 20),
(3, 3, 1, '2017-02-05 19:37:57', 21),
(4, 5, 1, '2017-02-05 19:42:29', 22),
(5, 1, 1, '2017-02-05 19:46:47', 23);

--
-- Triggers `bookreturn`
--
DELIMITER $$
CREATE TRIGGER `UpdateStatusReturn` AFTER INSERT ON `bookreturn` FOR EACH ROW UPDATE book
     SET book.borrowed = 0
   WHERE book.bookId = NEW.bookId
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `bookstatus`
--
CREATE TABLE `bookstatus` (
`bookId` int(11)
,`published` date
,`title` varchar(20)
,`author` varchar(30)
,`borrowedBy` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `borrowedbooks`
--
CREATE TABLE `borrowedbooks` (
`loanId` int(11)
,`bookId` int(11)
,`title` varchar(20)
,`userId` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `loan`
--

CREATE TABLE `loan` (
  `loanId` int(11) NOT NULL,
  `bookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `loan`:
--   `userId`
--       `user` -> `userId`
--   `bookId`
--       `book` -> `bookId`
--

--
-- Dumping data for table `loan`
--

INSERT INTO `loan` (`loanId`, `bookId`, `userId`, `date`) VALUES
(19, 1, 1, '2017-02-05 19:08:29'),
(20, 2, 1, '2017-02-05 19:08:52'),
(21, 3, 1, '2017-02-05 19:08:58'),
(22, 5, 1, '2017-02-05 19:09:03'),
(23, 1, 1, '2017-02-05 19:46:42');

--
-- Triggers `loan`
--
DELIMITER $$
CREATE TRIGGER `UpdateStatus` AFTER INSERT ON `loan` FOR EACH ROW UPDATE book
     SET book.borrowed = 1
   WHERE book.bookId = NEW.bookId
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userId` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `user`:
--

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userId`, `username`, `password`) VALUES
(1, 'bob', '48181acd22b3edaebc8a447868a7df7ce629920a'),
(2, 'chris', '711c73f64afdce07b7e38039a96d2224209e9a6c');

-- --------------------------------------------------------

--
-- Structure for view `bookstatus` exported as a table
--
DROP TABLE IF EXISTS `bookstatus`;
CREATE TABLE`bookstatus`(
    `bookId` int(11) NOT NULL DEFAULT '0',
    `published` date NOT NULL,
    `title` varchar(20) COLLATE latin1_swedish_ci NOT NULL,
    `author` varchar(30) COLLATE latin1_swedish_ci DEFAULT NULL,
    `borrowedBy` int(11) DEFAULT NULL
);

-- --------------------------------------------------------

--
-- Structure for view `borrowedbooks` exported as a table
--
DROP TABLE IF EXISTS `borrowedbooks`;
CREATE TABLE`borrowedbooks`(
    `loanId` int(11) NOT NULL DEFAULT '0',
    `bookId` int(11) DEFAULT '0',
    `title` varchar(20) COLLATE latin1_swedish_ci DEFAULT NULL,
    `userId` int(11) NOT NULL
);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`authorId`);

--
-- Indexes for table `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`bookId`),
  ADD KEY `authorId` (`authorId`);

--
-- Indexes for table `bookreturn`
--
ALTER TABLE `bookreturn`
  ADD PRIMARY KEY (`returnId`),
  ADD KEY `bookId` (`bookId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `loanId` (`loanId`);

--
-- Indexes for table `loan`
--
ALTER TABLE `loan`
  ADD PRIMARY KEY (`loanId`),
  ADD KEY `bookId` (`bookId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `date` (`date`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `author`
--
ALTER TABLE `author`
  MODIFY `authorId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `book`
--
ALTER TABLE `book`
  MODIFY `bookId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `bookreturn`
--
ALTER TABLE `bookreturn`
  MODIFY `returnId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `loan`
--
ALTER TABLE `loan`
  MODIFY `loanId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `book_ibfk_1` FOREIGN KEY (`authorId`) REFERENCES `author` (`authorId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bookreturn`
--
ALTER TABLE `bookreturn`
  ADD CONSTRAINT `bookreturn_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `book` (`bookId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bookreturn_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bookreturn_ibfk_3` FOREIGN KEY (`loanId`) REFERENCES `loan` (`loanId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loan`
--
ALTER TABLE `loan`
  ADD CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `loan_ibfk_2` FOREIGN KEY (`bookId`) REFERENCES `book` (`bookId`) ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Metadata
--
USE `phpmyadmin`;

--
-- Metadata for author
--

--
-- Metadata for book
--

--
-- Metadata for bookreturn
--

--
-- Metadata for bookstatus
--

--
-- Metadata for borrowedbooks
--

--
-- Metadata for loan
--

--
-- Metadata for user
--

--
-- Metadata for sampledb
--

--
-- Dumping data for table `pma__bookmark`
--

INSERT INTO `pma__bookmark` (`dbase`, `user`, `label`, `query`) VALUES
('sampledb', 'root', 'bookStatus', 'SELECT `book`.`bookId`, `book`.`published`, `book`.`title`, `author`.`name` AS `author`, `borrowedbooks`.`userId` AS `borrowedBy`\r\nFROM `book`\r\nLEFT JOIN `borrowedbooks` ON `borrowedbooks`.`bookId` = `book`.`bookId`\r\nLEFT JOIN `author` ON author.authorId = book.authorId'),
('sampledb', 'root', 'outstandingBooks', 'SELECT *\r\nFROM loan\r\nLEFT JOIN bookreturn ON bookreturn.loanId = loan.loanId\r\nWHERE bookreturn.loanId is NULL'),
('sampledb', 'root', 'borrowedBooks', 'SELECT loan.loanId, book.bookId, book.title, loan.userId\r\nFROM loan\r\nLEFT JOIN book ON loan.bookId = book.bookId\r\nLEFT JOIN bookreturn ON bookreturn.loanId = loan.loanId\r\nWHERE bookreturn.loanId is NULL');

--
-- Dumping data for table `pma__relation`
--

INSERT INTO `pma__relation` (`master_db`, `master_table`, `master_field`, `foreign_db`, `foreign_table`, `foreign_field`) VALUES
('sampledb', 'bookReturn', 'bookId', 'sampledb', 'book', 'bookId'),
('sampledb', 'bookReturn', 'userId', 'sampledb', 'user', 'userId');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
