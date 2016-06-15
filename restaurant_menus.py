#!/usr/bin/env python
from menu import view_menu


def view_restaurant_menus(conn, chosen_restaurant_id):
    """
    View all menu information from the given chosen_restaurant_id by calling the view_restaurant_menus procedure
    :param conn: DB Connection Engine
    :param chosen_restaurant_id: Int - the given restaurant ID
    :return: Void - prints out the restaurant menu info (ID and Types)
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("view_restaurant_menus", [chosen_restaurant_id])
    results = list(cursor.fetchall())
    print "------------------------------------------------"
    print "Menus for Restaurant " + str(chosen_restaurant_id)

    all_menu_ids = []
    for (menu_id, menu_type) in results:
        all_menu_ids.append(menu_id)
        print "\tID: " + str(menu_id) + "\tType: " + str(menu_type).capitalize()

    cursor.close()

    print "------------------------------------------------"

    choose_next_option(conn, chosen_restaurant_id, all_menu_ids)


def choose_next_option(conn, restaurant_id, all_menu_ids):
    """
    Request a choice to see if the user would like to Add, Update, or Remove menu
    :param conn: the DB connection
    :param restaurant_id: the ID of the restaurant that the current menu is contained
    :param all_menu_id: Array[Int] - all available menu IDs of this restaurant
    :return: Void - calls the proceeding functions
    """
    while True:
        try:
            menu_action_choice = int(raw_input("Enter a menu ID to view, or 0 to Add a New Menu"))
            if menu_action_choice in all_menu_ids:
                view_menu(conn, menu_action_choice, restaurant_id)

            elif menu_action_choice == 0:
                add_menu(conn, restaurant_id)

        except ValueError:
            continue


def add_menu(conn, restaurant_id):
    """
    Runs the procedures to add a new menu to the given restaurant ID
    :param conn: the DB connection
    :param restaurant_id: Int- the restaurant_id to add a menu to
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("add_menu", [restaurant_id, get_menu_type()])
    cursor.close()

    view_restaurant_menus(conn, restaurant_id)


def get_menu_type():
    """
    Gets a valid menu type from the user
    :return: String - the valid menu type
    """
    while True:
        try:
            name = raw_input("Enter the new menu type (breakfast, lunch, dinner, dessert): ")
            if name in ['breakfast', 'lunch', 'dinner', 'dessert']:
                return name
        except ValueError:
            continue