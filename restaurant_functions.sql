DROP FUNCTION IF EXISTS calculate_price_range;

DELIMITER $$

CREATE FUNCTION calculate_price_range(in_menu_id INT)
	RETURNS CHAR
BEGIN
      DECLARE result CHAR;
      DECLARE avg_price FLOAT(8, 4);
      DECLARE in_restaurant_id INT;
      
      SELECT get_restaurant_id_from_menu_id(in_menu_id)
      INTO in_restaurant_id;
      
      SELECT AVG(price)
      FROM menu m
      JOIN menu_contents mc
		ON m.menu_id = mc.menu_id
      WHERE m.restaurant_id = in_restaurant_id
      INTO avg_price;
      
		IF avg_price <= 5 THEN SELECT '1' INTO result;
		ELSEIF avg_price <= 10 THEN SELECT '2' INTO result;
		ELSEIF avg_price <= 18 THEN SELECT '3' INTO result;
		ELSEIF avg_price <= 23 THEN SELECT '4' INTO result;
		ELSE SELECT '5' INTO result;
		END IF;
        
	RETURN result;
END$$
DELIMITER ;

SELECT calculate_price_range(1);






DROP FUNCTION IF EXISTS get_restaurant_id_from_menu_id;

DELIMITER $$

CREATE FUNCTION get_restaurant_id_from_menu_id(in_menu_id INT)
	RETURNS INT
BEGIN
      DECLARE result INT;
      
      SELECT restaurant_id
      FROM menu
      WHERE menu_id = in_menu_id
      INTO result;
      
	RETURN result;
END$$
DELIMITER ;

SELECT get_restaurant_id_from_menu_id(2);