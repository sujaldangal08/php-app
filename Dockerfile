# Use the official PHP image with Apache
FROM php:8.0-apache

# Install any dependencies (e.g., for PHP extensions)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

