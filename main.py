#!/usr/bin/env python
from sqlalchemy import create_engine
from staff import view_restaurant_staff
from menu import view_restaurant_menus


def main():
    """
    Runs the main program in a step-wise manner
    :return:
    """
    username, password = request_login()

    conn = create_connection(username, password)

    # prompt the user for a restaurant choice, store ID
    chosen_restaurant_id = view_restaurant_procedure(conn)

    execute_restaurant_options(conn, chosen_restaurant_id)

    close(conn)


def request_login():
    """
    Request a username and password from the user, returning it as a tuple of strings
    :return: String, String - (username, password)
    """
    username = raw_input("Please enter the MySQL Username: ")
    password = raw_input("Please enter the MySQL Password: ")
    return username, password


def create_connection(username, password):
    """
    Initializes a new Database Connection using the given username and password
    to a local database on port 3306, with the name of restaurantDB
    :param username: String - the given username
    :param password: String - the given password
    :return: DB Connection Engine
    """
    settings = {
        'userName': username,         # The name of the MySQL account to use (or empty for anonymous)
        'password': password,         # The password for the MySQL account (or empty for anonymous)
        'serverName': "localhost",    # The name of the computer running MySQL
        'portNumber': 3306,           # The port of the MySQL server (default is 3306)
        'dbName': "restaurantDB",
    }

    # Connect to the database
    return create_engine('mysql://{0[userName]}:{0[password]}@{0[serverName]}:{0[portNumber]}/{0[dbName]}'.format(settings))


def view_restaurant_procedure(conn):
    """
    Runs all necessary steps to promp the user for a desired restaurant to view,
    printing out restaurant info when a valid restaurant ID is chosen
    :param conn: the DB connection
    :return: Int - the chosen restaurant ID
    """
    available_restaurants = get_restaurants(conn)
    show_restaurants(available_restaurants)
    chosen_restaurant_id = get_restaurant_request(available_restaurants)
    view_restaurant(conn, chosen_restaurant_id)

    return chosen_restaurant_id


def execute_restaurant_options(conn, chosen_restaurant_id):
    """
    Executes the base-level options for selecting whether to view a restaurant's staff or menus
    :param conn: the DB connection
    :param chosen_restaurant_id: Int - the chosen restaurant being viewed
    :return: Void - printing results
    """
    view_choice = get_view_choice()
    if view_choice == 1:
        view_restaurant_staff(conn, chosen_restaurant_id)
    else:
        view_restaurant_menus(conn, chosen_restaurant_id)


def get_restaurants(conn):
    """
    Gets the available restaurants from the restaurants table in the DB, stored as an Array
    :param conn: DB Connection Engine
    :return: Array of Tuple(Int, String) - the available (restaurant_id, restaurant_name) stored in the DB
    """
    get_restaurants_string = "SELECT restaurant_id, restaurant_name FROM {}".format("restaurants")
    return [(restaurant[0], restaurant[1]) for restaurant in conn.execute(get_restaurants_string)]


def show_restaurants(restaurant_tuples):
    """
    Print out the available restaurants with a number to identify them
    :param restaurant_tuples: List of (Int, String) - the restaurant ID, the restaurant name
    :return: Void - prints out to console
    """
    print "------------------------------------------------"
    print "Please choose a restaurant to view\n"

    for restaurant in restaurant_tuples:
        print "\t" + str(restaurant[0]) + ": " + str(restaurant[1])

    print "------------------------------------------------\n"


def get_restaurant_request(restaurant_tuples):
    """
    Gets the restaurant ID request from the user, checks to see if it
    exists in the given array of restaurant tuple (id, name)
    :param restaurant_tuples: Array of (Int, String) - the list of available restaurants in the DB
    :return: Int - the first valid restaurant ID provided by the user
    """
    restaurant_id = raw_input("Please enter a restaurant ID: ")

    chosen_restaurant_id = None
    while not chosen_restaurant_id:
        try:
            if int(restaurant_id) in [restaurant[0] for restaurant in restaurant_tuples]:
                return restaurant_id
            print "The given restaurant does not exist in the database\n"
            restaurant_id = raw_input("Please enter a restaurant ID: ")
        except ValueError:
            restaurant_id = raw_input("Please enter a restaurant ID: ")
            continue

    print chosen_restaurant_id


def view_restaurant(conn, restaurant_name):
    """
    Calls the view_restaurant stored procedure from the connection with the given restaurant name
    :param conn: DB Connection Engine
    :param restaurant_name: String - the name of the restaurant to view
    :return: Void - prints out result set
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("view_restaurant", [restaurant_name])
    results = list(cursor.fetchall())
    print "------------------------------------------------"
    for (restaurant_name, address, owner_ssn, restaurant_owner, price_range, rating, type_name) in results:
        print "\tName:  - - - - - " + str(restaurant_name)
        print "\tAddress: - - - - " + str(address)
        print "\tOwner SSN: - - - " + str(owner_ssn)
        print "\tOwner Name:  - - " + str(restaurant_owner)
        print "\tPrice Range: - - " + str(price_range)
        print "\tRating:  - - - - " + str(rating)
        print "\tType:  - - - - - " + str(type_name)
    print "------------------------------------------------"

    cursor.close()


def get_view_choice():
    """
    Prompts the user to either view the restaurant staff or restaurant menus
    :return: Int - the option chosen by the user
    """
    while True:
        try:
            choice = int(raw_input("Enter 1 to view Staff, 2 to view Menus: "))
            if choice in [1, 2]:
                return choice
        except ValueError:
            continue


def close(conn):
    """
    Close the connection to the database engine and quit the program
    :param conn: the DB connection
    :return: Void - closes the program
    """
    conn.dispose()
    quit()


main()
