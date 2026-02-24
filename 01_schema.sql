-- 01_schema.sql
-- Hotel Management System - Group: Asger, Magnus, Sophus, Joel

CREATE DATABASE IF NOT EXISTS hotel_management;
USE hotel_management;

-- 1. ROOM_TYPE (Loft, XL Loft, etc.)
CREATE TABLE ROOM_TYPE (
                           type_id INT AUTO_INCREMENT PRIMARY KEY,
                           name VARCHAR(50) NOT NULL UNIQUE,
                           max_occupancy INT NOT NULL
);

-- 2. SEASON_RATE (Handles the specific DKK pricing from your list)
CREATE TABLE SEASON_RATE (
                             rate_id INT AUTO_INCREMENT PRIMARY KEY,
                             room_type_id INT NOT NULL,
                             season ENUM('Spring', 'Summer', 'Autumn', 'Winter') NOT NULL,
                             price_per_night DECIMAL(10, 2) NOT NULL,
                             FOREIGN KEY (room_type_id) REFERENCES ROOM_TYPE(type_id) ON DELETE CASCADE
);

-- 3. ROOM (Physical rooms and their statuses)
CREATE TABLE ROOM (
                      room_id INT AUTO_INCREMENT PRIMARY KEY,
                      room_number VARCHAR(10) NOT NULL UNIQUE,
                      room_type_id INT NOT NULL,
                      room_status ENUM('Vacant', 'Occupied') DEFAULT 'Vacant',
                      clean_status ENUM('Clean', 'Dirty', 'Inspected') DEFAULT 'Clean',
                      FOREIGN KEY (room_type_id) REFERENCES ROOM_TYPE(type_id)
);

-- 4. GUEST (Personal info and CC last 4 digits)
CREATE TABLE GUEST (
                       guest_id INT AUTO_INCREMENT PRIMARY KEY,
                       first_name VARCHAR(50) NOT NULL,
                       last_name VARCHAR(50) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       phone VARCHAR(20),
                       credit_card_last4 CHAR(4),
    -- Index for faster querying by email as per assignment goals
                       INDEX idx_guest_email (email)
);

-- 5. RESERVATION (The central hub)
CREATE TABLE RESERVATION (
                             reservation_id INT AUTO_INCREMENT PRIMARY KEY,
                             reference_number VARCHAR(20) NOT NULL UNIQUE,
                             guest_id INT NOT NULL,
                             room_id INT NOT NULL,
                             check_in_date DATE NOT NULL,
                             check_out_date DATE NOT NULL,
                             num_guests INT NOT NULL DEFAULT 1,
                             status ENUM('Confirmed', 'Checked In', 'Checked Out', 'Cancelled') DEFAULT 'Confirmed',
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (guest_id) REFERENCES GUEST(guest_id),
                             FOREIGN KEY (room_id) REFERENCES ROOM(room_id),
    -- Check constraint to ensure check-out is after check-in
                             CONSTRAINT chk_dates CHECK (check_out_date > check_in_date)
);

-- 6. INVENTORY_ITEM (Minibar prices: Vodka, Water, etc.)
CREATE TABLE INVENTORY_ITEM (
                                item_id INT AUTO_INCREMENT PRIMARY KEY,
                                name VARCHAR(100) NOT NULL,
                                unit_price DECIMAL(10, 2) NOT NULL
);

-- 7. BILL (Total charges per reservation)
CREATE TABLE BILL (
                      bill_id INT AUTO_INCREMENT PRIMARY KEY,
                      reservation_id INT NOT NULL,
                      total_amount DECIMAL(10, 2) DEFAULT 0.00,
                      is_paid BOOLEAN DEFAULT FALSE,
                      FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id)
);

-- 8. BILL_ITEM (Line items for early check-in, breakfast, minibar)
CREATE TABLE BILL_ITEM (
                           bill_item_id INT AUTO_INCREMENT PRIMARY KEY,
                           bill_id INT NOT NULL,
                           description VARCHAR(255) NOT NULL,
                           quantity INT DEFAULT 1,
                           amount DECIMAL(10, 2) NOT NULL,
                           FOREIGN KEY (bill_id) REFERENCES BILL(bill_id)
);