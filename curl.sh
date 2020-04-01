#!/bin/bash

apt install curl -y
if [ $? -ge 0 ]; then
    service apache2 start
fi
if [ $? -ge 0 ]; then
    service mysql start
fi

if [ $? -ge 0 ]; then
sleep 3
# select language
curl -H "Content-Type: multipart/form-data; boundary=---------------------------147733240426594" --data '
-----------------------------147733240426594
Content-Disposition: form-data; name="htmllang"

zh_CN
-----------------------------147733240426594--
' --referer "http://127.0.0.1:80/install.php" http://127.0.0.1:80/install.php?action=check

sleep 3

# init
curl -H "Content-Type: multipart/form-data; boundary=---------------------------147733240426594" --data '
-----------------------------147733240426594
Content-Disposition: form-data; name="htmllang"

zh_CN
-----------------------------147733240426594--
' --referer "http://127.0.0.1:80/install.php" http://127.0.0.1:80/install.php?action=init

sleep 3

# set database
curl -H "Content-Type: multipart/form-data; boundary=---------------------------130462954931079" --data '

-----------------------------130462954931079
Content-Disposition: form-data; name="local_db"

ampachedb
-----------------------------130462954931079
Content-Disposition: form-data; name="local_host"

localhost
-----------------------------130462954931079
Content-Disposition: form-data; name="local_port"


-----------------------------130462954931079
Content-Disposition: form-data; name="local_username"

ampacheuser
-----------------------------130462954931079
Content-Disposition: form-data; name="local_pass"

ubuntu
-----------------------------130462954931079
Content-Disposition: form-data; name="create_db"

1
-----------------------------130462954931079
Content-Disposition: form-data; name="overwrite_db"

1
-----------------------------130462954931079
Content-Disposition: form-data; name="create_tables"

1
-----------------------------130462954931079
Content-Disposition: form-data; name="db_username"

ampache
-----------------------------130462954931079
Content-Disposition: form-data; name="db_password"


-----------------------------130462954931079--
' --referer "http://127.0.0.1:80/install.php?action=create_db&htmllang=zh_CN&charset=" http://127.0.0.1:80/install.php?action=create_db&htmllang=zh_CN&charset=

sleep 3

# set service config
curl -H "Content-Type: multipart/form-data; boundary=---------------------------160371408127447" --data '

-----------------------------160371408127447
Content-Disposition: form-data; name="web_path"


-----------------------------160371408127447
Content-Disposition: form-data; name="local_db"

ampachedb
-----------------------------160371408127447
Content-Disposition: form-data; name="local_host"

localhost
-----------------------------160371408127447
Content-Disposition: form-data; name="local_port"


-----------------------------160371408127447
Content-Disposition: form-data; name="local_username"

ampacheuser
-----------------------------160371408127447
Content-Disposition: form-data; name="local_pass"

ubuntu
-----------------------------160371408127447
Content-Disposition: form-data; name="htmllang"

zh_CN
-----------------------------160371408127447
Content-Disposition: form-data; name="charset"


-----------------------------160371408127447
Content-Disposition: form-data; name="usecase"

community
-----------------------------160371408127447
Content-Disposition: form-data; name="transcode_template"


-----------------------------160371408127447
Content-Disposition: form-data; name="backends[]"

subsonic
-----------------------------160371408127447
Content-Disposition: form-data; name="write"


-----------------------------160371408127447--
' --referer "http://127.0.0.1:80/install.php?action=create_db&htmllang=zh_CN&charset=" http://127.0.0.1:80/install.php?action=create_config

sleep 3

# set admin
curl -H "Content-Type: multipart/form-data; boundary=---------------------------81541007716" --data '

-----------------------------81541007716
Content-Disposition: form-data; name="local_username"

admin
-----------------------------81541007716
Content-Disposition: form-data; name="local_pass"

thisisadminspassword
-----------------------------81541007716
Content-Disposition: form-data; name="local_pass2"

thisisadminspassword
-----------------------------81541007716--
' --referer "http://127.0.0.1:80/install.php?action=create_config" -c /var/www/html/cookie.txt http://127.0.0.1:80/install.php?action=create_account&htmllang=zh_CN&charset=

sleep 3

# update
curl -H "Content-Type: multipart/form-data; boundary=---------------------------235183233228977" --data '

-----------------------------235183233228977
Content-Disposition: form-data; name="update"


-----------------------------235183233228977--
' --referer "http://127.0.0.1:80/update.php" -b /var/www/html/cookie.txt http://127.0.0.1:80/update.php?action=update

sleep 3

# login as admin
curl -H "Content-Type: multipart/form-data; boundary=---------------------------99260934928688689323850609962" --data '

-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="username"

admin
-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="password"

thisisadminspassword
-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="referrer"


-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="action"

login
-----------------------------99260934928688689323850609962--

' --referer "http://127.0.0.1:80/login.php" -b /var/www/html/cookie.txt -c /var/www/html/new_cookie.txt http://127.0.0.1:80/login.php


# set email
# download form_validation
curl -X GET -o /var/www/html/validation.txt -b /var/www/html/new_cookie.txt --referer "http://127.0.0.1:80/index.php" http://127.0.0.1:80/admin/users.php?action=show_edit&user_id=1

while [ ! -e "/var/www/html/validation.txt" ]
do
	sleep 5
done

# get form_validation
path=$(cat /var/www/html/validation.txt)

latter=${path#*form_validation\" value=\"}

validation=${latter:0:32}

echo "validation is $validation \n"

# set POST data
data_head="username=admin&fullname=Administrator&email=123456%40gmail.com&website=&state=&city=&password_1=&password_2=&access=100&MAX_FILE_SIZE=1048576&preset=&action=update_user&form_validation="
data_tail="&user_id=1"
post_data=$data_head$validation$data_tail

# set email
curl -X POST --data $post_data --referer "http://127.0.0.1:80/index.php" -b /var/www/html/new_cookie.txt http://127.0.0.1:80/admin/users.php


# login as admin again
curl -H "Content-Type: multipart/form-data; boundary=---------------------------99260934928688689323850609962" --data '

-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="username"

admin
-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="password"

thisisadminspassword
-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="referrer"


-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="action"

login
-----------------------------99260934928688689323850609962--

' --referer "http://127.0.0.1:80/login.php" -b /var/www/html/new_cookie.txt -c /var/www/html/new_cookie_2.txt http://127.0.0.1:80/login.php




# set music folder(considering this command is executed before the whole compose is up, I prefer using local music files)
curl -X GET -o /var/www/html/music_validation.txt -b /var/www/html/new_cookie_2.txt --referer "http://127.0.0.1:80/index.php" http://127.0.0.1:80/admin/catalog.php?action=show_add_catalog

while [ ! -e "/var/www/html/music_validation.txt" ]
do
        sleep 5
done

# get form_validation
music_path=$(cat /var/www/html/music_validation.txt)

latter=${music_path#*form_validation\" value=\"}

music_validation=${latter:0:32}

echo "music_validation is $music_validation "

# set POST data(email)
music_data_head="name=music&type=local&rename_pattern=%25T+-+%25t&sort_pattern=%25a%2F%25A&gather_art=1&gather_media=music&path=%2Fmedia&action=add_catalog&form_validation="
music_post_data=$music_data_head$music_validation

# set music folder
curl -X POST --data $music_post_data --referer "http://127.0.0.1:80/index.php" -b /var/www/html/new_cookie_2.txt http://127.0.0.1:80/admin/catalog.php

echo "Creating catalog..."
sleep 3

# login as admin again
curl -H "Content-Type: multipart/form-data; boundary=---------------------------99260934928688689323850609962" --data '

-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="username"

admin
-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="password"

thisisadminspassword
-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="referrer"


-----------------------------99260934928688689323850609962
Content-Disposition: form-data; name="action"

login
-----------------------------99260934928688689323850609962--

' --referer "http://127.0.0.1:80/login.php" -c /var/www/html/new_cookie_3.txt http://127.0.0.1:80/login.php


# show catalog informations
curl -X GET -b /var/www/html/new_cookie_3.txt --referer "http://127.0.0.1:80/index.php" http://127.0.0.1:80/admin/catalog.php?action=show_catalogs

# update catalog informations
php /var/www/html/bin/catalog_update.inc -cva

service apache2 stop

service mysql stop

fi
