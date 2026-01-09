# Use the official Invoice Ninja image as base
FROM invoiceninja/invoiceninja:latest

# Set working directory
WORKDIR /var/www/app

# Expose port (Railway will map this automatically)
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:9000/health || exit 1

# The official image already has the entrypoint configured
# Environment variables will be provided by Railway
