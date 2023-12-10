#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

# php artisan migrate/seed
apt-get install php-dom
php artisan route:cache
php artisan route:clear
php artisan config:cache
php artisan config:clear
php artisan optimize

php artisan clear
php artisan optimize:clear
php artisan cache:clear
#php artisan migrate

#php artisan db:seed

# Files ownership change.
chown -R web .
chown -R web /app/storage
chown -R web /app/storage/logs
chown -R web /app/storage/framework
chown -R web /app/storage/framework/sessions
chown -R web /app/bootstrap
chown -R web /app/bootstrap/cache

# Modifying permissions.
chmod -R 775 /app/storage
chmod -R 775 /app/storage/logs
chmod -R 775 /app/storage/framework
chmod -R 775 /app/storage/framework/sessions
chmod -R 775 /app/bootstrap
chmod -R 775 /app/bootstrap/cache

# Start PHP FPM process manager in the background
php-fpm -D
# Start nginx web server in the background
nginx -g "daemon off;"
