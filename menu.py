#!/usr/bin/env python
from menu_item import view_menu_item
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
            menu_action_choice = int(raw_input("Enter a menu item ID to view it's recipe, 0 to Add a New Item, or -1 to delete this menu"))
            if menu_action_choice == -1:
                remove_menu(conn, menu_id, restaurant_id)
            elif menu_action_choice == 0:
                add_menu_item(conn, menu_id, restaurant_id)
            elif menu_action_choice in all_menu_item_ids:
                view_menu_item(conn, menu_action_choice, menu_id, restaurant_id)
            else:
                print "Invalid option"
        except ValueError:
            continue


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