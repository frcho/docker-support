#!/bin/sh

set -e

# Prepend environemt variables to the crontab
env |cat - /etc/cron.d/crontab > /tmp/crontab
mv /tmp/crontab /etc/cron.d/crontab

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- supervisord "$@"
fi

if [ "$1" = 'supervisord' ] || [ "$1" = 'artisian' ]; then

       chown -R www-data:www-data   \
              app/storage   \
              app/storage/cache	\
              app/storage/logs	\
              app/storage/meta	\
              app/storage/views	\
              app/storage/sessions	\
              app/services/export_results/ 	\
              app/services/log/api_call_log/ 	\
              public/export_results  	\
              public/files  	\
              public/reply_orders \
              public/images/header  \
              upgrade
              
       chmod -R 766 app/config/database.php \
              app/config/mail.php \
              app/config/cache.php \
              app/config/session.php \
              app/config/license/credentials.php  \
              app/lib/modules.php \
              app/lib/apis.php      
fi

exec "$@"