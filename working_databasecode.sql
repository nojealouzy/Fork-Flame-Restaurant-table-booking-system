CREATE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    name        VARCHAR2(100),
    phone       VARCHAR2(15),
    email       VARCHAR2(100)
);


CREATE TABLE Tables (
    table_id     NUMBER PRIMARY KEY,
    table_number VARCHAR2(10) UNIQUE,
    capacity     NUMBER,
    location     VARCHAR2(50)
);


CREATE TABLE TimeSlots (
    time_slot_id NUMBER PRIMARY KEY,
    slot_label   VARCHAR2(20)  -- e.g., "6PM–7PM"
);


CREATE TABLE BookingStatus (
    status_id   NUMBER PRIMARY KEY,
    status_name VARCHAR2(20)  -- e.g., "Confirmed", "Pending"
);


CREATE TABLE Bookings (
    booking_id     NUMBER PRIMARY KEY,
    customer_id    NUMBER,
    table_id       NUMBER,
    booking_date   DATE,
    time_slot_id   NUMBER,
    status_id      NUMBER,
    created_at     DATE DEFAULT SYSDATE,

    CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_booking_table    FOREIGN KEY (table_id) REFERENCES Tables(table_id),
    CONSTRAINT fk_booking_slot     FOREIGN KEY (time_slot_id) REFERENCES TimeSlots(time_slot_id),
    CONSTRAINT fk_booking_status   FOREIGN KEY (status_id) REFERENCES BookingStatus(status_id)
);


CREATE TABLE BookingAuditLog (
    log_id      NUMBER PRIMARY KEY,
    booking_id  NUMBER,
    action      VARCHAR2(20),   -- INSERT, UPDATE, DELETE
    action_time DATE DEFAULT SYSDATE,
    user_note   VARCHAR2(100),

    CONSTRAINT fk_audit_booking FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);


-- sequences --

CREATE SEQUENCE customer_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE table_seq
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE SEQUENCE timeslot_seq
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE SEQUENCE status_seq
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE SEQUENCE booking_seq
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE SEQUENCE auditlog_seq
START WITH 1
INCREMENT BY 1
NOCACHE;









-- Inserting data --

INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Alice Johnson', '647-555-1234', 'alice@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Bob Smith', '647-555-5678', 'bob@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Charlie Brown', '647-555-2468', 'charlie@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Diana Prince', '647-555-8765', 'diana@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Ethan Hunt', '647-555-1357', 'ethan@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Fiona Gallagher', '647-555-9753', 'fiona@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'George Martin', '647-555-7531', 'george@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Hannah Baker', '647-555-1597', 'hannah@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Ivan Lee', '647-555-1122', 'ivan@example.com');
INSERT INTO Customers (customer_id, name, phone, email) VALUES (customer_seq.NEXTVAL, 'Jasmine Patel', '647-555-3344', 'jasmine@example.com');


-- Normalize phone numbers to 10-digit format (remove dashes, spaces, brackets)
UPDATE Customers
SET phone = REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', '');

COMMIT;

-- Tables data inserting --

INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T1', 2, 'Indoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T2', 4, 'Indoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T3', 6, 'Outdoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T4', 2, 'Indoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T5', 4, 'Patio');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T6', 4, 'Indoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T7', 6, 'Patio');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T8', 2, 'Outdoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T9', 4, 'Indoor');
INSERT INTO Tables (table_id, table_number, capacity, location) VALUES (table_seq.NEXTVAL, 'T10', 6, 'VIP Room');


-- Timeslots data inserting --

INSERT INTO TimeSlots (time_slot_id, slot_label) VALUES (timeslot_seq.NEXTVAL, '12:00 PM - 1:00 PM');
INSERT INTO TimeSlots (time_slot_id, slot_label) VALUES (timeslot_seq.NEXTVAL, '1:00 PM - 2:00 PM');
INSERT INTO TimeSlots (time_slot_id, slot_label) VALUES (timeslot_seq.NEXTVAL, '6:00 PM - 7:00 PM');
INSERT INTO TimeSlots (time_slot_id, slot_label) VALUES (timeslot_seq.NEXTVAL, '7:00 PM - 8:00 PM');
INSERT INTO TimeSlots (time_slot_id, slot_label) VALUES (timeslot_seq.NEXTVAL, '8:00 PM - 9:00 PM');



-- Booking status --

INSERT INTO BookingStatus (status_id, status_name) VALUES (status_seq.NEXTVAL, 'Pending');
INSERT INTO BookingStatus (status_id, status_name) VALUES (status_seq.NEXTVAL, 'Confirmed');
INSERT INTO BookingStatus (status_id, status_name) VALUES (status_seq.NEXTVAL, 'Cancelled');
INSERT INTO BookingStatus (status_id, status_name) VALUES (status_seq.NEXTVAL, 'Completed');
INSERT INTO BookingStatus (status_id, status_name) VALUES (status_seq.NEXTVAL, 'No Show');


-- Bookings data inserting --

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 1, 2, TO_DATE('2025-07-20', 'YYYY-MM-DD'), 1, 2);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 2, 5, TO_DATE('2025-07-20', 'YYYY-MM-DD'), 2, 2);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 3, 1, TO_DATE('2025-07-21', 'YYYY-MM-DD'), 3, 1);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 4, 6, TO_DATE('2025-07-22', 'YYYY-MM-DD'), 1, 2);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 5, 3, TO_DATE('2025-07-23', 'YYYY-MM-DD'), 4, 1);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 6, 7, TO_DATE('2025-07-24', 'YYYY-MM-DD'), 5, 2);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 7, 8, TO_DATE('2025-07-24', 'YYYY-MM-DD'), 3, 2);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 8, 4, TO_DATE('2025-07-25', 'YYYY-MM-DD'), 2, 1);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 9, 9, TO_DATE('2025-07-26', 'YYYY-MM-DD'), 4, 3);

INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
VALUES (booking_seq.NEXTVAL, 10, 10, TO_DATE('2025-07-27', 'YYYY-MM-DD'), 5, 4);


-- creating 2 indexes --

-- Index to speed up customer name search
CREATE INDEX idx_customers_name ON Customers(name);

-- Index to speed up booking date search
CREATE INDEX idx_bookings_date ON Bookings(booking_date);



-- creating triggers --

CREATE OR REPLACE TRIGGER trg_log_booking_insert
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
  INSERT INTO BookingAuditLog (log_id, booking_id, action, action_time, user_note)
  VALUES (
    auditlog_seq.NEXTVAL,
    :NEW.booking_id,
    'INSERT',
    SYSDATE,
    'New booking created.'
  );
END;
/



-- second trigger to prevent the double booking of the same table --

CREATE OR REPLACE TRIGGER trg_prevent_double_booking
BEFORE INSERT ON Bookings
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM Bookings
  WHERE table_id = :NEW.table_id
    AND booking_date = :NEW.booking_date
    AND time_slot_id = :NEW.time_slot_id
    AND status_id IN (1, 2); -- Pending or Confirmed

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Table already booked for the selected time slot.');
  END IF;
END;
/



-- Procedures --

CREATE OR REPLACE PROCEDURE make_booking (
  p_customer_id   IN NUMBER,
  p_table_id      IN NUMBER,
  p_booking_date  IN DATE,
  p_time_slot_id  IN NUMBER,
  p_status_id     IN NUMBER
)
IS
  v_booking_id NUMBER;
BEGIN
  -- Generate booking ID
  v_booking_id := booking_seq.NEXTVAL;

  -- Insert booking
  INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
  VALUES (v_booking_id, p_customer_id, p_table_id, p_booking_date, p_time_slot_id, p_status_id);

  DBMS_OUTPUT.PUT_LINE('Booking successfully created with ID: ' || v_booking_id);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in make_booking: ' || SQLERRM);
END;
/


-- second procedure --

CREATE OR REPLACE PROCEDURE cancel_all_bookings_by_customer (
  p_customer_id IN NUMBER
)
IS
  CURSOR booking_cur IS
    SELECT booking_id
    FROM Bookings
    WHERE customer_id = p_customer_id AND status_id IN (1, 2); -- Pending or Confirmed

  v_booking_id Bookings.booking_id%TYPE;
BEGIN
  OPEN booking_cur;
  LOOP
    FETCH booking_cur INTO v_booking_id;
    EXIT WHEN booking_cur%NOTFOUND;

    UPDATE Bookings
    SET status_id = 3  -- Cancelled
    WHERE booking_id = v_booking_id;

    DBMS_OUTPUT.PUT_LINE('Booking ' || v_booking_id || ' cancelled.');
  END LOOP;
  CLOSE booking_cur;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in cancel_all_bookings_by_customer: ' || SQLERRM);
END;
/




-- testing calls --


-- Make a booking
BEGIN
  make_booking(1, 2, TO_DATE('2025-07-30', 'YYYY-MM-DD'), 1, 1);  -- Pending
END;
/

-- Cancel all bookings by customer 1
BEGIN
  cancel_all_bookings_by_customer(1);
END;
/



-- creating functions --

CREATE OR REPLACE FUNCTION get_customer_booking_count (
  p_customer_id IN NUMBER
) RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM Bookings
  WHERE customer_id = p_customer_id;

  RETURN v_count;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in get_customer_booking_count: ' || SQLERRM);
    RETURN -1;
END;
/


-- testing the function --

BEGIN
  DBMS_OUTPUT.PUT_LINE('Customer 1 Booking Count: ' || get_customer_booking_count(1));
END;
/


-- creating second function --

CREATE OR REPLACE FUNCTION is_table_available (
  p_table_id      IN NUMBER,
  p_booking_date  IN DATE,
  p_time_slot_id  IN NUMBER
) RETURN VARCHAR2
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM Bookings
  WHERE table_id = p_table_id
    AND booking_date = p_booking_date
    AND time_slot_id = p_time_slot_id
    AND status_id IN (1, 2);  -- Pending or Confirmed

  IF v_count = 0 THEN
    RETURN 'Available';
  ELSE
    RETURN 'Not Available';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in is_table_available: ' || SQLERRM);
    RETURN 'Error';
END;
/



-- testing second function --

BEGIN
  DBMS_OUTPUT.PUT_LINE('Table Availability: ' || is_table_available(2, TO_DATE('2025-07-30', 'YYYY-MM-DD'), 1));
END;
/



-- creating package specification (headers) --

CREATE OR REPLACE PACKAGE booking_pkg AS
  -- Global variable
  g_last_booking_id NUMBER;

  -- Procedures
  PROCEDURE make_booking (
    p_customer_id   IN NUMBER,
    p_table_id      IN NUMBER,
    p_booking_date  IN DATE,
    p_time_slot_id  IN NUMBER,
    p_status_id     IN NUMBER
  );

  PROCEDURE cancel_all_bookings_by_customer (
    p_customer_id IN NUMBER
  );

  -- Functions
  FUNCTION get_customer_booking_count (
    p_customer_id IN NUMBER
  ) RETURN NUMBER;

  FUNCTION is_table_available (
    p_table_id      IN NUMBER,
    p_booking_date  IN DATE,
    p_time_slot_id  IN NUMBER
  ) RETURN VARCHAR2;
END booking_pkg;
/



-- creating package body (implementation) --

CREATE OR REPLACE PACKAGE BODY booking_pkg AS

  -- Procedure: make_booking
  PROCEDURE make_booking (
    p_customer_id   IN NUMBER,
    p_table_id      IN NUMBER,
    p_booking_date  IN DATE,
    p_time_slot_id  IN NUMBER,
    p_status_id     IN NUMBER
  )
  IS
  BEGIN
    g_last_booking_id := booking_seq.NEXTVAL;

    INSERT INTO Bookings (booking_id, customer_id, table_id, booking_date, time_slot_id, status_id)
    VALUES (g_last_booking_id, p_customer_id, p_table_id, p_booking_date, p_time_slot_id, p_status_id);

    DBMS_OUTPUT.PUT_LINE('Booking created with ID: ' || g_last_booking_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in make_booking: ' || SQLERRM);
  END;

  -- Procedure: cancel_all_bookings_by_customer
  PROCEDURE cancel_all_bookings_by_customer (
    p_customer_id IN NUMBER
  )
  IS
    CURSOR booking_cur IS
      SELECT booking_id FROM Bookings
      WHERE customer_id = p_customer_id AND status_id IN (1, 2);

    v_booking_id Bookings.booking_id%TYPE;
  BEGIN
    OPEN booking_cur;
    LOOP
      FETCH booking_cur INTO v_booking_id;
      EXIT WHEN booking_cur%NOTFOUND;

      UPDATE Bookings
      SET status_id = 3
      WHERE booking_id = v_booking_id;

      DBMS_OUTPUT.PUT_LINE('Cancelled booking ID: ' || v_booking_id);
    END LOOP;
    CLOSE booking_cur;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in cancel_all_bookings_by_customer: ' || SQLERRM);
  END;

  -- Function: get_customer_booking_count
  FUNCTION get_customer_booking_count (
    p_customer_id IN NUMBER
  ) RETURN NUMBER
  IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Bookings WHERE customer_id = p_customer_id;
    RETURN v_count;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in get_customer_booking_count: ' || SQLERRM);
      RETURN -1;
  END;

  -- Function: is_table_available
  FUNCTION is_table_available (
    p_table_id      IN NUMBER,
    p_booking_date  IN DATE,
    p_time_slot_id  IN NUMBER
  ) RETURN VARCHAR2
  IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Bookings
    WHERE table_id = p_table_id
      AND booking_date = p_booking_date
      AND time_slot_id = p_time_slot_id
      AND status_id IN (1, 2);

    IF v_count = 0 THEN
      RETURN 'Available';
    ELSE
      RETURN 'Not Available';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in is_table_available: ' || SQLERRM);
      RETURN 'Error';
  END;

END booking_pkg;
/





-- for testing purposes --
select * from bookings;

-- shows sepcific customer details based on the date and time and table id of that customer
  
  SELECT
    c.customer_id,
    c.name,
    c.phone,
    b.booking_id,
    b.table_id,
    b.booking_date,
    ts.slot_label
FROM
    bookings b
JOIN
    customers c ON b.customer_id = c.customer_id
JOIN
    timeslots ts ON b.time_slot_id = ts.time_slot_id
WHERE
    b.table_id = 1
    AND b.booking_date = TO_DATE('2025-08-15', 'YYYY-MM-DD')
    AND b.time_slot_id = (
        SELECT time_slot_id
        FROM timeslots
        WHERE slot_label = '1:00 PM - 2:00 PM'
    );

  
  -- only shows the active current bookings --
  SELECT * FROM bookings
WHERE status_id IN (1, 2);  -- Pending or Confirmed

  -- only shows the deleted bookings --
 SELECT 
    b.booking_id,
    c.customer_id,
    c.name AS customer_name,
    c.phone,
    b.booking_date,
    ts.slot_label AS time_slot,
    t.table_number,
    s.status_name
FROM 
    bookings b
JOIN customers c ON b.customer_id = c.customer_id
JOIN timeslots ts ON b.time_slot_id = ts.time_slot_id
JOIN tables t ON b.table_id = t.table_id
JOIN bookingstatus s ON b.status_id = s.status_id
WHERE 
    b.status_id = 3  -- Cancelled
ORDER BY b.booking_date DESC;

  select * from BOOKINGS;





-- =====================================================
--              TESTING SCRIPTS FOR DEMONSTRATION
-- =====================================================
SET SERVEROUTPUT ON;

-- 1️⃣ Trigger: trg_log_booking_insert
BEGIN
  make_booking(3, 9, TO_DATE('2025-08-01', 'YYYY-MM-DD'), 2, 2); -- Confirmed
END;
/

SELECT * FROM BookingAuditLog WHERE action = 'INSERT' ORDER BY action_time DESC;

-- 2️⃣ Trigger: trg_prevent_double_booking
BEGIN
  make_booking(4, 9, TO_DATE('2025-08-01', 'YYYY-MM-DD'), 2, 2);  -- Should raise error
END;
/

-- 3️⃣ Procedure: make_booking
BEGIN
  make_booking(5, 4, TO_DATE('2025-08-02', 'YYYY-MM-DD'), 3, 1);  -- Pending
END;
/

SELECT * FROM bookings WHERE customer_id = 5 ORDER BY created_at DESC;

-- 4️⃣ Procedure: cancel_all_bookings_by_customer
BEGIN
  cancel_all_bookings_by_customer(5);
END;
/

SELECT booking_id, status_id FROM bookings WHERE customer_id = 5;

-- 5️⃣ Function: get_customer_booking_count
BEGIN
  DBMS_OUTPUT.PUT_LINE('Customer 3 booking count: ' || get_customer_booking_count(3));
END;
/

-- 6️⃣ Function: is_table_available
BEGIN
  DBMS_OUTPUT.PUT_LINE('Table availability: ' || is_table_available(4, TO_DATE('2025-08-02', 'YYYY-MM-DD'), 3));
END;
/

-- 7️⃣ Package: booking_pkg.make_booking
BEGIN
  booking_pkg.make_booking(6, 6, TO_DATE('2025-08-03', 'YYYY-MM-DD'), 1, 2);  -- Confirmed
END;
/

SELECT * FROM bookings WHERE customer_id = 6 ORDER BY created_at DESC;

-- 8️⃣ Package: booking_pkg.cancel_all_bookings_by_customer
BEGIN
  booking_pkg.cancel_all_bookings_by_customer(6);
END;
/

SELECT booking_id, status_id FROM bookings WHERE customer_id = 6;

-- 9️⃣ Package: booking_pkg.get_customer_booking_count
BEGIN
  DBMS_OUTPUT.PUT_LINE('Package: Booking count for customer 2 = ' || booking_pkg.get_customer_booking_count(2));
END;
/

-- 🔟 Package: booking_pkg.is_table_available
BEGIN
  DBMS_OUTPUT.PUT_LINE('Package: Table availability = ' ||
    booking_pkg.is_table_available(7, TO_DATE('2025-08-04', 'YYYY-MM-DD'), 5));
END;
/

-- Bonus: View BookingAuditLog
SELECT * FROM BookingAuditLog ORDER BY action_time DESC;

select * from tables;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Customer 2 has ' || booking_pkg.get_customer_booking_count(2) || ' bookings');
END;

