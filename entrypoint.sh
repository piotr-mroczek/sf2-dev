#!/bin/bash

if [ $DEBUG ]; then
    echo "xdebug.remote_connect_back=On" >> /etc/php5/fpm/conf.d/20-xdebug.ini
    echo "xdebug.remote_enable=On" >> /etc/php5/fpm/conf.d/20-xdebug.ini
fi

cd /var/www

HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX app/cache app/logs
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX app/cache app/logs

sudo chmod 777 -R app/cache
sudo chmod 777 -R app/logs
sudo chmod 777 -R web/uploads


if [ -z "$1" ];
    then
    composer install
    rm -rf app/cache/*
    php app/console assets:install --symlink web/
    php app/console cache:clear
    php	app/console cache:clear -env=prod
#    php app/console c:w
    service php5-fpm start
    nginx
else
    exec "$@"
fi



