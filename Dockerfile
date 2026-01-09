FROM invoiceninja/invoiceninja:5

USER root
RUN apk add --no-cache nginx

# Nginx config for Laravel public dir and php-fpm on 127.0.0.1:9000
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/bin/sh", "/start.sh"]
