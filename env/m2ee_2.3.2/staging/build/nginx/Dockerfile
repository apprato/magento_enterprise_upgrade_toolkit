FROM nginx:1.10.1

RUN usermod -u 1001 www-data 

# Update system environment Libraries
RUN apt-get update \
  && apt-get install -y \
    vim \
    tmux

# Add nginx configuration files
ADD nginx.conf /etc/nginx/nginx.conf
ADD sites-enabled/magento2.conf /etc/nginx/conf.d/magento2.conf
ADD .htpasswd /etc/nginx/.htpasswd

# set user with uid / gid the same as the host system (user www-data)
RUN usermod -u 1001 www-data

CMD ["nginx", "-g", "daemon off;"]

