import psycopg2

from db.config import config_database


def get_poi(name):
    connection = None
    try:
        connection = psycopg2.connect(**config_database())
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

