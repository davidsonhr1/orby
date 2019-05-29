import sys
import os
from os import path
sys.path.append(path.join(path.dirname(__file__), '../../bin/'))
from pycore import get_options
import cx_Oracle
import csv
import re

def extract_csv(query, iterator):
    regex = r"(?<=from)(\s+\w+\b)"
    print(f"Extrating from query: {query}")

    matches = re.search(regex, query)

    with open(f'{matches[0]}.csv', 'w') as fout:
        writer = csv.writer(fout, delimiter =";")
        writer.writerow([ i[0] for i in iterator.description ])
        writer.writerows(iterator.fetchall())

def oracle(ip, user, password):
    sid = ip # .rsplit('-', 1)[1]
    ip = f'aws-{ip}-us'
    port = 1521
    dsn_tns = cx_Oracle.makedsn(ip, port, sid)
    print(f'Connecting on oracle (ip: {ip}, port: {port}, sid: {sid}) - With user: {user}, password: your env => ORACLE_PASSWORD')
    con = cx_Oracle.connect(user, password, dsn_tns)
    return con

def run():
    if get_options().type == 'oracle':
        passwd = str(get_options().password)
        oracle_con = oracle(get_options().url, get_options().client, passwd)
        query = f"""{get_options().query}"""
        print (query)

        cursor = oracle_con.cursor()
        cursor.execute(query)

        extract_csv(get_options().query, cursor)

        cursor.close()
        oracle_con.close()

run()