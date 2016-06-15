#!/usr/bin/env python
import menu_item

def view_ingredients(conn, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    View information on the specific menu item ID of the given menu ID by calling the view_recipe procedure
    :param conn: DB Connection Engine
    :param recipe_id: Int - the ID of the recipe being viewed
    :param menu_item_id: Int - the ID of the menu item being viewed
    :param menu_id: Int - the ID of the menu (for callback functions)
    :param restaurant_id: Int - the ID of the restaurant (for callback functions)
    :return: Void - prints out the restaurant menu info (ID and Types)
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("view_recipe_ingredients", [recipe_id])
    results = list(cursor.fetchall())
    print "------------------------------------------------"
    print "Recipe " + str(recipe_id)
    i = 1
    ingredients = []
    for (ingredient_name, amount) in results:
        ingredients = ingredients + [ingredient_name]
        print "\t" \
              + str(i) \
              + " : " \
              + str(ingredient_name).capitalize() \
              + "\n\t\t--Amount: " \
              + str(amount) \
              + "\n"
        i += 1

    cursor.close()

    print "------------------------------------------------"

    choose_next_option(conn, recipe_id, ingredients, menu_item_id, menu_id, restaurant_id)



def choose_next_option(conn, recipe_id, ingredients, menu_item_id, menu_id, restaurant_id):
    """
    Request a choice to see if the user would like to Add, Update, or Remove menu
    :param conn: the DB connection
    :param recipe_id: Int - the ID of the current recipe
    :param ingredients: Array(String) - each ingredient name in the recipe
    :param menu_item_id: the ID of the menu item selected
    :param menu_id: the ID of the menu that the current menu_item is in
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void - calls the proceeding functions
    """
    while True:
        try:
            ingredient_action_choice = int(
                raw_input("Enter an ingredient ID to modify it, 0 to Add a New ingredient, or -1 to delete this recipe"))
            if ingredient_action_choice == -1:
                remove_recipe(conn, recipe_id, menu_item_id, menu_id, restaurant_id)
            elif ingredient_action_choice == 0:
                add_ingredient(conn, recipe_id, ingredients, menu_item_id, menu_id, restaurant_id)
            elif 1 <= ingredient_action_choice <= len(ingredients):
                modify_ingredient(conn, ingredient_action_choice, ingredients, recipe_id, menu_item_id, menu_id, restaurant_id)
            else:
                print "Invalid option"
        except ValueError:
            continue


def remove_recipe(conn, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    Calls the remove_staff procedure
    :param conn: the DB connection
    :param recipe_id: Int - the recipe ID to remove
    :param menu_item_id: Int - the menu item ID to remove
    :param menu_id: Int - the menu ID to call back to
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void - calls the view_menu function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("remove_recipe", [int(recipe_id)])
    cursor.close()
    print "HERE"
    menu_item.view_menu_item(conn, menu_item_id, menu_id, restaurant_id)


def add_ingredient(conn, recipe_id, ingredients, menu_item_id, menu_id, restaurant_id):
    """
    Runs the procedures to add a new staff member to the given restaurant ID
    :param conn: the DB connection
    :param recipe_id: the ID of the current recipe
    :param ingredients: the list of ingredients currently on the recipe
    :param menu_item_id: the ID of the current menu item
    :param menu_id: the ID of the current menu
    :param restaurant_id: Int - the restaurant ID to call back to
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("add_ingredient",
                    [
                        recipe_id,
                        get_name(ingredients),
                        get_amount()
                    ])
    cursor.close()

    view_ingredients(conn, recipe_id, menu_item_id, menu_id, restaurant_id)


def modify_ingredient(conn, ingredient_number, ingredients, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    Request a choice to modify the given ingredient (based on the ingredient_number provided by the user)
    :param conn: the DB connection
    :param ingredient_action_choice:
    :param ingredients: Array[String] - the ingredient names
    :param recipe_id: Int - the ID of the current recipe
    :param menu_item_id: Int - the ID of the current menu_item
    :param menu_id: Int - the ID of the current menu
    :param restaurant_id: Int - the ID of the current restaurant
    :return: Void
    """
    ingredient = ingredients[ingredient_number - 1]
    while True:
        try:
            choice = int(raw_input("1 to Update, or 2 to Remove the ingredient: "))
            if choice == 1:
                update_ingredient(conn, ingredient, recipe_id, menu_item_id, menu_id, restaurant_id)
            elif choice == 2:
                remove_ingredient(conn, ingredient, recipe_id, menu_item_id, menu_id, restaurant_id)
        except ValueError:
            continue


def update_ingredient(conn, ingredient, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    Calls the procedure to update the given ingredient amount with the user_inputted values
    :param conn: the DB connection
    :param ingredient: Tuple(String, Int) - the chosen ingredient to update
    :param recipe_id: Int - the ID of the current recipe
    :param menu_item_id: Int - the ID of the current menu_item
    :param menu_id: Int - the ID of the current menu
    :param restaurant_id: Int - the ID of the current restaurant
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_ingredient_amount", [int(recipe_id), str(ingredient[0]), int(get_amount())])
    cursor.close()

    view_ingredients(conn, recipe_id, menu_item_id, menu_id, restaurant_id)


def remove_ingredient(conn, ingredient, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    Calls the procedure to remove the given ingredient with the user_inputted values
    :param conn: the DB connection
    :param ingredient: Tuple(String, Int) - the chosen ingredient to update
    :param recipe_id: Int - the ID of the current recipe
    :param menu_item_id: Int - the ID of the current menu_item
    :param menu_id: Int - the ID of the current menu
    :param restaurant_id: Int - the ID of the current restaurant
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("remove_ingredient", [int(recipe_id), str(ingredient)])
    cursor.close()

    view_ingredients(conn, recipe_id, menu_item_id, menu_id, restaurant_id)



def get_name(ingredient_names):
    """
    Requests for a new valid ingredient amount from the user
    :return: Float - the new valid ingredient amount
    """
    while True:
        try:
            name = raw_input("Enter the new ingredient name (include measurement type): ")
            if name not in ingredient_names:
                return name
            else:
                print "ERROR: Ingredient already exists in this recipe"
        except ValueError:
            continue


def get_amount():
    """
    Requests for a new valid ingredient amount from the user
    :return: Float - the new valid ingredient amount
    """
    while True:
        try:
            price = int(raw_input("Enter the new ingredient amount: "))
            if price > 0:
                return price
        except ValueError:
            continue
