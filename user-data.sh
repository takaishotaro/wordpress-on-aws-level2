#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo amazon-linux-extras install -y php7.2
sudo yum install -y php php-mbstring
wget https://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo cp -r ./wordpress/* /var/www/html/
sudo chown apache:apache /var/www/html/ -R
sudo touch health.html
sudo echo "<p>health</p>" > health.html
sudo mv health.html /var/www/html/
sudo systemctl start httpd && systemctl enable httpd
