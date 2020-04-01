create database ampachedb;
GRANT ALL ON ampachedb.* TO ampacheuser@localhost IDENTIFIED BY 'ubuntu';
flush privileges;