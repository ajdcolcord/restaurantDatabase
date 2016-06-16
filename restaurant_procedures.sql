USE restaurantDB;


#### VIEW PROCEDURES ##########################################
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS view_restaurant;
DELIMITER $$
CREATE PROCEDURE 
	view_restaurant(IN in_restaurant_id INT)
BEGIN
	START TRANSACTION;
    SELECT 
		r.restaurant_name, 
		r.address, 
        o.owner_ssn,
        s.staff_name AS restaurant_owner,
		r.price_range, 
		AVG(rat.rating) AS rating, 
		typ.type_name
    FROM 
		restaurants r
    LEFT JOIN restaurant_rating rat
		ON r.restaurant_id = rat.restaurant_id
    LEFT JOIN restaurant_type typ
		ON r.restaurant_id = typ.restaurant_id
	LEFT JOIN owns o
		ON r.restaurant_id = o.restaurant_id
	LEFT JOIN staff s
		ON o.owner_ssn = s.SSN
    WHERE 
		r.restaurant_id = in_restaurant_id
    GROUP BY 
		r.restaurant_id, 
        r.restaurant_name, 
        r.address, 
        r.price_range, 
        typ.type_name, 
        s.staff_name;
	COMMIT;
END$$
DELIMITER ;

CALL view_restaurant(1);

-- ------------------------------------------------------------

-- SHOW AVAILABLE MENUS FOR THE GIVEN RESTAURANT---------------
DROP PROCEDURE IF EXISTS view_restaurant_menus;
DELIMITER $$
CREATE PROCEDURE 
	view_restaurant_menus(IN in_restaurant_id INT)
BEGIN
	START TRANSACTION;
	SELECT menu_id, menu_type
    FROM menu m
    JOIN restaurants r
    ON r.restaurant_id = m.restaurant_id
	WHERE r.restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

CALL view_restaurant_menus(1);

-- ------------------------------------------------------------


-- --Show menu item name and price for a given menu------------
DROP PROCEDURE IF EXISTS view_menu;
DELIMITER $$
CREATE PROCEDURE 
	view_menu(IN in_menu_id INT)
BEGIN
	START TRANSACTION;
	SELECT mi.menu_item_id, item_name, price
    FROM menu m
    JOIN menu_contents mc
    ON m.menu_id = mc.menu_id
    JOIN menu_item mi
    ON mc.menu_item_id = mi.menu_item_id
    WHERE m.menu_id = in_menu_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL view_menu(1);

-- ------------------------------------------------------------


-- Show the recipe for the given menu item ID   ---------------
DROP PROCEDURE IF EXISTS view_recipe;
DELIMITER $$
CREATE PROCEDURE 
	view_recipe(IN in_menu_item_id INT)
BEGIN
	START TRANSACTION;
	SELECT r.recipe_id, recipe_name, instructions
    FROM recipe r
    LEFT JOIN menu_item mi
    ON r.menu_item_id = mi.menu_item_id
    WHERE mi.menu_item_id = in_menu_item_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL view_recipe(5);

-- ------------------------------------------------------------


-- Show the ingredients for the given recipe id   ---------------
DROP PROCEDURE IF EXISTS view_recipe_ingredients;
DELIMITER $$
CREATE PROCEDURE 
	view_recipe_ingredients(IN in_recipe_id INT)
BEGIN
	START TRANSACTION;
	SELECT ingredient_name, amount
    FROM ingredient i
    JOIN recipe r
    ON i.recipe_id = r.recipe_id
    WHERE i.recipe_id = in_recipe_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL view_recipe_ingredients(1);

-- ------------------------------------------------------------









-- #### ADD PROCEDURES ##########################################
-- Add a restaurant to the database, including the type ---------
DROP PROCEDURE IF EXISTS add_restaurant;
DELIMITER $$
CREATE PROCEDURE 
	add_restaurant(
		IN in_restaurant_name VARCHAR(100),
        IN in_address VARCHAR(100),
        IN in_type_name VARCHAR(50)
	)
BEGIN
    DECLARE max_restaurant_id INT;
    
    START TRANSACTION;
	INSERT INTO restaurants (restaurant_name, address)
	VALUES (
		in_restaurant_name, 
		in_address
	);
    
    SET max_restaurant_id = (SELECT MAX(restaurant_id)
	 						FROM restaurants);
    
    INSERT INTO restaurant_type (restaurant_id, type_name)
    VALUES (max_restaurant_id, in_type_name);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_restaurant("BHOP", "29 Huntington Avenue", 2, "Pizza");

-- ------------------------------------------------------------

-- Add a rating to the given restaurant  ---------------
DROP PROCEDURE IF EXISTS add_rating;
DELIMITER $$
CREATE PROCEDURE 
	add_rating(
		IN in_restaurant_id INT,
        IN in_rating ENUM('1', '2', '3', '4', '5')
	)
BEGIN
	START TRANSACTION;
	INSERT INTO restaurant_rating (restaurant_id, rating)
	VALUES (
		in_restaurant_id, 
		in_rating
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_rating(1, 4);

-- ------------------------------------------------------------

-- Add a menu to the given restaurant  ---------------
DROP PROCEDURE IF EXISTS add_menu;
DELIMITER $$
CREATE PROCEDURE 
	add_menu(
		IN in_restaurant_id INT,
        IN in_menu_type ENUM('breakfast', 'lunch', 'dinner', 'dessert')
	)
BEGIN
	START TRANSACTION;
	INSERT INTO menu (restaurant_id, menu_type)
	VALUES (
		in_restaurant_id, 
		in_menu_type
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_menu(7, 'dessert');

-- ------------------------------------------------------------

-- Add a menu item to the given menu  ---------------
DROP PROCEDURE IF EXISTS add_menu_item;
DELIMITER $$
CREATE PROCEDURE 
	add_menu_item(
		IN in_menu_id INT,
        IN in_item_name VARCHAR(50),
        IN in_price FLOAT(5, 2)
	)
BEGIN
	DECLARE max_menu_item_id INT;
    
    START TRANSACTION;
	INSERT INTO menu_item (item_name)
	VALUES (in_item_name);
    
    SET max_menu_item_id = (SELECT MAX(menu_item_id)
	 						FROM menu_item);
                            
	INSERT INTO menu_contents (menu_id, menu_item_id, price)
    VALUES (in_menu_id, max_menu_item_id, in_price);
    COMMIT;
END$$
DELIMITER ;


-- CALL add_menu_item(1, "Chicken Caesar Salad", 100.55);

-- ------------------------------------------------------------


-- Add a recipe to the given menu item  ---------------
DROP PROCEDURE IF EXISTS add_recipe;
DELIMITER $$
CREATE PROCEDURE 
	add_recipe(
		IN in_menu_item_id INT,
        IN in_recipe_name VARCHAR(50),
        IN in_instructions VARCHAR(60000)
	)
BEGIN
	START TRANSACTION;
	INSERT INTO recipe (menu_item_id, recipe_name, instructions)
	VALUES (
		in_menu_item_id, 
		in_recipe_name,
        in_instructions
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_recipe(5, "Side of Pickles", "2 Pickles");

-- ------------------------------------------------------------


-- Add an ingredient to the given recipe_id  ---------------
DROP PROCEDURE IF EXISTS add_ingredient;
DELIMITER $$
CREATE PROCEDURE 
	add_ingredient(
		IN in_recipe_id INT,
        IN in_ingredient_name VARCHAR(50),
        IN in_amount INT
	)
BEGIN
	START TRANSACTION;
	INSERT INTO ingredient (recipe_id, ingredient_name, amount)
	VALUES (
		in_recipe_id, 
		in_ingredient_name,
        in_amount
	);
    COMMIT;
END$$
DELIMITER ;

-- CALL add_ingredient(1, "Mustard (tbsp)", 1);

-- ------------------------------------------------------------





-- #### REMOVE PROCEDURES ##########################################
-- Remove a restaurant from the database ---------------
DROP PROCEDURE IF EXISTS remove_restaurant;
DELIMITER $$
CREATE PROCEDURE 
	remove_restaurant(IN in_restaurant_id INT)
BEGIN
	START TRANSACTION;
	DELETE 
    FROM restaurants
    WHERE restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_restaurant(12);
-- ------------------------------------------------------------


-- Remove a menu from a restaurant ---------------------------
DROP PROCEDURE IF EXISTS remove_menu;
DELIMITER $$
CREATE PROCEDURE 
	remove_menu(IN in_menu_id INT)
BEGIN
	START TRANSACTION;
	DELETE 
    FROM menu
    WHERE menu_id = in_menu_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_menu(7);
-- ------------------------------------------------------------

-- Remove a menu item from the given menu id ------------------
DROP PROCEDURE IF EXISTS remove_menu_item;
DELIMITER $$
CREATE PROCEDURE 
	remove_menu_item(IN in_menu_item_id INT)
BEGIN
	START TRANSACTION;
	DELETE 
    FROM menu_item
    WHERE menu_item_id = in_menu_item_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_menu_item(8);
-- ------------------------------------------------------------


-- Remove a recipe from the given recipe ID ------------------
DROP PROCEDURE IF EXISTS remove_recipe;
DELIMITER $$
CREATE PROCEDURE 
	remove_recipe(IN in_recipe_id INT)
BEGIN
	START TRANSACTION;
	DELETE
    FROM recipe
    WHERE recipe_id = in_recipe_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_recipe(3);
-- ------------------------------------------------------------



-- Remove the given ingredient name from the given recipe ------------------
DROP PROCEDURE IF EXISTS remove_ingredient;
DELIMITER $$
CREATE PROCEDURE 
	remove_ingredient(IN in_recipe_id INT, IN in_ingredient_name VARCHAR(50))
BEGIN
	START TRANSACTION;
	DELETE
    FROM ingredient
    WHERE recipe_id = in_recipe_id
    AND ingredient_name = in_ingredient_name;
    COMMIT;
END$$
DELIMITER ;

-- CALL remove_ingredient(1, "Pickles");
-- ------------------------------------------------------------







-- #### UPDATE PROCEDURES ##########################################
-- Update a restaurant's price range   ---------------------
DROP PROCEDURE IF EXISTS update_restaurant_price_range;
DELIMITER $$
CREATE PROCEDURE 
	update_restaurant_price_range(
			IN in_restaurant_id INT(9), 
            IN in_price_range ENUM('1', '2', '3', '4', '5')
	)
BEGIN
	START TRANSACTION;
	UPDATE restaurants
	SET price_range = in_price_range
	WHERE restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_restaurant_price_range(3, '2');
-- ------------------------------------------------------------



-- Update a restaurant's address   ---------------------
DROP PROCEDURE IF EXISTS update_restaurant_address;
DELIMITER $$
CREATE PROCEDURE 
	update_restaurant_address(
			IN in_restaurant_id INT(9), 
            IN in_address VARCHAR(100)
	)
BEGIN
	START TRANSACTION;
	UPDATE restaurants
	SET address = in_address
	WHERE restaurant_id = in_restaurant_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_restaurant_address(3, '21 Huntington Ave');
-- ------------------------------------------------------------


-- Update a menu offering's name and price   ---------------------
DROP PROCEDURE IF EXISTS update_menu_offering;
DELIMITER $$
CREATE PROCEDURE 
	update_menu_offering(
        IN in_menu_item_id INT,
        IN in_name VARCHAR(50),
        IN in_price FLOAT(5, 2)
	)
BEGIN
	START TRANSACTION;
	UPDATE menu_contents
	SET price = in_price
	WHERE menu_item_id = in_menu_item_id;
    
    UPDATE menu_item
    SET item_name = in_name
    WHERE menu_item_id = in_menu_item_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_menu_offering(1, 'Fried Egg', 2.00);
-- ------------------------------------------------------------



-- Update a recipe's instructions   ---------------------
DROP PROCEDURE IF EXISTS update_recipe_instructions;
DELIMITER $$
CREATE PROCEDURE 
	update_recipe_instructions(
			IN in_recipe_id INT, 
            IN in_instructions VARCHAR(60000)
	)
BEGIN
	START TRANSACTION;
	UPDATE recipe
	SET instructions = in_instructions
	WHERE recipe_id = in_recipe_id;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_recipe_instructions(1, 'Toast bread. Place the chicken on the bread with lettuce tomato and pickles.');
-- ------------------------------------------------------------


-- Update an ingredient amount   ---------------------
DROP PROCEDURE IF EXISTS update_ingredient_amount;
DELIMITER $$
CREATE PROCEDURE 
	update_ingredient_amount(
			IN in_recipe_id INT, 
            IN in_ingredient_name VARCHAR(50),
            IN in_amount INT
	)
BEGIN
	START TRANSACTION;
	UPDATE ingredient
	SET amount = in_amount
	WHERE recipe_id = in_recipe_id
    AND ingredient_name = in_ingredient_name;
    COMMIT;
END$$
DELIMITER ;

-- CALL update_ingredient_amount(1, 'Tomato', 1);
-- ------------------------------------------------------------