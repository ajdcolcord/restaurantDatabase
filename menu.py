#!/usr/bin/env python
from menu_item import view_item_recipes
import restaurant_menus


def view_menu(conn, menu_id, restaurant_id):
    """
    View information on the specific menu ID of the given restaurant ID by calling the view_menu procedure
    :param conn: DB Connection Engine
    :param menu_id: Int - the ID of the menu to view
    :param restaurant_id: Int - the ID of the restaurant (for callback functions)
    :return: Void - prints out the restaurant menu info (ID and Types)
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("view_menu", [menu_id])
    results = list(cursor.fetchall())
    print "------------------------------------------------"
    print "Menu " + str(menu_id)
    all_menu_item_ids = []
    for (menu_item_id, item_name, price) in results:
        all_menu_item_ids.append(menu_item_id)
        print "\tID: " + str(menu_item_id) + " : " + str(item_name).capitalize() + "\n\t\t--Price: $" + str(price)

    cursor.close()

    print "------------------------------------------------"

    choose_next_option(conn, menu_id, all_menu_item_ids, restaurant_id)


def choose_next_option(conn, menu_id, all_menu_item_ids, restaurant_id):
    """
    Request a choice to see if the user would like to Add, Update, or Remove menu
    :param conn: the DB connection
    :param menu_id: the ID of the current menu
    :param all_menu_item_ids: Array[Int] - all available menu item IDs of this menu
    :param restaurant_id: Int - the restaurant ID to call back to
    :return: Void - calls the proceeding functions
    """
    while True:
        try:
            menu_action_choice = int(raw_input("Enter a menu item ID to view it or modify the price, 0 to Add a New Item, or -1 to delete this menu"))
            if menu_action_choice == -1:
                remove_menu(conn, menu_id, restaurant_id)
            elif menu_action_choice == 0:
                add_menu_item(conn, menu_id, restaurant_id)
            elif menu_action_choice in all_menu_item_ids:
                menu_item_action(conn, menu_action_choice, menu_id, restaurant_id)
            else:
                print "Invalid option"
        except ValueError:
            continue


def menu_item_action(conn, menu_item_id, menu_id, restaurant_id):
    """
    Requests the next action to take - either modify the recipe instructions or view ingreduents
    :param conn: the DB connection
    :param menu_item_id: the ID of the menu item selected
    :param menu_id: the ID of the menu that the current menu_item is in
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void
    """
    if get_menu_item_choice() == 0:
        modify_recipe_instructions(conn, menu_item_id, menu_id, restaurant_id)
    else:
        view_item_recipes(conn, menu_item_id, menu_id, restaurant_id)


def modify_recipe_instructions(conn, menu_item_id, menu_id, restaurant_id):
    """
    Requests for the new instructions from the user, then updates the instructions for recipe at recipe_id
    :param conn: the DB connection
    :param menu_item_id: the ID of the menu item selected
    :param menu_id: the ID of the menu that the current menu_item is in
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_menu_offering", [int(menu_item_id), str(get_name()), float(get_price())])
    cursor.close()

    view_menu(conn, menu_id, restaurant_id)


def remove_menu(conn, menu_id, restaurant_id):
    """
    Calls the remove_staff procedure
    :param conn: the DB connection
    :param menu_id: Int - the menu ID to remove
    :param restaurant_id: Int - the restaurant ID to call back to
    :return: Void - calls the view_restaurant_menus function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("remove_menu", [int(menu_id)])
    cursor.close()

    restaurant_menus.view_restaurant_menus(conn, restaurant_id)


def add_menu_item(conn, menu_id, restaurant_id):
    """
    Runs the procedures to add a new staff member to the given restaurant ID
    :param conn: the DB connection
    :param menu_id: the ID of the current menu
    :param restaurant_id: Int - the restaurant ID to call back to
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("add_menu_item",
                    [
                        menu_id,
                        get_name(),
                        get_price()
                    ])
    cursor.close()

    view_menu(conn, menu_id, restaurant_id)


def get_name():
    """
    Requests for a new name from the user
    :return: String - the new name
    """
    while True:
        try:
            name = raw_input("Enter the new menu item name: ")
            return name
        except ValueError:
            continue


def get_price():
    """
    Requests for a new valid price from the user
    :return: Float - the new valid price
    """
    while True:
        try:
            price = float(raw_input("Enter the new menu item price: "))
            return price
        except ValueError:
            continue


def get_menu_item_choice():
    """
    Requests for a new choice to take on the menu item, either update a price or view its recipes
    :return: Int - (0 to modify it's price, 1 to view its recipes)
    """
    while True:
        try:
            choice = int(raw_input("Enter 0 to modify this menu item's price, or 1 to view its recipes: "))
            if choice in [0, 1]:
                return choice
        except ValueError:
            continue