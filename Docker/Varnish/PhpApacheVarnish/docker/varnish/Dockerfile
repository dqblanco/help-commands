FROM varnish:7.7-alpine


COPY default.vcl /etc/varnish/
#COPY subroutines/* /etc/varnish/subroutines/
WORKDIR /etc/varnish/
CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-s", "malloc,2G"]