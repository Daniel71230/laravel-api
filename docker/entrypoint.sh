#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

# php artisan migrate
sudo apt-get install php-dom
php artisan route:cache
php artisan route:clear
php artisan config:cache
php artisan config:clear
php artisan optimize

php artisan clear
php artisan optimize:clear
#php artisan migrate

#php artisan db:seed

# Fix files ownership.
chown -R nginx .
chown -R nginx /app/storage
chown -R nginx /app/storage/logs
chown -R nginx /app/storage/framework
chown -R nginx /app/storage/framework/sessions
chown -R nginx /app/bootstrap
chown -R nginx /app/bootstrap/cache

# Set correct permission.
chmod -R 775 /app/storage
chmod -R 775 /app/storage/logs
chmod -R 775 /app/storage/framework
chmod -R 775 /app/storage/framework/sessions
chmod -R 775 /app/bootstrap
chmod -R 775 /app/bootstrap/cache

php-fpm -D
nginx -g "daemon off;"
