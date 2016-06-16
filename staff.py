#!/usr/bin/env python


def view_restaurant_staff(conn, chosen_restaurant_id):
    """
    View the staff information from the given chosen_restaurant_id by calling the view_restaurant_staff procedure
    :param conn: DB Connection Engine
    :param chosen_restaurant_id: Int - the given restaurant ID
    :return: Void - prints out the restaurant staff info
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("view_restaurant_staff", [chosen_restaurant_id])
    results = list(cursor.fetchall())
    print "------------------------------------------------"
    print "Staff for Restaurant " + str(chosen_restaurant_id)

    all_staff_SSN = []

    for (SSN, staff_name, address, phone_number, salary, start_date, role) in results:
        all_staff_SSN.append(SSN)
        print "\t- - - - - - - - - - - - - - - - - -"
        print "\tName: - - - - - " + str(staff_name).capitalize()
        print "\tSSN:  - - - - - " + str(SSN)
        print "\tAddress:  - - - " + str(address)
        print "\tPhone:  - - - - " + str(phone_number)
        print "\tSalary: - - - - " + str(salary)
        print "\tStart Date: - - " + str(start_date)
        print "\tRole: - - - - - " + str(role).capitalize() + "\n"
    cursor.close()

    print "------------------------------------------------"

    choose_next_option(conn, chosen_restaurant_id, all_staff_SSN)


def choose_next_option(conn, restaurant_id, all_staff_SSN):
    """
    Request a choice to see if the user would like to Add, Update, or Remove staff
    :param conn: the DB connection
    :param restaurant_id: the ID of the restaurant that the current staff is contained
    :param all_staff_SSN: Array[Int] - all available staff SSNs
    :return: Void - calls the proceeding functions
    """
    while True:
        try:
            staff_SSN = int(raw_input("Enter a staff SSN to modify, or 0 to Add a New Staff Member"))
            if staff_SSN in all_staff_SSN:
                modify_staff(conn, restaurant_id, staff_SSN)

            elif staff_SSN == 0:
                add_staff(conn, restaurant_id, all_staff_SSN)

        except ValueError:
            continue


def modify_staff(conn, restaurant_id, staff_SSN):
    """
    Request a choice to modify the given staff by their SSN, calling the update or remove functions
    :param conn: the DB connection
    :param staff_SSN: Int - the SSN of the staff chosen to be modified
    :return: Void - calls the proceeding functions
    """
    while True:
        try:
            choice = int(raw_input("1 to Update, or 2 to Remove a Staff Member: "))
            if choice == 1:
                update_staff(conn, restaurant_id, staff_SSN)
            elif choice == 2:
                remove_staff(conn, restaurant_id, staff_SSN)
        except ValueError:
            continue


def update_staff(conn, restaurant_id, staff_SSN):
    """
    Calls the procedure to update the given staff SSN with the user_inputted values
    :param conn: the DB connection
    :param staff_SSN: Int - the SSN of the staff to update
    :return: Void - Updates the staff member
    """
    while True:
        try:
            choice = int(raw_input("1 for Address, 2 for Salary, 3 for Phone Number, 4 for Role"))
            if choice == 1:
                update_address(conn, restaurant_id, staff_SSN, get_address())
                break
            elif choice == 2:
                update_salary(conn, restaurant_id, staff_SSN, get_salary())
                break
            elif choice == 3:
                update_phone(conn, restaurant_id, staff_SSN, get_phone_number())
                break
            elif choice == 4:
                update_role(conn, restaurant_id, staff_SSN, get_role())
                break

        except ValueError:
            continue

    view_restaurant_staff(conn, restaurant_id)


def update_address(conn, restaurant_id, staff_SSN, new_address):
    """
    Calls the update_staff_address procedure
    :param conn: the DB connection
    :param restaurant_id: Int - the restaurant ID
    :param staff_SSN: Int - the staff SSN to update
    :param new_address: String - the new address
    :return: Void - calls the view_restaurant_staff function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_staff_address", [staff_SSN, new_address])
    cursor.close()



def update_salary(conn, restaurant_id, staff_SSN, new_salary):
    """
    Calls the update_staff_salary procedure
    :param conn: the DB connection
    :param restaurant_id: Int - the restaurant ID
    :param staff_SSN: Int - the staff SSN to update
    :param new_salary: Float - the new salary
    :return: Void - calls the view_restaurant_staff function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_staff_salary", [staff_SSN, new_salary])
    cursor.close()



def update_phone(conn, restaurant_id, staff_SSN, new_phone):
    """
    Calls the update_staff_phone procedure
    :param conn: the DB connection
    :param restaurant_id: Int - the restaurant ID
    :param staff_SSN: Int - the staff SSN to update
    :param new_phone: Int - the new phone number
    :return: Void - calls the view_restaurant_staff function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_staff_phone", [staff_SSN, new_phone])
    cursor.close()



def update_role(conn, restaurant_id, staff_SSN, new_role):
    """
    Calls the update_staff_role procedure
    :param conn: the DB connection
    :param restaurant_id: Int - the restaurant ID
    :param staff_SSN: Int - the staff SSN to update
    :param new_role: String - the new role
    :return: Void - calls the view_restaurant_staff function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("update_staff_role", [staff_SSN, new_role])
    cursor.close()



def remove_staff(conn, restaurant_id, staff_SSN):
    """
    Calls the remove_staff procedure
    :param conn: the DB connection
    :param restaurant_id: Int - the restaurant ID
    :param staff_SSN: Int - the staff SSN to remove
    :return: Void - calls the view_restaurant_staff function
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("remove_staff", [int(staff_SSN), int(restaurant_id)])
    cursor.close()

    view_restaurant_staff(conn, restaurant_id)


def add_staff(conn, restaurant_id, all_staff_SSN):
    """
    Runs the procedures to add a new staff member to the given restaurant ID
    :param conn: the DB connection
    :param restaurant_id: Int- the restaurant_id to add a staff member to
    :return: Void
    """
    cursor = conn.raw_connection().cursor()
    cursor.callproc("add_staff",
                    [
                        get_SSN(all_staff_SSN),
                        restaurant_id, get_name(),
                        get_address(),
                        get_phone_number(),
                        get_salary(),
                        get_role()
                    ])
    cursor.close()


    view_restaurant_staff(conn, restaurant_id)


def get_SSN(all_staff_SSN):
    """
    Requests for a new valid SSN from the user
    :param all_staff_SSN: Array[Int] - the existing SSN's in the database for this restaurant_id
    :return: Int - the new valid SSN
    """
    while True:
        try:
            SSN = int(raw_input("Enter the staff SSN: "))
            if SSN not in all_staff_SSN:
                if len(str(SSN)) == 9:
                    return SSN
                else:
                    print "\n---\nERROR: The given staff SSN is invalid (must be of length 9)\n---\n"
            else:
                print "\n---\nERROR: The given staff SSN already works at this restaurant\n---\n"
        except ValueError:
            continue


def get_address():
    """
    Requests for a new address from the user
    :return: String - the new address
    """
    while True:
        try:
            address = raw_input("Enter the new staff address: ")
            return address
        except ValueError:
            continue


def get_name():
    """
    Requests for a new name from the user
    :return: String - the new name
    """
    while True:
        try:
            name = raw_input("Enter the new staff name (first and last): ")
            return name
        except ValueError:
            continue


def get_phone_number():
    """
    Requests for a new valid phone number from the user
    :return: Int - the new valid phone number
    """
    while True:
        try:
            phone = int(raw_input("Enter the new staff phone number: "))
            if len(str(phone)) == 10:
                return phone
            else:
                print "\n---\nERROR: The given staff phone is invalid (must be of length 10)\n---\n"
        except ValueError:
            continue


def get_salary():
    """
    Requests for a new valid salary from the user
    :return: Float - the new valid salary
    """
    while True:
        try:
            salary = float(raw_input("Enter the new staff salary: "))
            return salary
        except ValueError:
            continue


def get_role():
    """
    Requests for a new role from the user
    :return: String - the new role
    """
    while True:
        try:
            role = raw_input("Enter the new staff role: ")
            return role
        except ValueError:
            continue