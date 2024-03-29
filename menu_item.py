#!/usr/bin/env python
import menu
from ingredients import view_ingredients


def view_item_recipes(conn, menu_item_id, menu_id, restaurant_id):
    """
    View information on the specific menu item ID of the given menu ID by calling the view_recipe procedure
    :param conn: DB Connection Engine
    :param menu_item_id: Int - the ID of the menu item being viewed
    :param menu_id: Int - the ID of the menu (for callback functions)
    :param restaurant_id: Int - the ID of the restaurant (for callback functions)
    :return: Void - prints out the restaurant menu info (ID and Types)
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("view_recipe", [menu_item_id])
    results = list(cursor.fetchall())
    print "------------------------------------------------"
    print "Recipe of Menu Item: " + str(menu_item_id)
    all_recipe_ids = []
    for (recipe_id, recipe_name, instructions) in results:
        all_recipe_ids.append(recipe_id)
        print "\tID: " \
              + str(recipe_id) \
              + " : " \
              + str(recipe_name).capitalize() \
              + "\n\t\t--Instructions: " \
              + str(instructions).capitalize() \
              + "\n"

    cursor.close()

    print "------------------------------------------------"

    choose_next_option(conn, menu_item_id, all_recipe_ids, menu_id, restaurant_id)


def choose_next_option(conn, menu_item_id, all_recipe_ids, menu_id, restaurant_id):
    """
    Request a choice to see if the user would like to Add, Update, or Remove menu
    :param conn: the DB connection
    :param menu_item_id: the ID of the menu item selected
    :param all_recipe_ids: Array[Int] - all available recipe IDs of this menu_item
    :param menu_id: the ID of the menu that the current menu_item is in
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void - calls the proceeding functions
    """
    while True:
        try:
            recipe_action_choice = int(
                raw_input("Enter a recipe ID to modify it or view it's ingredients, 0 to Add a New recipe, or -1 to delete this menu item"))
            if recipe_action_choice == -1:
                remove_menu_item(conn, menu_item_id, menu_id, restaurant_id)
            elif recipe_action_choice == 0:
                add_recipe(conn, menu_item_id, menu_id, restaurant_id)
            elif recipe_action_choice in all_recipe_ids:
                recipe_action(conn, recipe_action_choice, menu_item_id, menu_id, restaurant_id)
            else:
                print "Invalid option"
        except ValueError:
            continue


def recipe_action(conn, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    Requests the next action to take - either modify the recipe instructions or view ingreduents
    :param conn: the DB connection
    :param recipe_id: the ID of the recipe
    :param menu_item_id: the ID of the menu item selected
    :param menu_id: the ID of the menu that the current menu_item is in
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void
    """
    if get_recipe_action_choice() == 0:
        modify_recipe_instructions(conn, recipe_id, menu_item_id, menu_id, restaurant_id)
    else:
        view_ingredients(conn, recipe_id, menu_item_id, menu_id, restaurant_id)


def modify_recipe_instructions(conn, recipe_id, menu_item_id, menu_id, restaurant_id):
    """
    Requests for the new instructions from the user, then updates the instructions for recipe at recipe_id
    :param conn: the DB connection
    :param recipe_id: the ID of the recipe
    :param menu_item_id: the ID of the menu item selected
    :param menu_id: the ID of the menu that the current menu_item is in
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void
    """

    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_recipe_instructions", [int(recipe_id), str(get_instructions())])
    cursor.close()

    view_item_recipes(conn, menu_item_id, menu_id, restaurant_id)


def remove_menu_item(conn, menu_item_id, menu_id, restaurant_id):
    """
    Calls the remove_staff procedure
    :param conn: the DB connection
    :param menu_item_id: Int - the menu item ID to remove
    :param menu_id: Int - the menu ID to call back to
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void - calls the view_menu function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("remove_menu_item", [int(menu_item_id)])
    cursor.close()

    menu.view_menu(conn, menu_id, restaurant_id)


def add_recipe(conn, menu_item_id, menu_id, restaurant_id):
    """
    Runs the procedures to add a new staff member to the given restaurant ID
    :param conn: the DB connection
    :param menu_item_id: the ID of the current menu item
    :param menu_id: the ID of the current menu
    :param restaurant_id: Int - the restaurant ID to call back to
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("add_recipe",
                    [
                        menu_item_id,
                        get_name(),
                        get_instructions()
                    ])
    cursor.close()

    view_item_recipes(conn, menu_item_id, menu_id, restaurant_id)


def get_recipe_action_choice():
    """
    Requests for a new choice to take on the menu item's recipe, either update it's instructions or view ingredients
    :return: Int - (0 to modify it's instructions, 1 to view its ingredients)
    """
    while True:
        try:
            choice = int(raw_input("Enter 0 to modify this recipe's instructions, or 1 to view its ingredients: "))
            if choice in [0, 1]:
                return choice
        except ValueError:
            continue


def get_name():
    """
    Requests for a new recipe name from the user
    :return: String - the new recipe name
    """
    while True:
        try:
            name = raw_input("Enter the new recipe name: ")
            return name
        except ValueError:
            continue


def get_instructions():
    """
    Requests for new recipe instructions from the user
    :return: String - the new recipe instructions
    """
    while True:
        try:
            name = raw_input("Enter instructions: ")
            return name
        except ValueError:
            continue