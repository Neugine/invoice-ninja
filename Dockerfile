# Use the official Invoice Ninja image as base
FROM invoiceninja/invoiceninja:latest

# Switch to root to modify PHP configuration
USER root

# Set working directory
WORKDIR /var/www/app

# Increase PHP memory limit to prevent initialization errors
# Create custom PHP configuration
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini && \
    echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/memory-limit.ini && \
    echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/memory-limit.ini && \
    echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/memory-limit.ini

# Switch back to the original user
USER www-data

# Set default environment variables for PHP
ENV PHP_MEMORY_LIMIT=512M \
    PHP_UPLOAD_MAX_FILESIZE=100M \
    PHP_POST_MAX_SIZE=100M

# Expose port (Railway will map this automatically)
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:9000/health || exit 1

# The official image already has the entrypoint configured
# Environment variables will be provided by Railway
