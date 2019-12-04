#!/bin/sh
#
# Set the correct file permissions for Magento 1
# at startup.

while true;
do
  #chgrp -R 33 /var/www
  chmod -R g+rs /var/www
  chmod -R ug+rws /var/www/html/magento.dev
  chmod 777 /var/www/html/magento.dev
  # media
  mkdir /var/www/html/magento.dev/media/import
  chmod 777 /var/www/html/magento/dev/media/import
  sleep 60
done
