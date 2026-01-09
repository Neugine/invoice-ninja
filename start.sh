#!/bin/sh

# Create necessary directories
mkdir -p /var/www/app/storage/logs
mkdir -p /var/www/app/storage/framework/cache
mkdir -p /var/www/app/storage/framework/sessions
mkdir -p /var/www/app/storage/framework/views
mkdir -p /var/www/app/bootstrap/cache

# Set permissions
chown -R www-data:www-data /var/www/app/storage /var/www/app/bootstrap/cache || true

# Run Laravel optimizations
php /var/www/app/artisan config:cache || true
php /var/www/app/artisan route:cache || true
php /var/www/app/artisan view:cache || true

# Run migrations
php /var/www/app/artisan migrate --force || true

# Start PHP-FPM in the background
php-fpm -D

# Start Nginx in the foreground
nginx -g 'daemon off;'
