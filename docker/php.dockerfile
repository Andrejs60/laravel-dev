FROM php:8.3.0-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

ENV PHP_USER=laravel
ENV PHP_GROUP=laravel

RUN mkdir -p /var/www/html/public

WORKDIR /var/www/html/public

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system ${PHP_GROUP}
RUN adduser -G ${PHP_GROUP} --system -D -s /bin/sh -u ${UID} ${PHP_USER}

RUN sed -i "s/user = www-data/user = ${PHP_USER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHP_GROUP}/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

RUN docker-php-ext-install pdo pdo_pgsql

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]