-- 03_logic.sql
-- Group: Asger Bergøe, Magnus, Sophus, Joel
-- This script contains the programmable objects for automation and optimization.

USE hotel_management;

-- 1. STORED FUNCTION: GetRoomRate
-- Purpose: Automates looking up the DKK price for a specific room type and season.
-- This is used so you don't have to hardcode prices in your application.
DROP FUNCTION IF EXISTS fn_GetRoomRate;
DELIMITER //
CREATE FUNCTION fn_GetRoomRate(p_room_type_id INT, p_season VARCHAR(20))
    RETURNS DECIMAL(10,2)
    DETERMINISTIC
BEGIN
    DECLARE r_price DECIMAL(10,2);
    SELECT price_per_night INTO r_price
    FROM SEASON_RATE
    WHERE room_type_id = p_room_type_id AND season = p_season;
    RETURN IFNULL(r_price, 0.00);
END //
DELIMITER ;

-- 2. STORED PROCEDURE: CalculateFinalBill
-- Purpose: A "one-click" command to generate a total invoice.
-- It fetches the booked price, calculates stay length, and sums all minibar/service items.
DROP PROCEDURE IF EXISTS sp_CalculateFinalBill;
DELIMITER //
CREATE PROCEDURE sp_CalculateFinalBill(IN p_reservation_id INT)
BEGIN
    DECLARE v_room_charge DECIMAL(10,2) DEFAULT 0;
    DECLARE v_extras_total DECIMAL(10,2) DEFAULT 0;

    -- Calculate base room charge: (nights * booked_nightly_price)
    SELECT (nights * booked_nightly_price) INTO v_room_charge
    FROM RESERVATION
    WHERE reservation_id = p_reservation_id;

    -- Sum all items in BILL_ITEM using the line_total generated column
    SELECT SUM(bi.line_total) INTO v_extras_total
    FROM BILL_ITEM bi
             JOIN BILL b ON bi.bill_id = b.bill_id
    WHERE b.reservation_id = p_reservation_id;

    -- Update the main BILL table
    UPDATE BILL
    SET total_amount = IFNULL(v_room_charge, 0) + IFNULL(v_extras_total, 0)
    WHERE reservation_id = p_reservation_id;

    -- Display the final result
    SELECT b.bill_id, r.reference_no, b.total_amount AS 'Total Bill DKK'
    FROM BILL b
             JOIN RESERVATION r ON b.reservation_id = r.reservation_id
    WHERE b.reservation_id = p_reservation_id;
END //
DELIMITER ;

-- 3. TRIGGER: AfterCheckout
-- Purpose: Real-time automation. As soon as a guest is marked 'Checked Out',
-- the room is automatically flagged for the cleaning staff.
DROP TRIGGER IF EXISTS tr_AfterCheckout;
DELIMITER //
CREATE TRIGGER tr_AfterCheckout
    AFTER UPDATE ON RESERVATION
    FOR EACH ROW
BEGIN
    -- If the status changes to 'Checked Out', update the room
    IF NEW.status = 'Checked Out' THEN
        UPDATE ROOM SET
                        clean_status = 'Dirty',
                        room_status = 'Vacant'
        WHERE room_id = NEW.assigned_room_id;

        -- Logic Bonus: Create a cleaning task automatically
        INSERT INTO ROOM_CLEANING_TASK (room_id, task_status, note)
        VALUES (NEW.assigned_room_id, 'Pending', 'Automatic task: Guest checked out');
    END IF;
END //
DELIMITER ;

-- 4. VIEW: HousekeepingList
-- Purpose: Security and Simplicity. It hides the complexity of joins
-- so cleaning staff only see the specific info they need.
CREATE OR REPLACE VIEW vw_HousekeepingList AS
SELECT
    r.room_number,
    rt.name AS room_type,
    r.clean_status,
    t.task_status,
    t.note
FROM ROOM r
         JOIN ROOM_TYPE rt ON r.room_type_id = rt.room_type_id
         LEFT JOIN ROOM_CLEANING_TASK t ON r.room_id = t.room_id
WHERE r.clean_status != 'Clean' OR t.task_status = 'Pending'
ORDER BY r.clean_status DESC;

-- 5. INDEX: Performance Optimization
-- Purpose: Speeds up the "Check-in" process. Without this, the database
-- has to scan every single row to find a reference number.
CREATE INDEX idx_ref_no ON RESERVATION(reference_no);
CREATE INDEX idx_res_status ON RESERVATION(status);