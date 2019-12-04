FROM php:7.2-fpm

# Update system environment, and Install Magento System Libraries
RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    libmcrypt-dev \
    wget \
    vim \
    tmux \
    sudo \
    bash-completion \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt \
    && apt-get clean

# Configure PHP Magento specific PHP libraries
RUN docker-php-ext-configure \
  	gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  	docker-php-ext-install \
  	opcache \
  	gd \
  	bcmath \
  	intl \
  	mbstring \
  	pdo_mysql \
  	soap \
  	xsl \
  	zip

# Install ohter liraries since PHP 7.2 avilable in PECL only
#RUN pecl install mcrypt-1.0.2
#RUN docker-php-ext-enable mcrypt

# Install Magento PHP Libraries
#RUN docker-php-ext-install \
#  bcmath \
#  gd \
#  intl \
#  mbstring \
#  mcrypt \
#  pdo_mysql \
#  soap \
#  xsl \
# zip

# Install composer, add packages in parallel require
RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer
RUN  composer global require hirak/prestissimo

# set user with uid / gid the same as the host system (user www-data)
RUN usermod -u 1001 www-data

# set ownership permissions for user to match host & php, nginx containers
RUN chown -R www-data:1001 /var/www

# Add configuartion files for php etc.
ADD php-fpm.conf /usr/local/etc/php-fpm.conf
ADD php.ini /usr/local/etc/php/php.ini

# Install n98-magerun.phar magento 2 devops tooling
RUN wget https://files.magerun.net/n98-magerun2.phar \
    && chmod +x ./n98-magerun2.phar \
    && mv ./n98-magerun2.phar /usr/local/bin/

CMD ["php-fpm", "-F"]
