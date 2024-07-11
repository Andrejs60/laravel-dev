FROM composer:2

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

ENV COMPOSER_USER=laravel
ENV COMPOSER_GROUP=laravel

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system ${COMPOSER_GROUP}
RUN adduser -G ${COMPOSER_GROUP} --system -D -s /bin/sh -u ${UID} ${COMPOSER_USER}

WORKDIR /var/www/html