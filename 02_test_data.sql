-- 02_test_data.sql
-- Group: Asger, Magnus, Sophus, Joel

USE hotel_management;

-- 1. Populate Room Types
INSERT INTO ROOM_TYPE (name, max_occupancy) VALUES
                                                ('Loft', 2),
                                                ('XL Loft', 4),
                                                ('Presidential Suite', 6),
                                                ('Love Suite💖', 2);

-- 2. Populate Seasonal Rates (The 16 rates from your brainstorming)
-- Loft
INSERT INTO SEASON_RATE (room_type_id, season, price_per_night) VALUES
                                                                    (1, 'Summer', 1000.00), (1, 'Autumn', 1200.00), (1, 'Winter', 899.00), (1, 'Spring', 1100.00),
-- XL Loft
                                                                    (2, 'Summer', 2000.00), (2, 'Autumn', 1800.00), (2, 'Winter', 1200.00), (2, 'Spring', 1700.00),
-- Presidential Suite
                                                                    (3, 'Summer', 5000.00), (3, 'Autumn', 5200.00), (3, 'Winter', 4899.00), (3, 'Spring', 5100.00),
-- Love Suite
                                                                    (4, 'Summer', 6000.00), (4, 'Autumn', 7200.00), (4, 'Winter', 5899.00), (4, 'Spring', 7100.00);

-- 3. Populate Rooms (Sample set)
INSERT INTO ROOM (room_number, room_type_id, room_status, clean_status) VALUES
                                                                            ('101', 1, 'Vacant', 'Clean'),
                                                                            ('102', 1, 'Occupied', 'Dirty'),
                                                                            ('201', 2, 'Vacant', 'Inspected'),
                                                                            ('301', 3, 'Vacant', 'Clean'),
                                                                            ('401', 4, 'Occupied', 'Dirty');

-- 4. Populate Inventory Items (Minibar)
INSERT INTO INVENTORY_ITEM (name, unit_price) VALUES
                                                  ('Water', 20.00),
                                                  ('Icecoffee', 40.00),
                                                  ('Vodka', 150.00),
                                                  ('Tequila', 140.00),
                                                  ('Jaegermeister', 130.00),
                                                  ('Redbull', 50.00);

-- 5. Populate Initial Guests
INSERT INTO GUEST (first_name, last_name, email, phone, credit_card_last4) VALUES
                                                                               ('John', 'Doe', 'john.doe@example.com', '+45 12345678', '1234'),
                                                                               ('Jane', 'Smith', 'jane.smith@example.com', '+45 87654321', '5678');

-- 6. Create Sample Reservations
INSERT INTO RESERVATION (reference_number, guest_id, room_id, check_in_date, check_out_date, num_guests, status) VALUES
                                                                                                                     ('RES-001', 1, 2, '2024-06-01', '2024-06-05', 2, 'Checked In'),
                                                                                                                     ('RES-002', 2, 5, '2024-12-20', '2024-12-27', 2, 'Confirmed');

-- 7. Populate Sample Bills and Bill Items (Simulating the 99 DKK breakfast and 100 DKK check-in)
INSERT INTO BILL (reservation_id, total_amount, is_paid) VALUES (1, 399.00, FALSE);

INSERT INTO BILL_ITEM (bill_id, description, quantity, amount) VALUES
                                                                   (1, 'Early Check-in', 1, 100.00),
                                                                   (1, 'Breakfast Included', 3, 99.00), -- 99 DKK per day
                                                                   (1, 'Vodka (Minibar)', 1, 150.00);