FROM php:8.2-apache

# Enable Apache modules
RUN a2enmod rewrite headers expires

# Allow .htaccess in /var/www/html
RUN printf '<Directory /var/www/html>\n    AllowOverride All\n    Require all granted\n</Directory>\n' \
    > /etc/apache2/conf-available/override.conf && a2enconf override

WORKDIR /var/www/html
COPY . /var/www/html

# Permissions (adjust if app needs writable dirs)
RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \; \
 && mkdir -p /var/www/html/.data /var/www/html/ogas

EXPOSE 80
CMD ["apache2-foreground"]
