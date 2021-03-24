install_zabbix_server_packages:
  pkg.installed:
    - pkgs:
      - mysql-server
      - python-pymysql
      - zabbix-server-mysql
      - zabbix-frontend-php
      - zabbix-apache-conf


zabbix create db:
  mysql_database.present:
    - name: zabbix
    - character_set: utf8
    - collate: utf8_bin

zabbix grant localhost:
  mysql_user.present:
    - name: zabbix
    - password: {{ pillar['DBPassword'] }}
    - host: localhost
  mysql_grants.present:
    - grant: all privileges
    - database: zabbix.*
    - user: zabbix
    - host: localhost

exprot_schema:
  cmd.run:
    - name: zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz > /usr/share/doc/zabbix-server-mysql/create.sql
    - creates: /usr/share/doc/zabbix-server-mysql/create.sql


import_schema:
  mysql_query.run_file:
    - database: zabbix
    - query_file: /usr/share/doc/zabbix-server-mysql/create.sql
