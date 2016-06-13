DROP TRIGGER IF EXISTS calculate_price_range_after_insert;
DELIMITER $$

CREATE TRIGGER calculate_price_range_after_insert AFTER INSERT ON restaurantDB.menu_contents
	FOR EACH ROW 
		UPDATE restaurantDB.restaurants
		SET price_range = (SELECT calculate_price_range(NEW.menu_id))
        WHERE restaurant_id = (SELECT get_restaurant_id_from_menu_id(NEW.menu_id));
$$
DELIMITER ;
show triggers;
