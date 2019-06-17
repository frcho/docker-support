#!/bin/sh

set -e

# Prepend environemt variables to the crontab
env |cat - /etc/cron.d/crontab > /tmp/crontab
mv /tmp/crontab /etc/cron.d/crontab

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- supervisord "$@"
fi

if [ "$1" = 'supervisord' ] || [ "$1" = 'bin/console' ]; then

       if [ ! -d "var/cache" ]; then             
              mkdir var/cache
       fi
       if [ ! -d "var/logs" ]; then             
              mkdir var/logs
       fi

       chgrp -R www-data var/cache var/logs
       chmod -R g+w var/cache var/logs

	if [ ! -d "./vendor" ]; then
              composer install --prefer-dist --no-progress --no-suggest --no-interaction
              bin/console assets:install --no-interaction
	fi	     

	if [ "$(ls -A src/Migrations/*.php 2> /dev/null)" ]; then
		bin/console doctrine:migrations:migrate --no-interaction
	fi
fi

exec "$@"