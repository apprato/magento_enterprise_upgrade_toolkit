#!/bin/sh

# Ensure User owner ships always set to www-data, to catch any issues in deploys
chown -R www-data:www-data /var/www/html