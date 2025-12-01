-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 01, 2025 at 01:15 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pwrs_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `admin_id` int(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`admin_id`, `username`, `password`, `name`, `role`) VALUES
(1, 'coord1', '$2y$10$G1ATbiyoQRlJ4lGVVtQ9QeooqrJA5lRktDoR3AZejCsj7dyPkzjmG', 'Program Coordinator', 'coordinator'),
(2, 'officer1', '$2y$10$711pT8Mq3cQaHltfTAA2I.jQ/m9sLYJNVkznDHYXfEmkQK3sqx0kS', 'Program Officer', 'officer');

-- --------------------------------------------------------

--
-- Table structure for table `campaigns`
--

CREATE TABLE `campaigns` (
  `camp_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `target` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','completed') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `campaigns`
--

INSERT INTO `campaigns` (`camp_id`, `title`, `description`, `image`, `target`, `created_at`, `status`) VALUES
(1, 'Shelter', 'Help displaced people find safe, sustainable shelter.', 'uploads/campaigns/RF1394943.webp', 500000.00, '2025-11-17 23:36:37', 'active'),
(2, 'Education', 'Our kids, our future. Your contribution will create new opportunities for learning.', 'uploads/campaigns/image770x420cropped.jpg', 600000.00, '2025-11-18 15:06:37', 'active'),
(3, 'Water', 'Your little contribution makes a big different, help thousands of families to have clean water.', 'uploads/campaigns/RF1394943.webp', 600000.00, '2025-11-20 15:36:29', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `cases`
--

CREATE TABLE `cases` (
  `case_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `title` varchar(150) NOT NULL,
  `state` varchar(150) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `category` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `reject_reason` text DEFAULT NULL,
  `target` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cases`
--

INSERT INTO `cases` (`case_id`, `user_id`, `title`, `state`, `address`, `phone`, `category`, `description`, `image`, `status`, `reject_reason`, `target`) VALUES
(1, 1, 'Building Damaged by Fire', 'Khartoum', 'Bahri', '+249112184225', 'Reconstruction', 'We need help to reconstruct this building.', 'uploads/1762374529_33.png', 'Approved', NULL, 600000.00),
(2, 1, 'School Books for Grade 8', 'Khartoum', 'Africa street', '00249112174259', 'Education', 'I need books for my daughter.', '', 'Rejected', 'Please provide specific address', 0.00),
(3, 1, 'Tent', 'North Darfur', 'Darfur', '0112760448', 'Shelter', 'I lost my house.', '', 'Approved', NULL, 27000.00),
(4, 2, 'Malaria medicine', 'Gezira', 'Gezira', '0112907307', 'Medical Aid', 'can\'t find medicine for malaria.', '', 'Approved', NULL, 5000.00),
(5, 2, 'Water', 'Khartoum', 'Khartoum', '0112587003', 'Food Support', 'Lack clean water.', '', 'Pending', NULL, 0.00),
(6, 3, 'Kids Clothes', 'Khartoum', 'Gabra', '0112186538', 'Food Support', 'Test text.', '', 'Approved', NULL, 30000.00),
(7, 3, 'Food', 'Gezira', 'Gezira', '0112679336', 'Food Support', 'Test text.', '', 'Pending', NULL, 0.00),
(8, 3, 'A place to stay in', 'Gezira', 'Gezira', '0112569834', 'Shelter', 'test text.', '', 'Pending', NULL, 0.00),
(9, 1, 'School Reconstruction', 'Khartoum', 'Bahri', '0112572448', 'Reconstruction', 'Test text.', '', 'Approved', NULL, 500000.00),
(10, 1, 'Street Reconstruction', 'Khartoum', 'Khartoum', '0112542856', 'Reconstruction', 'Test text', '', 'Rejected', 'Incomplete Information', 0.00),
(11, 3, 'Building Materials', 'Khartoum', 'Bahri', '0112346447', 'Reconstruction', 'Test text.', '', 'Pending', NULL, 0.00),
(12, 3, 'Insuline for Diabetes', 'Gezira', 'Gezira', '0112363772', 'Medical Aid', 'Test text.', '', 'Pending', NULL, 0.00),
(13, 1, 'Grains', 'North Darfur', 'Darfur', '0112458996', 'Food Support', 'Test text.', '', 'Pending', NULL, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `donations`
--

CREATE TABLE `donations` (
  `donation_id` int(10) NOT NULL,
  `user_id` int(10) DEFAULT NULL,
  `case_id` int(10) DEFAULT NULL,
  `camp_id` int(10) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `transfer_date` date NOT NULL,
  `receipt` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `reject_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donations`
--

INSERT INTO `donations` (`donation_id`, `user_id`, `case_id`, `camp_id`, `amount`, `transaction_id`, `transfer_date`, `receipt`, `status`, `reject_reason`) VALUES
(1, 1, 1, NULL, 1000.00, 2147483647, '2025-11-14', 'uploads/receipts/1763083565_36.jpg', 'Approved', NULL),
(2, 2, 3, NULL, 1500.00, 1234567891, '2025-11-18', 'uploads/receipts/1763482771_36.jpg', 'Approved', NULL),
(3, 1, NULL, 1, 10500.00, 1234567891, '2025-11-19', 'uploads/receipts/1763562690_36.jpg', 'Pending', NULL),
(4, 1, NULL, 1, 20000.00, 1234567891, '2025-11-19', 'uploads/receipts/1763563354_36.jpg', 'Pending', NULL),
(5, 1, NULL, 1, 7500.00, 1234567891, '2025-11-19', 'uploads/receipts/1763563790_36.jpg', 'Rejected', 'Incorrect Transaction ID'),
(6, 1, NULL, 2, 9000.00, 1234567891, '2025-11-19', 'uploads/receipts/1763570259_36.jpg', 'Approved', NULL),
(7, 2, NULL, 1, 6700.00, 2147483647, '2025-11-19', 'uploads/receipts/1763571383_36.jpg', 'Approved', NULL),
(8, 2, NULL, 1, 25000.00, 2147483647, '2025-11-19', 'uploads/receipts/1763571942_36.jpg', 'Pending', NULL),
(9, 2, NULL, 1, 20000.00, 2147483647, '2025-11-20', 'uploads/receipts/1763652419_36.jpg', 'Rejected', 'Transaction ID Incorrect.'),
(10, 1, 1, NULL, 32000.00, 2147483647, '2025-11-20', 'uploads/receipts/1763655948_36.jpg', 'Approved', NULL),
(11, 3, NULL, 3, 30000.00, 2147483647, '2025-11-20', 'uploads/receipts/1763675024_36.jpg', 'Approved', NULL),
(12, 3, 4, NULL, 1200.00, 2147483647, '2025-11-21', 'uploads/receipts/1763679869_36.jpg', 'Approved', NULL),
(13, 3, NULL, 1, 8000.00, 2147483647, '2025-11-21', 'uploads/receipts/1763684584_36.jpg', 'Pending', NULL),
(14, 3, 1, NULL, 40000.00, 2147483647, '2025-11-21', 'uploads/receipts/1763684655_36.jpg', 'Pending', NULL),
(15, 1, 4, NULL, 3800.00, 1023456789, '2025-11-21', 'uploads/receipts/1763744104_36.jpg', 'Approved', NULL),
(16, 1, NULL, 2, 4600.00, 1234567823, '2025-11-24', 'uploads/receipts/1764432608_36.jpg', 'Pending', NULL),
(17, 1, 6, NULL, 34000.00, 1023456782, '2025-11-24', 'uploads/receipts/1764432683_36.jpg', 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `location` varchar(100) NOT NULL,
  `status` enum('open','closed') NOT NULL DEFAULT 'open',
  `allowed_areas` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `title`, `description`, `date`, `location`, `status`, `allowed_areas`) VALUES
(1, 'Community Clean-Up Day', 'Join our volunteer team to help clean public areas and support a healthier environment for everyone.', '2025-11-17', 'Kafouri Block 11', 'open', 'Bahri'),
(2, 'Food Pack Distribution', 'Help prepare and distribute food packs to families.', '2025-11-18', 'Jabra Block 19', 'open', 'Khartoum'),
(3, 'Entertainment Program', 'Join our entertainment program for kids.', '2025-11-19', 'Bahri', 'open', 'Bahri');

-- --------------------------------------------------------

--
-- Table structure for table `event_registrations`
--

CREATE TABLE `event_registrations` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `volunteer_id` int(11) NOT NULL,
  `registration_date` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_registrations`
--

INSERT INTO `event_registrations` (`id`, `event_id`, `volunteer_id`, `registration_date`, `status`) VALUES
(1, 1, 1, '2025-11-26 22:03:49', ''),
(2, 1, 2, '2025-11-26 22:06:08', 'rejected'),
(3, 2, 3, '2025-11-29 11:35:35', 'rejected'),
(4, 2, 4, '2025-11-29 11:36:02', ''),
(5, 2, 5, '2025-11-29 11:36:13', ''),
(6, 1, 6, '2025-11-30 03:29:33', ''),
(7, 1, 7, '2025-11-30 03:29:39', ''),
(8, 1, 8, '2025-11-30 03:31:20', ''),
(9, 1, 9, '2025-11-30 03:32:29', ''),
(10, 1, 10, '2025-11-30 03:34:28', ''),
(11, 2, 11, '2025-11-30 08:08:50', ''),
(12, 2, 12, '2025-11-30 08:10:14', ''),
(13, 1, 13, '2025-11-30 08:42:56', ''),
(14, 2, 14, '2025-11-30 09:01:23', 'rejected'),
(15, 2, 15, '2025-11-30 09:01:38', ''),
(16, 3, 16, '2025-11-30 23:46:58', ''),
(17, 3, 17, '2025-11-30 23:49:30', 'rejected'),
(18, 3, 18, '2025-11-30 23:57:34', 'rejected');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `case_id` int(10) DEFAULT NULL,
  `donation_id` int(10) DEFAULT NULL,
  `comment` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `join_again` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `user_id`, `case_id`, `donation_id`, `comment`, `created_at`, `join_again`) VALUES
(1, 2, 2, 2, 'Great.', '2025-11-30 02:53:27', 'Yes'),
(5, 3, NULL, NULL, 'Great events.', '2025-12-01 03:22:33', 'Yes'),
(6, 3, NULL, NULL, 'Great events.', '2025-12-01 03:22:49', 'Yes');

-- --------------------------------------------------------

--
-- Table structure for table `progress_updates`
--

CREATE TABLE `progress_updates` (
  `update_id` int(10) NOT NULL,
  `case_id` int(10) NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `progress_updates`
--

INSERT INTO `progress_updates` (`update_id`, `case_id`, `description`, `date`) VALUES
(1, 1, 'Donations for this case confirmed', '2025-11-15'),
(2, 1, 'Basic building materials purchased', '2025-11-15'),
(3, 1, 'Work has begun on the damaged site.', '2025-11-17'),
(4, 3, 'Donations for this case have been confirmed.', '2025-11-17');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `birthdate` date NOT NULL,
  `affected` tinyint(1) NOT NULL DEFAULT 0,
  `donor` tinyint(1) NOT NULL DEFAULT 0,
  `volunteer` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `user_email`, `password`, `gender`, `birthdate`, `affected`, `donor`, `volunteer`) VALUES
(1, 'Wesal Makki', 'wesalmakki@gmail.com', '$2y$10$ylViV0jCtN2sJ9CHyPoweOiUvghEu15wujgLHRRRBATaQ8gKRYWy2', 'Female', '2002-11-15', 1, 1, 0),
(2, 'Aya Tarig', 'ayatarig@gmail.com', '$2y$10$lmGpl30aXuVbu.ycSA0h1eEkJEejJaPSJhyIB3Kt6CQIRxHtQplYi', 'Female', '2002-09-06', 1, 1, 0),
(3, 'Heba Idriss', 'hebamakki@gmail.com', '$2y$10$LM6qRkBYBRCSHOSyz4/8A.0hYtIuq27IXkOP0tRqQSagNsKJaHKlG', 'Female', '1999-06-09', 1, 1, 0),
(4, 'Sara Ali', 'saraali@gmail.com', '$2y$10$jxY2a86h0ujbg4j6xN1IAO0KrQeqeXmaaJD.OtHXYbnyCpJHWV1Xq', 'Female', '2000-01-01', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `volunteers`
--

CREATE TABLE `volunteers` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `area` varchar(255) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `volunteered_before` tinyint(1) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `volunteers`
--

INSERT INTO `volunteers` (`id`, `full_name`, `phone`, `area`, `gender`, `volunteered_before`, `email`) VALUES
(1, 'Aya Tarig', '0112458664', 'Bahri', 'Female', 0, 'ayatarig@gmail.com'),
(2, 'Aya Tarig', '0112458664', 'Omdurman', 'Female', 0, 'ayatarig@gmail.com'),
(3, 'Aya Tarig', '0112436625', 'Bahri', 'Female', 0, 'ayatarig@gmail.com'),
(4, 'Aya Tarig', '0112436625', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(5, 'Aya Tarig', '0112436625', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(6, 'Aya Tarig', '0112452775', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(7, 'Aya Tarig', '0112452775', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(8, 'Aya Tarig', '0112452775', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(9, 'Aya Tarig', '0112452775', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(10, 'Aya Tarig', '0112452775', 'Omdurman', 'Female', 0, 'ayatarig@gmail.com'),
(11, 'Aya Tarig', '0112436775', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(12, 'Aya Tarig', '0112436775', 'Bahri', 'Female', 0, 'ayatarig@gmail.com'),
(13, 'Wesal Makki', '011346773', 'Omdurman', 'Female', 0, 'wesalmakki@gmail.com'),
(14, 'Wesal Makki', '0112346774', 'Bahri', 'Female', 0, 'wesalmakki@gmail.com'),
(15, 'Wesal Makki', '0112346774', 'Khartoum', 'Female', 0, 'wesalmakki@gmail.com'),
(16, 'Wesal Makki', '0112453778', 'Bahri', 'Female', 0, 'wesalmakki@gmail.com'),
(17, 'Aya Tarig', '0112453478', 'Khartoum', 'Female', 0, 'ayatarig@gmail.com'),
(18, 'Heba Makki', '0112453476', 'Omdurman', 'Female', 0, 'hebamakki@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `campaigns`
--
ALTER TABLE `campaigns`
  ADD PRIMARY KEY (`camp_id`);

--
-- Indexes for table `cases`
--
ALTER TABLE `cases`
  ADD PRIMARY KEY (`case_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `donations`
--
ALTER TABLE `donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `case_id` (`case_id`),
  ADD KEY `camp_id` (`camp_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `event_registrations`
--
ALTER TABLE `event_registrations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `volunteer_id` (`volunteer_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `case_id` (`case_id`),
  ADD KEY `donation_id` (`donation_id`);

--
-- Indexes for table `progress_updates`
--
ALTER TABLE `progress_updates`
  ADD PRIMARY KEY (`update_id`),
  ADD KEY `case_id` (`case_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- Indexes for table `volunteers`
--
ALTER TABLE `volunteers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `admin_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `campaigns`
--
ALTER TABLE `campaigns`
  MODIFY `camp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cases`
--
ALTER TABLE `cases`
  MODIFY `case_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `donations`
--
ALTER TABLE `donations`
  MODIFY `donation_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `event_registrations`
--
ALTER TABLE `event_registrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `progress_updates`
--
ALTER TABLE `progress_updates`
  MODIFY `update_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `volunteers`
--
ALTER TABLE `volunteers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cases`
--
ALTER TABLE `cases`
  ADD CONSTRAINT `cases_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `donations`
--
ALTER TABLE `donations`
  ADD CONSTRAINT `donations_ibfk_1` FOREIGN KEY (`camp_id`) REFERENCES `campaigns` (`camp_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donations_case` FOREIGN KEY (`case_id`) REFERENCES `cases` (`case_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donations_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `event_registrations`
--
ALTER TABLE `event_registrations`
  ADD CONSTRAINT `event_registrations_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `event_registrations_ibfk_2` FOREIGN KEY (`volunteer_id`) REFERENCES `volunteers` (`id`);

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`case_id`) REFERENCES `cases` (`case_id`),
  ADD CONSTRAINT `feedback_ibfk_3` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`donation_id`);

--
-- Constraints for table `progress_updates`
--
ALTER TABLE `progress_updates`
  ADD CONSTRAINT `progress_updates_ibfk_1` FOREIGN KEY (`case_id`) REFERENCES `cases` (`case_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
