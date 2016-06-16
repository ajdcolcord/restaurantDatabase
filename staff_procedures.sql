USE restaurantDB;

-- #### VIEW PROCEDURES ##########################################
-- View all staff of the given restaurant id  ---------------
DROP PROCEDURE IF EXISTS view_restaurant_staff;
DELIMITER $$
CREATE PROCEDURE 
	view_restaurant_staff(IN in_restaurant_id INT)
BEGIN
	START TRANSACTION;
	SELECT SSN, staff_name, s.address, phone_number, salary, start_date, role
    FROM staff s
    JOIN restaurants r
    ON s.restaurant_id = r.restaurant_id
    WHERE s.restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL view_restaurant_staff(1);

-- ------------------------------------------------------------









-- #### ADD PROCEDURES ##########################################
-- Add a staff member to the restaurant  ---------------
DROP PROCEDURE IF EXISTS add_staff;
DELIMITER $$
CREATE PROCEDURE 
	add_staff(
		IN in_SSN INT(9),
        IN in_restaurant_id INT,
        IN in_staff_name VARCHAR(50),
        IN in_address VARCHAR(100),
        IN in_phone_number INT(11),
        IN in_salary FLOAT(8, 2),
        IN in_role VARCHAR(50)
	)
BEGIN
	START TRANSACTION;
	INSERT INTO staff (SSN, restaurant_id, staff_name, address, phone_number, salary, role)
	VALUES (
		in_SSN, 
		in_restaurant_id, 
		in_staff_name, 
		in_address, 
		in_phone_number, 
		in_salary, 
		in_role
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_staff(191900542, 1, 'Jake Bob', '100 Pleasant Street', 1999990129, 12000.62, 'bus');

-- ------------------------------------------------------------


-- Add an owner to the restaurant  ---------------
DROP PROCEDURE IF EXISTS add_owner;
DELIMITER $$
CREATE PROCEDURE 
	add_owner(
		IN in_SSN INT(9),
        IN in_restaurant_id INT
	)
BEGIN
	START TRANSACTION;
	INSERT INTO owns (owner_ssn, restaurant_id)
	VALUES (
		in_SSN, 
		in_restaurant_id
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_owner(823461541, 1);

-- ------------------------------------------------------------

-- Add a manager to the restaurant  ---------------
DROP PROCEDURE IF EXISTS add_manager;
DELIMITER $$
CREATE PROCEDURE 
	add_manager(
		IN in_manager_SSN INT(9),
        IN in_employee_SSN INT(9)
	)
BEGIN
	START TRANSACTION;
	INSERT INTO manages (manager_ssn, employee_ssn)
	VALUES (
		in_manager_SSN, 
		in_employee_SSN
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_manager(823461541, 943467846);

-- ------------------------------------------------------------




-- #### REMOVE PROCEDURES ##########################################
-- Remove a staff member from the restaurant  ---------------
DROP PROCEDURE IF EXISTS remove_staff;
DELIMITER $$
CREATE PROCEDURE 
	remove_staff(IN in_SSN INT(9), IN in_restaurant_id INT)
BEGIN
	START TRANSACTION;
	DELETE 
    FROM staff
    WHERE SSN = in_SSN
    AND restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_staff(823920541, 1);
-- ------------------------------------------------------------

-- Remove a manager from all relationships  ---------------
DROP PROCEDURE IF EXISTS remove_manager;
DELIMITER $$
CREATE PROCEDURE 
	remove_manager(IN in_SSN INT(9))
BEGIN
	START TRANSACTION;
	DELETE 
    FROM manages
    WHERE manager_ssn = in_SSN;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_manager(823461541);
-- ------------------------------------------------------------

-- Remove a manager to employee relationship  ---------------
DROP PROCEDURE IF EXISTS remove_manager_to_employee;
DELIMITER $$
CREATE PROCEDURE 
	remove_manager_to_employee(IN in_manager_ssn INT(9), IN in_employee_ssn INT(9))
BEGIN
	START TRANSACTION;
	DELETE 
    FROM manages
    WHERE manager_ssn = in_manager_ssn
    AND employee_ssn = in_employee_ssn;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_manager_to_employee(823461541, 191900542);
-- ------------------------------------------------------------







-- #### UPDATE PROCEDURES ##########################################
-- Update a staff member's address   ---------------------
DROP PROCEDURE IF EXISTS update_staff_address;
DELIMITER $$
CREATE PROCEDURE 
	update_staff_address(IN in_SSN INT(9), IN in_address VARCHAR(100))
BEGIN
	START TRANSACTION;
	UPDATE staff 
	SET address = in_address
	WHERE SSN = in_SSN;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_staff_address(091010541, "900 North Ave");
-- ------------------------------------------------------------


-- Update a staff member's salary   ---------------------
DROP PROCEDURE IF EXISTS update_staff_salary;
DELIMITER $$
CREATE PROCEDURE 
	update_staff_salary(IN in_SSN INT(9), IN in_salary FLOAT(8, 2))
BEGIN
	START TRANSACTION;
	UPDATE staff 
	SET salary = in_salary
	WHERE SSN = in_SSN;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_staff_salary(091010541, 10000);
-- ------------------------------------------------------------


-- Update a staff member's phone   ---------------------
DROP PROCEDURE IF EXISTS update_staff_phone;
DELIMITER $$
CREATE PROCEDURE 
	update_staff_phone(IN in_SSN INT(9), IN in_phone_number INT(11))
BEGIN
	UPDATE staff 
	SET phone_number = in_phone_number
	WHERE SSN = in_SSN;
END$$
DELIMITER ;

-- CALL update_staff_phone(091010541, 9567878765);

-- ------------------------------------------------------------


-- Update a staff member's role   ---------------------
DROP PROCEDURE IF EXISTS update_staff_role;
DELIMITER $$
CREATE PROCEDURE 
	update_staff_role(IN in_SSN INT(9), IN in_role VARCHAR(50))
BEGIN
	START TRANSACTION;
	UPDATE staff 
	SET role = in_role
	WHERE SSN = in_SSN;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_staff_role(091010541, "dishwasher");
-- ------------------------------------------------------------


-- Update the owner SSN of a restaurant   ---------------------
DROP PROCEDURE IF EXISTS update_owner;
DELIMITER $$
CREATE PROCEDURE 
	update_owner(IN in_restaurant_id INT, IN in_SSN INT(9))
BEGIN
	START TRANSACTION;
	UPDATE owns 
	SET owner_ssn = in_SSN
	WHERE restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_owner(1, 091010541);




