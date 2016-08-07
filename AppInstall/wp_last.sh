#!/bin/bash -e
clear
echo -e "\e[31m \e[1m WordPress Install Script"
echo "============================================"
echo -e "\e[31m \e[1m Database Name: "
read -e dbname
echo -e "\e[31m \e[1m Database User: "
read -e dbuser
echo -e "\e[31m \e[1m Database Password: "
read -s dbpass
echo -e "\e[31m \e[1m Run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo -e "\e[100m============================================"
echo -e "\e[100mA robot is now installing WordPress for you."
echo -e "\e[100m============================================"
#download wordpress
curl -O https://wordpress.org/latest.tar.gz
#unzip wordpress
tar -zxvf latest.tar.gz
#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#Remove worpdress folder
rm -R wordpress
#Creating wordpress config
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
echo "Cleaning..."
#remove zip file
rm latest.tar.gz
#remove bash script
rm wp_last.sh
echo "========================="
echo "Installation is complete."
echo "========================="
fi
