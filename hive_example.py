#!/usr/bin/env python3

import socket

from pyhive import hive

connect = hive.connect(
    host=socket.gethostname(),
    port=10000,
    auth="KERBEROS",
    kerberos_service_name="hive",
)

with connect.cursor() as cursor:
    cursor.execute("show tables")
    print(cursor.description)
    for t in cursor.fetchall():
        print(t)
        break
