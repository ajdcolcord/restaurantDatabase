#!/usr/bin/env python


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

    for (menu_id, menu_type) in results:
        print "\tID: " + str(menu_id) + "\tType: " + str(menu_type).capitalize()

    cursor.close()

    print "------------------------------------------------"
