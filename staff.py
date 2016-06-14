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

    for (SSN, staff_name, address, phone_number, salary, start_date, role) in results:
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
