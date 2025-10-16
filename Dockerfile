# Dockerfile (PHP 8.2 + Apache)
FROM php:8.2-apache

# Enable useful Apache/PHP modules
RUN a2enmod rewrite headers expires

# Allow .htaccess overrides in /var/www/html
RUN printf '<Directory /var/www/html>\n    AllowOverride All\n    Require all granted\n</Directory>\n' \
    > /etc/apache2/conf-available/override.conf && a2enconf override

# (Optional) install PHP extensions you need
# RUN docker-php-ext-install pdo pdo_mysql

# Copy app code
WORKDIR /var/www/html
COPY . /var/www/html

# Permissions (good defaults; tweak if your app writes to specific dirs)
RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["apache2-foreground"]
