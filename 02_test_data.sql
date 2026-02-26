-- 02_test_data.sql
-- Group: Asger Bergøe, Magnus, Sophus, Joel
-- Populate the 13 tables with realistic data from brainstorming.

USE hotel_management;

-- 1. Room Types (INSERT IGNORE prevents duplicates)
INSERT IGNORE INTO ROOM_TYPE (room_type_id, name, max_occupancy) VALUES
(1, 'Loft', 2),
(2, 'XL Loft', 4),
(3, 'Presidential Suite', 6),
(4, 'Love Suite💖', 2);

-- 2. Seasonal Rates
INSERT IGNORE INTO SEASON_RATE (room_type_id, season, price_per_night, valid_from, valid_to) VALUES
(1, 'Summer', 1000.00, '2026-06-01', '2026-08-31'), (1, 'Autumn', 1200.00, '2026-09-01', '2026-11-30'),
(1, 'Winter', 899.00, '2026-12-01', '2027-02-28'), (1, 'Spring', 1100.00, '2026-03-01', '2026-05-31'),
(2, 'Summer', 2000.00, '2026-06-01', '2026-08-31'), (2, 'Autumn', 1800.00, '2026-09-01', '2026-11-30'),
(2, 'Winter', 1200.00, '2026-12-01', '2027-02-28'), (2, 'Spring', 1700.00, '2026-03-01', '2026-05-31'),
(3, 'Summer', 5000.00, '2026-06-01', '2026-08-31'), (3, 'Autumn', 5200.00, '2026-09-01', '2026-11-30'),
(3, 'Winter', 4899.00, '2026-12-01', '2027-02-28'), (3, 'Spring', 5100.00, '2026-03-01', '2026-05-31'),
(4, 'Summer', 6000.00, '2026-06-01', '2026-08-31'), (4, 'Autumn', 7200.00, '2026-09-01', '2026-11-30'),
(4, 'Winter', 5899.00, '2026-12-01', '2027-02-28'), (4, 'Spring', 7100.00, '2026-03-01', '2026-05-31');

-- 3. Rooms
INSERT IGNORE INTO ROOM (room_id, room_number, room_type_id, room_status, clean_status) VALUES
(1, '101', 1, 'Vacant', 'Clean'),
(2, '102', 1, 'Occupied', 'Dirty'),
(3, '201', 2, 'Vacant', 'Inspected'),
(4, '301', 3, 'Vacant', 'Clean'),
(5, '401', 4, 'Occupied', 'Dirty');

-- 4. Inventory (Minibar)
INSERT IGNORE INTO INVENTORY_ITEM (inventory_item_id, name, unit_price) VALUES
(1, 'Water', 20.00), (2, 'Icecoffee', 40.00), (3, 'Vodka', 150.00),
(4, 'Tequila', 140.00), (5, 'Jaegermeister', 130.00), (6, 'Redbull', 50.00);

-- 5. Extra Services
INSERT IGNORE INTO EXTRA_SERVICE (extra_service_id, name, unit_price, price_unit) VALUES
(1, 'Early Check-in', 100.00, 'One-time'),
(2, 'Late Checkout', 150.00, 'One-time'),
(3, 'Breakfast', 99.00, 'Per Person/Day');

-- 6. Guests
INSERT IGNORE INTO GUEST (guest_id, first_name, last_name, email, phone, credit_card_last4) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '+45 12345678', '1234'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '+45 87654321', '5678');

-- 7. Reservations (Matching the 13-table schema columns)
INSERT IGNORE INTO RESERVATION (reservation_id, reference_no, check_in_date, check_out_date, nights, room_type_id, assigned_room_id, status) VALUES
(1, 'RES-001', '2026-06-01', '2026-06-05', 4, 1, 2, 'Checked In'),
(2, 'RES-002', '2026-12-20', '2026-12-27', 7, 4, 5, 'Confirmed');

-- 8. Junction Table: Link Guests to Reservations
INSERT IGNORE INTO RESERVATION_GUEST (reservation_id, guest_id, is_primary) VALUES
(1, 1, TRUE), -- John is the main guest for Res 1
(2, 2, TRUE); -- Jane is the main guest for Res 2

-- 9. Bills
INSERT IGNORE INTO BILL (bill_id, reservation_id, total_amount, is_paid) VALUES
(1, 1, 399.00, FALSE);

-- 10. Bill Items (line_total is automatic in schema 01)
INSERT IGNORE INTO BILL_ITEM (bill_id, item_type, description, quantity, unit_price) VALUES
(1, 'Service', 'Early Check-in', 1, 100.00),
(1, 'Service', 'Breakfast Included', 3, 99.00),
(1, 'Inventory', 'Vodka (Minibar)', 1, 150.00);

-- 11. Staff (Cleaners)
INSERT IGNORE INTO CLEANER (cleaner_id, first_name, last_name, phone) VALUES
(1, 'Anders', 'Andersen', '555-1001'),
(2, 'Bente', 'Bentild', '555-1002');

-- 12. Cleaning Tasks
INSERT IGNORE INTO ROOM_CLEANING_TASK (task_id, room_id, task_status, note) VALUES
(1, 2, 'Pending', 'Guest checked out late'),
(2, 5, 'In Progress', 'Vomit in the Love Suite💖');

-- 13. Staff Assignments
INSERT IGNORE INTO ROOM_CLEANING_ASSIGNMENT (task_id, cleaner_id) VALUES
(1, 1),
(2, 2);