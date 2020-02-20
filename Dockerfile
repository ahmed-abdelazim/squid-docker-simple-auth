FROM ubuntu:14.04
MAINTAINER Rob Haswell <me@robhaswell.co.uk>

RUN apt-get -qqy update
RUN apt-get -qqy upgrade
RUN apt-get -qqy install apache2-utils squid3

# If you are prone to gouging your eyes out, do not read the following 2 lines
RUN sed -i 'acl localnet src 206.189.31.0/24' /etc/squid3/squid.conf
RUN sed -i 'http_access allow localnet' /etc/squid3/squid.conf
RUN sed -i 's@#\tauth_param basic program /usr/lib/squid3/basic_ncsa_auth /usr/etc/passwd@auth_param basic program /usr/lib/squid3/basic_ncsa_auth /usr/etc/passwd\nacl ncsa_users proxy_auth REQUIRED@' /etc/squid3/squid.conf
RUN sed -i 's@^http_access allow localhost$@\0\nhttp_access allow ncsa_users@' /etc/squid3/squid.conf
RUN echo "forwarded_for delete" >> /etc/squid3/squid.conf
RUN echo "via off" >> /etc/squid3/squid.conf
RUN echo "follow_x_forwarded_for deny all" >> /etc/squid3/squid.conf
RUN echo "request_header_access X-Forwarded-For deny all" >> /etc/squid3/squid.conf

RUN mkdir /usr/etc

EXPOSE 3128
VOLUME /var/log/squid3

ADD init /init
CMD ["/init"]
