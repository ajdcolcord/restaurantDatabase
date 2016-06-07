DROP DATABASE IF EXISTS restaurantDB;

CREATE DATABASE IF NOT EXISTS restaurantDB;

USE restaurantDB;

-- ---------------------------------------------
-- RESTAURANT ENTITY TABLES
-- ---------------------------------------------
DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants 
(
	restaurant_id 	INT AUTO_INCREMENT 		PRIMARY KEY,
    restaurant_name VARCHAR(100) 			NOT NULL,
    address			VARCHAR(100) 			NOT NULL,
    price_range		ENUM('1', '2', '3', '4', '5')
);


-- ---------------------------------------------
DROP TABLE IF EXISTS restaurant_type;
CREATE TABLE restaurant_type
(
	restaurant_id 	INT,
    type_name		VARCHAR(50),
    
    CONSTRAINT restaurant_type_pks
		PRIMARY KEY (restaurant_id, type_name),
        
    CONSTRAINT type_restaurant_id_fk
		FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ---------------------------------------------
DROP TABLE IF EXISTS restaurant_rating;
CREATE TABLE restaurant_rating
(
	rating_id		INT AUTO_INCREMENT	PRIMARY KEY,
    restaurant_id	INT,
    rating			ENUM('1', '2', '3', '4', '5') NOT NULL,
    
    CONSTRAINT rating_restaurant_id_fk
		FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);




-- ---------------------------------------------
-- MENU ENTITY TABLES
-- ---------------------------------------------
DROP TABLE IF EXISTS menu;
CREATE TABLE menu
(
	menu_id			INT AUTO_INCREMENT 	PRIMARY KEY,
    restaurant_id	INT,
    menu_type		ENUM('breakfast', 'lunch', 'dinner', 'dessert') NOT NULL,

	CONSTRAINT menu_restaurant_id_fk
		FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ---------------------------------------------
DROP TABLE IF EXISTS menu_item;
CREATE TABLE menu_item
(
	menu_item_id	INT	AUTO_INCREMENT	PRIMARY KEY,
    menu_id			INT,
    item_name		VARCHAR(50) NOT NULL,
    price			FLOAT(5, 2),
    
    CONSTRAINT menu_item_menu_id_fk
		FOREIGN KEY (menu_id) REFERENCES menu (menu_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);


-- ---------------------------------------------
DROP TABLE IF EXISTS recipe;
CREATE TABLE recipe
(
	recipe_id		INT AUTO_INCREMENT	PRIMARY KEY,
    menu_item_id	INT,
    recipe_name		VARCHAR(50) NOT NULL,
    instructions	VARCHAR(60000),
    
    CONSTRAINT recipe_menu_item_id_fk
		FOREIGN KEY (menu_item_id) REFERENCES menu_item (menu_item_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);


-- ---------------------------------------------
DROP TABLE IF EXISTS ingredient;
CREATE TABLE ingredient
(
	recipe_id INT, 
    ingredient_name VARCHAR(50) NOT NULL, 
    amount INT, 
	
	CONSTRAINT ingredient_pks 
		PRIMARY KEY (recipe_id, ingredient_name), 
        
	CONSTRAINT ingredient_recipe_id_fk
		FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id)
		ON DELETE CASCADE ON UPDATE CASCADE
); 




-- ---------------------------------------------
-- STAFF ENTITY TABLES
-- ---------------------------------------------
DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
	SSN				INT(9) ZEROFILL 	PRIMARY KEY,
    restaurant_id	INT,
    staff_name		VARCHAR(50) 		NOT NULL,
    address			VARCHAR(100),
    phone_number	INT(10),
    salary			FLOAT(8, 2)			NOT NULL,
    start_date		TIMESTAMP 			DEFAULT CURRENT_TIMESTAMP(),
    role			VARCHAR(50),
    
    CONSTRAINT staff_restaurant_id_fk
		FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ---------------------------------------------
DROP TABLE IF EXISTS manages;
CREATE TABLE manages
(
	manager_ssn		INT(9) ZEROFILL,
    employee_ssn	INT(9) ZEROFILL,
    
    CONSTRAINT manages_pk
		PRIMARY KEY (manager_ssn, employee_ssn),
	CONSTRAINT manages_manager_ssn_fk
		FOREIGN KEY (manager_ssn) REFERENCES staff (SSN)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT manages_employee_ssn_fk
		FOREIGN KEY (employee_ssn) REFERENCES staff (SSN)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ---------------------------------------------
DROP TABLE IF EXISTS owns;
CREATE TABLE owns
(
	owner_ssn		INT(9) ZEROFILL,
    restaurant_id	INT,
    
    CONSTRAINT owns_pk
		PRIMARY KEY (owner_ssn, restaurant_id),
        
	CONSTRAINT owns_owner_ssn_fk
		FOREIGN KEY (owner_ssn) REFERENCES staff (SSN)
        ON DELETE CASCADE ON UPDATE CASCADE,
        
	CONSTRAINT owns_restaurant_id_fk
 		FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
