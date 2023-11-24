#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

# php artisan migrate/seed
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

# Files ownership change.
chown -r www-data .
chown -r www-data /app/storage
chown -r www-data /app/storage/logs
chown -r www-data /app/storage/framework
chown -r www-data /app/storage/framework/sessions
chown -r www-data /app/bootstrap
chown -r www-data /app/bootstrap/cache

# Modifying permissions.
chmod -r 775 /app/storage
chmod -r 775 /app/storage/logs
chmod -r 775 /app/storage/framework
chmod -r 775 /app/storage/framework/sessions
chmod -r 775 /app/bootstrap
chmod -r 775 /app/bootstrap/cache

# Start PHP FPM process manager in the background
php-fpm -D
# Start nginx web server in the background
nginx -g "daemon off;"
