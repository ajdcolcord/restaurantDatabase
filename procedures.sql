USE restaurantDB;


-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS view_restaurant;
DELIMITER $$
CREATE PROCEDURE 
	view_restaurant(IN in_restaurant_name VARCHAR(50))
BEGIN
    SELECT 
		r.restaurant_name, 
		r.address, 
		r.price_range, 
		AVG(rat.rating) AS rating, 
		typ.type_name
    FROM 
		restaurants r
    LEFT JOIN restaurant_rating rat
		ON r.restaurant_id = rat.restaurant_id
    LEFT JOIN restaurant_type typ
		ON r.restaurant_id = typ.restaurant_id
    WHERE restaurant_name = in_restaurant_name
    GROUP BY r.restaurant_id, r.restaurant_name, r.address, r.price_range, typ.type_name;
END$$
DELIMITER ;

CALL view_restaurant("Dunkin Donuts");

-- ------------------------------------------------------------

-- SHOW AVAILABLE MENUS FOR THE GIVEN RESTAURANT---------------
DROP PROCEDURE IF EXISTS view_restaurant_menus;
DELIMITER $$
CREATE PROCEDURE 
	view_restaurant_menus(IN in_restaurant_name VARCHAR(50))
BEGIN
	SELECT menu_id, menu_type
    FROM menu m
    JOIN restaurants r
    ON r.restaurant_id = m.restaurant_id
	WHERE r.restaurant_id = (
		SELECT restaurant_id
		FROM restaurants
		WHERE restaurant_name = in_restaurant_name);
END$$
DELIMITER ;

CALL view_restaurant_menus("Panera Bread");

-- ------------------------------------------------------------


-- --Show menu item name and price for a given menu------------
DROP PROCEDURE IF EXISTS view_menu;
DELIMITER $$
CREATE PROCEDURE 
	view_menu(IN in_menu_id INT)
BEGIN
	SELECT item_name, price
    FROM menu_item mi
    JOIN menu m
    ON mi.menu_id = m.menu_id
    WHERE m.menu_id = in_menu_id;
END$$
DELIMITER ;

CALL view_menu(1);

-- ------------------------------------------------------------


-- Show the recipe for the given menu item ID   ---------------
DROP PROCEDURE IF EXISTS view_recipe;
DELIMITER $$
CREATE PROCEDURE 
	view_recipe(IN in_menu_item_id INT)
BEGIN
	SELECT recipe_name, instructions
    FROM recipe r
    LEFT JOIN menu_item mi
    ON r.menu_item_id = mi.menu_item_id
    WHERE mi.menu_item_id = in_menu_item_id;
END$$
DELIMITER ;

CALL view_recipe(5);

-- ------------------------------------------------------------


-- Show the ingredients for the given recipe id   ---------------
DROP PROCEDURE IF EXISTS view_recipe_ingredients;
DELIMITER $$
CREATE PROCEDURE 
	view_recipe_ingredients(IN in_recipe_id INT)
BEGIN
	SELECT ingredient_name, amount
    FROM ingredient i
    JOIN recipe r
    ON i.recipe_id = r.recipe_id
    WHERE i.recipe_id = in_recipe_id;
END$$
DELIMITER ;

CALL view_recipe_ingredients(1);

-- ------------------------------------------------------------

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

CALL add_staff(543454346, 2, 'Emily Shmoe', '129 Franklin Street', 1567656563, 41000.02, 'chef');

-- ------------------------------------------------------------

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


