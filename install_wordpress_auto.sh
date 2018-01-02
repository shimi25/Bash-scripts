
#!/bin/bash
WP_DOMAIN="wordpress.shimon.bitton"
WP_ADMIN_USERNAME="admin"
WP_ADMIN_PASSWORD="admin"
WP_ADMIN_EMAIL="no@spam.org"
WP_DB_NAME="wpdb"
WP_DB_USERNAME="wordpress"
WP_DB_PASSWORD="wordpress"
WP_PATH="/var/www/wordpress"
MYSQL_ROOT_PASSWORD="root"
WP_DB_PASSWORD="1234567890"
MYSQL_ROOT_PASSWORD="1234567890"

# Installation

sudo apt-get update && apt-get upgrade -y
​echo "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
sudo apt-get install -y lamp-server^
sudo apt-get install -y php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd

mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE USER '$WP_DB_USERNAME'@'localhost' IDENTIFIED BY '$WP_DB_PASSWORD';
CREATE DATABASE $WP_DB_NAME;
GRANT ALL ON $WP_DB_NAME.* TO '$WP_DB_USERNAME'@'localhost';
EOF

wget -c http://wordpress.org/latest.tar.gz
​​tar -xzvf latest.tar.gz

sudo mv wordpress /var/www/html

sudo chown -R www-data:www-data /var/www/html/wordpress
​sudo chmod -R 755 /var/www/html/wordpress

cd /var/www/html/wordpress
​sudo mv wp-config-sample.php wp-config.php
sudo sed -i -- 's/database_name_here/wpdb/g' wp-config.php
sudo sed -i -- 's/username_here/root/g' wp-config.php
sudo sed -i -- 's/password_here/1234567890/g' wp-config.php


sudo systemctl restart apache2.service
​sudo systemctl restart mysql.service

sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo y | sudo ufw enable
exit


