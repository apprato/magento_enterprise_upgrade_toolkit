#!/bin/sh
#
# Set the correct file permissions for Magento 2
# at startup.

while true;
do
  chmod -R g+rs /var/www

  chmod -R ug+rws /var/www/html/magento2.dev/pub/errors
  chmod -R ug+rws /var/www/html/magento2.dev/pub/static
  chmod -R ug+rws /var/www/html/magento2.dev/pub/media
  chmod -R ug+rws /var/www/html/magento2.dev/app/etc
  chmod -R ug+rws /var/www/html/magento2.dev/var

  chmod ug+x /var/www/html/magento2.dev/bin/magento

  sleep 60
done

