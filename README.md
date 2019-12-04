# Magento Enterprise Upgrade Toolkit  #


## Magento Enterprise Edition 1.13.0
* PHP 5.6
* MySQL 5.6
* nGinx
* php-fpm
* redis


### Installation
$ cd env/m2ee_1.13.0/development
$ docker-compose up -d


### Import database
$ cd sql
$ mysql -P 3307 -h 127.0.0.1 -u source_username -p source_database < magento_database1.13.0.sql


### Migration of database m2EE-1.13.0 to m2ee-2.3.2
** Disable cahce, flush cache 
$ php n98-magerun.phar disable:cache

** Install M2ee-2.3.2 Instance (Fresh install preferably with composer and auth keys)
Load front page and export database directly after incase migration goes skewif
Ensure host system has access to both databases (Port 2309 & 3309)
Install Migration Tool to composer
Begin migration
Fix any issues

** Install data migration tool
$ composer config repositories.data-migration-tool git https://github.com/magento/data-migration-tool
$ composer require magento/data-migration-tool:2.2.0

** Configure data migration tool before installation
https://devdocs.magento.com/guides/v2.3/migration/migration-tool-configure.html
$ cd src/m2ee_2.3.2/vendor/magento/data-migration-tool/etc/commerce-to-commerce/1.13.0.0
$ cp config.xml.dis config.xml
Change source destination databases, add crypt key and any other modifications if required.

**Migrate setings:
$ bin/magento migrate:settings vendor/magento/data-migration-tool/etc/commerce-to-commerce/1.13.0.0/config.xml

**Migrate data:
$ bin/magento migrate:data vendor/magento/data-migration-tool/etc/commerce-to-commerce/1.13.0.0/config.xml

** Remove (customer) duplicates
mysql > DELETE FROM `source_database`.`customer_entity` WHERE (`entity_id` = 'xx');

** Duplicate url rewrite breaking install. Run query below to change this on source database & enable <auto_resolve_urlrewrite_duplicates /> in config.xml
SELECT url_rewrite_id, store_id, COUNT(*) as count
FROM core_url_rewrite
GROUP BY request_path, store_id
HAVING COUNT(*) > 1;
mysql > DELETE FROM `source_database`.`core_url_rewrite`  WHERE (`url_rewrite_id` = 'xx');

** Remove products with no SKU which prevent the site from being indexed 
mysql > DELETE FROM `source_database`.`catalog_product_entity` WHERE (`entity_id` = 'xx');

#### Download Magento 2.3.3 files with composer
Download files

$ cd src/m2ee_2.3.2
$ composer create-project --repository=https://repo.magento.com/ magento/project-enterprise-edition:2.2.3 .
$ find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
$ find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
$ chown -R :stephen . # Ubuntu
$ chmod u+x bin/magento


#### Install Magento into database
mysql > CREATE DATABASE destination_database;
mysql > CREATE USER 'destination_database'@'localhost' IDENTIFIED BY 'destination_database';
mysql > GRANT ALL PRIVILEGES ON destination_database.* TO 'destination_database'@'localhost';
mysql > GRANT SUPER ON *.* TO 'destination_database'@localhost;

$ php bin/magento setup:install \
--base-url=http://m2.magento_source.net \
--db-host=localhost \
--db-name=destination_database \
--db-user=destination_database \
--db-password=destination_database \
--backend-frontname=admin \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=stephen@magescale.com \
--admin-user=magescale \
--admin-password=Magescale123 \
--language=en_US \
--currency=AUD \
--timezone=America/Chicago \
--use-rewrites=1


## Installation on Staging


### To update, install vendor files, change into the container as www-data (@TODO add this to the bin/tools.sh file)
docker exec --user www-data -it fpm2-php-stage bash
