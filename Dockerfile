FROM php:8.3-alpine3.19

LABEL org.opencontainers.image.description "The official Laracord container for Pterodactyl-based panels."

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=outdead/rcon /rcon /usr/bin/rcon
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache --update --virtual build-deps $PHPIZE_DEPS autoconf \
    && install-php-extensions pcntl bcmath zip gmp iconv opcache intl sockets event uv \
    && (pecl install eio || pecl install eio-beta) \
    && docker-php-ext-enable eio \
    && docker-php-ext-enable --ini-name zzzzz-event.ini event \
    && apk del build-deps

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD [ "/bin/ash", "/entrypoint.sh" ]
