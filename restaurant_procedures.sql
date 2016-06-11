USE restaurantDB;


#### VIEW PROCEDURES ##########################################
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

CALL view_restaurant("Panera Bread");

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
    FROM menu m
    JOIN menu_contents mc
    ON m.menu_id = mc.menu_id
    JOIN menu_item mi
    ON mc.menu_item_id = mi.menu_item_id
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









-- #### ADD PROCEDURES ##########################################
-- Add a restaurant to the database, including the type ---------
DROP PROCEDURE IF EXISTS add_restaurant;
DELIMITER $$
CREATE PROCEDURE 
	add_restaurant(
		IN in_restaurant_name VARCHAR(100),
        IN in_address VARCHAR(100),
        IN in_price_range ENUM('1', '2', '3', '4', '5'),
        IN in_type_name VARCHAR(50)
	)
BEGIN
    DECLARE max_restaurant_id INT;

	INSERT INTO restaurants (restaurant_name, address, price_range)
	VALUES (
		in_restaurant_name, 
		in_address, 
		in_price_range
	);
    
    
    SET max_restaurant_id = (SELECT MAX(restaurant_id)
	 						FROM restaurants);
    
    INSERT INTO restaurant_type (restaurant_id, type_name)
    VALUES (max_restaurant_id, in_type_name);
END$$
DELIMITER ;

CALL add_restaurant("BHOP", "29 Huntington Avenue", 2, "Pizza");

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
	INSERT INTO restaurant_rating (restaurant_id, rating)
	VALUES (
		in_restaurant_id, 
		in_rating
	);
END$$
DELIMITER ;

CALL add_rating(1, 4);

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
	INSERT INTO menu (restaurant_id, menu_type)
	VALUES (
		in_restaurant_id, 
		in_menu_type
	);
END$$
DELIMITER ;

CALL add_menu(7, 'dessert');

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
    
	INSERT INTO menu_item (item_name)
	VALUES (in_item_name);
    
    SET max_menu_item_id = (SELECT MAX(menu_item_id)
	 						FROM menu_item);
                            
	INSERT INTO menu_contents (menu_id, menu_item_id, price)
    VALUES (in_menu_id, max_menu_item_id, in_price);
END$$
DELIMITER ;

SELECT * FROM menu_item;

CALL add_menu_item(4, "Chicken Caesar Salad", 10.55);

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
	INSERT INTO recipe (menu_item_id, recipe_name, instructions)
	VALUES (
		in_menu_item_id, 
		in_recipe_name,
        in_instructions
	);
END$$
DELIMITER ;

CALL add_recipe(5, "Side of Pickles", "2 Pickles");

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
	INSERT INTO ingredient (recipe_id, ingredient_name, amount)
	VALUES (
		in_recipe_id, 
		in_ingredient_name,
        in_amount
	);
END$$
DELIMITER ;

CALL add_ingredient(1, "Mustard (tbsp)", 1);

-- ------------------------------------------------------------





-- #### REMOVE PROCEDURES ##########################################
-- Remove a restaurant from the database ---------------
DROP PROCEDURE IF EXISTS remove_restaurant;
DELIMITER $$
CREATE PROCEDURE 
	remove_restaurant(IN in_restaurant_id INT)
BEGIN
	DELETE 
    FROM restaurants
    WHERE restaurant_id = in_restaurant_id;
END$$
DELIMITER ;

CALL remove_restaurant(12);
-- ------------------------------------------------------------


-- Remove a menu from a restaurant ---------------------------
DROP PROCEDURE IF EXISTS remove_menu;
DELIMITER $$
CREATE PROCEDURE 
	remove_menu(IN in_menu_id INT)
BEGIN
	DELETE 
    FROM menu
    WHERE menu_id = in_menu_id;
END$$
DELIMITER ;

CALL remove_menu(7);
-- ------------------------------------------------------------

-- Remove a menu item from the given menu id ------------------
DROP PROCEDURE IF EXISTS remove_menu_item;
DELIMITER $$
CREATE PROCEDURE 
	remove_menu_item(IN in_menu_item_id INT)
BEGIN
	DELETE 
    FROM menu_item
    WHERE menu_item_id = in_menu_item_id;
END$$
DELIMITER ;

CALL remove_menu_item(8);
-- ------------------------------------------------------------


-- Remove a recipe from the given recipe ID ------------------
DROP PROCEDURE IF EXISTS remove_recipe;
DELIMITER $$
CREATE PROCEDURE 
	remove_recipe(IN in_recipe_id INT)
BEGIN
	DELETE
    FROM recipe
    WHERE recipe_id = in_recipe_id;
END$$
DELIMITER ;

CALL remove_recipe(3);
-- ------------------------------------------------------------



-- Remove the given ingredient name from the given recipe ------------------
DROP PROCEDURE IF EXISTS remove_ingredient;
DELIMITER $$
CREATE PROCEDURE 
	remove_ingredient(IN in_recipe_id INT, IN in_ingredient_name VARCHAR(50))
BEGIN
	DELETE
    FROM ingredient
    WHERE recipe_id = in_recipe_id
    AND ingredient_name = in_ingredient_name;
    
END$$
DELIMITER ;

CALL remove_ingredient(1, "Pickles");
-- ------------------------------------------------------------