import psycopg2

from db.config import config_database


# conn = psycopg2.connect(conn_string)


def get_poi(name):
    connection = None
    try:
        connection = psycopg2.connect(conn_string)
        cursor = connection.cursor()

        query = f"select * from pois where name='{name}'"
        cursor.execute(query)
        result = cursor.fetchone()
        cursor.close()

        return result
    except psycopg2.DatabaseError as e:
        print(e)
    finally:
        if connection:
            connection.close()


def get_opening_hours(poi_id):
    connection = None
    try:
        connection = psycopg2.connect(conn_string)
        cursor = connection.cursor()
        query = f"select day, opening_time, closing_time from opening_hours where poi_id={poi_id}"
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()

        return result
    except psycopg2.DatabaseError as e:
        print(e)
    finally:
        if connection:
            connection.close()


