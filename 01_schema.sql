-- 01_schema.sql
-- Group: Asger Bergøe, Magnus, Sophus, Joel
-- This script safely recreates the database structure matching the Miro ERD.

CREATE DATABASE IF NOT EXISTS hotel_management;
USE hotel_management;

-- Disable foreign key checks to allow dropping tables with dependencies
-- SET FOREIGN_KEY_CHECKS = 0;

-- DROP TABLE IF EXISTS ROOM_CLEANING_ASSIGNMENT;
-- DROP TABLE IF EXISTS ROOM_CLEANING_TASK;
-- DROP TABLE IF EXISTS CLEANER;
-- DROP TABLE IF EXISTS BILL_ITEM;
-- DROP TABLE IF EXISTS EXTRA_SERVICE;
-- DROP TABLE IF EXISTS INVENTORY_ITEM;
-- DROP TABLE IF EXISTS BILL;
-- DROP TABLE IF EXISTS RESERVATION_GUEST;
-- DROP TABLE IF EXISTS RESERVATION;
-- DROP TABLE IF EXISTS GUEST;
-- DROP TABLE IF EXISTS ROOM;
-- DROP TABLE IF EXISTS SEASON_RATE;
-- DROP TABLE IF EXISTS ROOM_TYPE;

-- SET FOREIGN_KEY_CHECKS = 1;

-- 1. ROOM_TYPE
CREATE TABLE IF NOT EXISTS ROOM_TYPE (
                                         room_type_id INT AUTO_INCREMENT PRIMARY KEY,
                                         name VARCHAR(50) NOT NULL UNIQUE,
                                         max_occupancy INT NOT NULL
);

-- 2. SEASON_RATE
CREATE TABLE IF NOT EXISTS SEASON_RATE (
                                           rate_id INT AUTO_INCREMENT PRIMARY KEY,
                                           room_type_id INT NOT NULL,
                                           season VARCHAR(20) NOT NULL,
                                           price_per_night DECIMAL(10, 2) NOT NULL,
                                           valid_from DATE,
                                           valid_to DATE,
                                           FOREIGN KEY (room_type_id) REFERENCES ROOM_TYPE(room_type_id) ON DELETE CASCADE
);

-- 3. ROOM
CREATE TABLE IF NOT EXISTS ROOM (
                                    room_id INT AUTO_INCREMENT PRIMARY KEY,
                                    room_number VARCHAR(10) NOT NULL UNIQUE,
                                    room_type_id INT NOT NULL,
                                    room_status VARCHAR(20) DEFAULT 'Vacant',
                                    clean_status VARCHAR(20) DEFAULT 'Clean',
                                    FOREIGN KEY (room_type_id) REFERENCES ROOM_TYPE(room_type_id)
);

-- 4. GUEST
CREATE TABLE IF NOT EXISTS GUEST (
                                     guest_id INT AUTO_INCREMENT PRIMARY KEY,
                                     first_name VARCHAR(50) NOT NULL,
                                     last_name VARCHAR(50) NOT NULL,
                                     email VARCHAR(100) NOT NULL UNIQUE,
                                     phone VARCHAR(20),
                                     credit_card_last4 CHAR(4)
);

-- 5. RESERVATION
CREATE TABLE IF NOT EXISTS RESERVATION (
                                           reservation_id INT AUTO_INCREMENT PRIMARY KEY,
                                           reference_no VARCHAR(20) NOT NULL UNIQUE,
                                           check_in_date DATE NOT NULL,
                                           check_out_date DATE NOT NULL,
                                           nights INT,
                                           num_guests INT NOT NULL DEFAULT 1,
                                           room_type_id INT NOT NULL,
                                           assigned_room_id INT,
                                           booked_rate_id INT,
                                           booked_nightly_price DECIMAL(10, 2),
                                           status VARCHAR(20) DEFAULT 'Confirmed',
                                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                           FOREIGN KEY (room_type_id) REFERENCES ROOM_TYPE(room_type_id),
                                           FOREIGN KEY (assigned_room_id) REFERENCES ROOM(room_id)
);

-- 6. RESERVATION_GUEST
CREATE TABLE IF NOT EXISTS RESERVATION_GUEST (
                                                 reservation_id INT NOT NULL,
                                                 guest_id INT NOT NULL,
                                                 is_primary BOOLEAN DEFAULT FALSE,
                                                 PRIMARY KEY (reservation_id, guest_id),
                                                 FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id) ON DELETE CASCADE,
                                                 FOREIGN KEY (guest_id) REFERENCES GUEST(guest_id) ON DELETE CASCADE
);

-- 7. BILL
CREATE TABLE IF NOT EXISTS BILL (
                                    bill_id INT AUTO_INCREMENT PRIMARY KEY,
                                    reservation_id INT NOT NULL,
                                    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    closed_at TIMESTAMP NULL,
                                    total_amount DECIMAL(10, 2) DEFAULT 0.00,
                                    FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id)
);

-- 8. INVENTORY_ITEM
CREATE TABLE IF NOT EXISTS INVENTORY_ITEM (
                                              inventory_item_id INT AUTO_INCREMENT PRIMARY KEY,
                                              name VARCHAR(100) NOT NULL,
                                              unit_price DECIMAL(10, 2) NOT NULL,
                                              active BOOLEAN DEFAULT TRUE
);

-- 9. EXTRA_SERVICE
CREATE TABLE IF NOT EXISTS EXTRA_SERVICE (
                                             extra_service_id INT AUTO_INCREMENT PRIMARY KEY,
                                             name VARCHAR(100) NOT NULL,
                                             unit_price DECIMAL(10, 2) NOT NULL,
                                             price_unit VARCHAR(20),
                                             active BOOLEAN DEFAULT TRUE
);

-- 10. BILL_ITEM
CREATE TABLE IF NOT EXISTS BILL_ITEM (
                                         bill_item_id INT AUTO_INCREMENT PRIMARY KEY,
                                         bill_id INT NOT NULL,
                                         item_type VARCHAR(50),
                                         description VARCHAR(200),
                                         quantity INT DEFAULT 1,
                                         unit_price DECIMAL(10, 2) NOT NULL,
                                         line_total DECIMAL(10, 2) AS (quantity * unit_price) STORED,
                                         posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         FOREIGN KEY (bill_id) REFERENCES BILL(bill_id)
);

-- 11. CLEANER
CREATE TABLE IF NOT EXISTS CLEANER (
                                       cleaner_id INT AUTO_INCREMENT PRIMARY KEY,
                                       first_name VARCHAR(50) NOT NULL,
                                       last_name VARCHAR(50) NOT NULL,
                                       phone VARCHAR(20),
                                       active BOOLEAN DEFAULT TRUE
);

-- 12. ROOM_CLEANING_TASK
CREATE TABLE IF NOT EXISTS ROOM_CLEANING_TASK (
                                                  task_id INT AUTO_INCREMENT PRIMARY KEY,
                                                  room_id INT NOT NULL,
                                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                  task_status VARCHAR(20) DEFAULT 'Pending',
                                                  note VARCHAR(200),
                                                  FOREIGN KEY (room_id) REFERENCES ROOM(room_id)
);

-- 13. ROOM_CLEANING_ASSIGNMENT
CREATE TABLE IF NOT EXISTS ROOM_CLEANING_ASSIGNMENT (
                                                        task_id INT NOT NULL,
                                                        cleaner_id INT NOT NULL,
                                                        assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                        PRIMARY KEY (task_id, cleaner_id),
                                                        FOREIGN KEY (task_id) REFERENCES ROOM_CLEANING_TASK(task_id),
                                                        FOREIGN KEY (cleaner_id) REFERENCES CLEANER(cleaner_id)
);