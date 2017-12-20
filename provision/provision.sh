#!/bin/bash

ProjectDomain="invoice-app.dev";
MySQLRootPW="pw";
RootFolder="/var/www/html";
PublicFolder="$RootFolder/Src";
DatabaseName="invoice";
PathToData="$RootFolder/docs/database.sql";

echo "add PPA";
sudo add-apt-repository ppa:ondrej/php  -y >/dev/null;
sudo apt-get update  -y >/dev/null;

echo "Updating repos...";
#export DEBIAN_FRONTEND=noninteractive;
#sudo apt-get update >/dev/null;
echo "Done!";

echo "Installing Server updates...";
sudo apt-get upgrade -y >/dev/null;
echo "Done!";

echo "installing apache2";
sudo apt-get install apache2 -y  >/dev/null;
echo "Done!";


echo "configuring Apache"
cat /etc/apache2/apache2.conf > apache2.conf
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak

sudo echo "" >> apache2.conf;
sudo echo "" >> apache2.conf;
sudo echo "ServerName $ProjectDomain" >> apache2.conf
sudo mv apache2.conf /etc/apache2/apache2.conf

sudo rm $RootFolder/index.html

sudo sed -i 's/www-data/ubuntu/g' /etc/apache2/envvars

echo "Apache2 Config Test!!!";
sudo apache2ctl configtest;
echo "Restart Apache2";
sudo systemctl restart apache2;
echo "done!";

echo "Open Firewall For Apache2!";
sudo ufw allow in "Apache Full"
echo "done!";

echo "Installing MySQL Server...";
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MySQLRootPW"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MySQLRootPW"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $MySQLRootPW"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MySQLRootPW"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $MySQLRootPW"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

sudo apt-get -y install mysql-server phpmyadmin -y >/dev/null;
echo "Done!";

echo "Creating DB...";
mysql -u root -p$MySQLRootPW -e "CREATE DATABASE $DatabaseName"
echo "Importing Data...";
mysql -u root -p$MySQLRootPW $DatabaseName < $PathToData
echo "Done!";

echo "Installing PHP...";
sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql curl php-yaml php-curl php-mbstring zip unzip php7.0-zip php-gettext -y >/dev/null;
echo "Done!";

echo "Configuring PHP";
sudo mv /etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-enabled/dir.conf.bak
sudo echo "<IfModule mod_dir.c>
    DirectoryIndex index.php app.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" > dir.conf;
sudo mv dir.conf /etc/apache2/mods-enabled/dir.conf;
echo "Restart Apache2";
sudo systemctl restart apache2;
echo "Done!";

#echo "<?php
#phpinfo();" > info.php;
#sudo mv info.php $RootFolder/info.php;

echo "Installing composer...";
#curl -sS https://getcomposer.org/installer | php;
#sudo mv composer.phar /usr/local/bin/composer;
#echo "Done!";



echo "Configure Sites...";
#cat /etc/apache2/sites-enabled/000-default.conf > 000-default.conf
sudo mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.bak;

echo "<VirtualHost *:80>
    ServerName $ProjectDomain
    ServerAlias $ProjectDomain

    DocumentRoot $PublicFolder
    <Directory $PublicFolder>
        AllowOverride All
        Order Allow,Deny
        Allow from All
    </Directory>

    # uncomment the following lines if you install assets as symlinks
    # or run into problems when compiling LESS/Sass/CoffeeScript assets
    # <Directory /var/www/project>
    #     Options FollowSymlinks
    # </Directory>

    ErrorLog /var/log/apache2/project_error.log
    CustomLog /var/log/apache2/project_access.log combined
</VirtualHost>
" > 000-default.conf;

sudo mv 000-default.conf /etc/apache2/sites-enabled/000-default.conf

sudo systemctl restart apache2;
echo "Done!";

echo "Enabaling mod rewrite";
sudo a2enmod rewrite;
echo "Restart Apache2";
sudo systemctl restart apache2;
echo "Done!";

echo "create sim-link to /var/www/html";
sudo ln -s /var/www/html/ /home/ubuntu/www;

echo '__     ____  __   ____                _         _';
echo '\ \   / /  \/  | |  _ \ ___  __ _  __| |_   _  | |';
echo ' \ \ / /| |\/| | | |_) / _ \/ _` |/ _` | | | | | |';
echo '  \ V / | |  | | |  _ <  __/ (_| | (_| | |_| | | |';
echo '   \_/  |_|  |_| |_| \_\___|\__,_|\__,_|\__, | |_|';
echo '                                        |___/  (_)';
