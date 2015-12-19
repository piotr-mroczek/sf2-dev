FROM ubuntu:14.04

MAINTAINER Piotr Mroczek <Piotr.Mroczek@ocelotit.pl>

RUN apt-get update && apt-get install -y curl git nginx php5-fpm php5-cli php5-xdebug acl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get install -y php5-mysql
RUN apt-get install -y php-apc
RUN apt-get install -y php5-intl
RUN apt-get install -y php5-gd


RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

COPY config/vhost.conf /etc/nginx/sites-enabled/default
COPY entrypoint.sh /root/entrypoint.sh


RUN chmod +x /root/entrypoint.sh

VOLUME ["/var/www", "/var/log/nginx/"]

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/root/entrypoint.sh"]
