FROM nginx:stable-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

ENV NGINX_USER=laravel
ENV NGINX_GROUP=laravel

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

# Create the folder that our site source will be attached to
RUN mkdir -p /var/www/html/public

# Pull in a config file to set up our sites root path, server name and other attributes
ADD nginx/default.conf /etc/nginx/conf.d/

# Adjust what user the NGINX process runs on
# Finds nginx/user in nginx.conf and replaces with laravel
RUN sed -i "s/user nginx/user ${NGINX_USER}/g" /etc/nginx/nginx.conf

# Make the laravel user
RUN addgroup -g ${GID} --system ${NGINX_GROUP}
RUN adduser -G ${NGINX_GROUP} --system -D -s /bin/sh -u ${UID} ${NGINX_USER}