FROM fooz79/php:8.0

ENV SWOOLE_VER=4.8.6

RUN apk add --no-cache --virtual .build-deps build-base openssl-dev pcre-dev pcre2-dev zlib-dev brotli-dev curl-dev php8-dev \
    # pecl install
    && pecl channel-update pecl.php.net \
    && pecl install -D 'enable-openssl="yes" enable-sockets="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="yes" enable-swoole-curl="yes" enable-thread-context="yes"' swoole-${SWOOLE_VER} \
    && echo 'extension=swoole.so' > /etc/php8/conf.d/swoole.ini \
    && pecl8 install inotify \
    && echo 'extension=inotify.so' > /etc/php7/conf.d/inotify.ini \
    && apk del .build-deps \
    && rm -rf /tmp/*

COPY php8.ini /etc/php8

EXPOSE 9501

WORKDIR /data/nginx/wwwroot
