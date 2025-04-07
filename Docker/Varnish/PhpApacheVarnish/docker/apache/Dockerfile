FROM httpd:2.4

COPY phpvarnish.local.conf /usr/local/apache2/conf/conf.d/phpvarnish.local.conf

RUN echo "Include conf/conf.d/*.conf" >> /usr/local/apache2/conf/httpd.conf

RUN echo "ServerName localhost" >> /usr/local/apache2/conf/httpd.conf