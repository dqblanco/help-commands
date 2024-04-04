FROM nginx:stable-alpine
WORKDIR /var/www

RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 770 /var/cache/nginx /var/run /var/log/nginx

CMD ["nginx"]
EXPOSE 80