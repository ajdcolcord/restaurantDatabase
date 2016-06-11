USE restaurantDB;

-- #### VIEW PROCEDURES ##########################################
-- View all staff of the given restaurant id  ---------------
DROP PROCEDURE IF EXISTS view_restaurant_staff;
DELIMITER $$
CREATE PROCEDURE 
	view_restaurant_staff(IN in_restaurant_id INT)
BEGIN
	SELECT SSN, staff_name, s.address, phone_number, salary, start_date, role
    FROM staff s
    JOIN restaurants r
    ON s.restaurant_id = r.restaurant_id
    WHERE s.restaurant_id = in_restaurant_id;
END$$
DELIMITER ;

CALL view_restaurant_staff(1);

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
        IN in_phone_number INT(10),
        IN in_salary FLOAT(8, 2),
        IN in_role VARCHAR(50)
	)
BEGIN
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
END$$
DELIMITER ;

CALL add_staff(191900542, 1, 'Jake Bob', '100 Pleasant Street', 1999990129, 12000.62, 'bus');

-- ------------------------------------------------------------







-- #### REMOVE PROCEDURES ##########################################
-- Remove a staff member from the restaurant  ---------------
DROP PROCEDURE IF EXISTS remove_staff;
DELIMITER $$
CREATE PROCEDURE 
	remove_staff(IN in_SSN INT(9), IN in_restaurant_id INT)
BEGIN
	DELETE 
    FROM staff
    WHERE SSN = in_SSN
    AND restaurant_id = in_restaurant_id;
END$$
DELIMITER ;

CALL remove_staff(543454346, 2);
-- ------------------------------------------------------------
SELECT * FROM staff;