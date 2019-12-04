#!/bin/sh

# Create user
echo "Adding www-data..."
#echo "......."

#useradd www-data
chown -R daemon:daemon /var/www/html
