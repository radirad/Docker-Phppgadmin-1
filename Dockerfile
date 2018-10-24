FROM debian:stretch

MAINTAINER RR <radoslaw.rewinkowski@mentax.pl>

ENV DEBIAN_FRONTEND=noninteractive
# Add the PostgreSQL apt repository
RUN apt-get update && \
    apt-get -y install wget gnupg2 && \
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install apache2 libapache2-mod-php7.0 php7.0 php7.0-pgsql unzip postgresql-client-10 && \
    apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV PORT=5432
ENV HOST=database

WORKDIR /var/www/html

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
  && ln -sf /dev/stdout /var/log/apache2/error.log \
  && chown -R www-data:www-data /var/log/apache2 /var/www/html \
#  && wget https://github.com/phppgadmin/phppgadmin/archive/master.zip \
  && wget https://github.com/ReimuHakurei/phppgadmin/archive/master.zip \
  && rm /var/www/html/index.html && unzip /var/www/html/master.zip \
  && cp -R phppgadmin-master/* . && rm -r phppgadmin-master \
  && rm /var/www/html/master.zip \
  && rm -rf /var/lib/apt/lists/*

ADD config.inc.php /var/www/html/conf/config.inc.php

ADD run.sh /run.sh

RUN chmod -v +x /run.sh

EXPOSE 80

CMD ["/run.sh"]
