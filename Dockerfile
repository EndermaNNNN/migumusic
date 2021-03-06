FROM ubuntu:18.04
USER root

RUN apt update \
    && apt install apache2 -y \
    && apt install mysql-server -y \
    && apt install unzip -y

ENV DEBIAN_FRONTEND noninteractive
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt install php7.2 -y

RUN apt install php7.2-pdo php7.2-cli php7.2-gd php7.2-xml mcrypt -y
RUN apt install php7.2-mysql -y\
    && apt install php7.2-curl -y

ADD ampachesql.sql /var/www/html/ampachesql.sql
RUN service mysql start \
    && mysql -u root -p123456 < /var/www/html/ampachesql.sql
RUN sed -i "s/;extension=pdo_mysql/extension=pdo_mysql/g" /etc/php/7.2/cli/php.ini \
    && sed -i "s/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index/g" /etc/apache2/mods-enabled/dir.conf

ADD ampache-3.9.0_all.zip /var/www/html/ampache-3.9.0_all.zip
RUN unzip -d /var/www/html/ /var/www/html/ampache-3.9.0_all.zip \
    && chmod -R a+rw /var/www/html/config/

RUN service mysql restart \
    && service apache2 restart

ADD music.zip /
RUN chmod -R 777 /media \
    && unzip -d /media /music.zip

ADD curl.sh /var/www/html/curl.sh
RUN chmod +x /var/www/html/curl.sh \
    && bash /var/www/html/curl.sh
ADD start_svc.sh /
CMD ["bash", "-c", "echo 1 && bash /start_svc.sh"]
#ADD entrypoint.sh /var/www/html/entrypoint.sh
#RUN chmod +x /var/www/html/entrypoint.sh
#ENTRYPOINT ["/var/www/html/entrypoint.sh"]
