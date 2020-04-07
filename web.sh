#!/bin/bash

service apache2 start
rm -rf /var/run/mysqld/mysqld.sock.lock
service mysql start

# login as admin
# curl -H "Content-Type: multipart/form-data; boundary=---------------------------99260934928688689323850609962" --data '

#-----------------------------99260934928688689323850609962
#Content-Disposition: form-data; name="username"

#admin
#-----------------------------99260934928688689323850609962
#Content-Disposition: form-data; name="password"

#thisisadminspassword
#-----------------------------99260934928688689323850609962
#Content-Disposition: form-data; name="referrer"


#-----------------------------99260934928688689323850609962
#Content-Disposition: form-data; name="action"

#login
#-----------------------------99260934928688689323850609962--

# ' --referer "http://127.0.0.1:80/login.php" -c /var/www/html/new_cookie_2.txt http://127.0.0.1:80/login.php

# update song informations
# curl -X GET -b /var/www/html/new_cookie_2.txt --referer "http://127.0.0.1:80/index.php" http://127.0.0.1:80/admin/catalog.php?action=add_to_catalog\&catalogs[]=1

# update catalog informations

echo 'Waiting for config'
sleep 60

php /var/www/html/bin/catalog_update.inc -cva

rm /var/www/html/install.php

tail -f /var/log/apache2/error.log

