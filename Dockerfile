FROM fooz79/php:7.4

ENV SWOOLE_VER=4.5.11

RUN apk add --no-cache --virtual .build-deps build-base openssl-dev pcre-dev pcre2-dev zlib-dev brotli-dev curl-dev php7-dev \
    # pecl install
    && pecl channel-update pecl.php.net \
    && pecl install -D 'enable-openssl="yes" enable-sockets="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="yes" enable-swoole-curl="yes"' swoole-${SWOOLE_VER} \
    && echo 'extension=swoole.so' > /etc/php7/conf.d/swoole.ini \
    && pecl install -D 'enable-xxtea="yes"' xxtea \
    && echo 'extension=xxtea.so' > .etc/php7/conf.d/xxtea.ini \
    && pecl install ds \
    && echo 'extension=ds.so' > /etc/php7/conf.d/ds.ini \
    && pecl install inotify \
    && echo 'extension=inotify.so' > /etc/php7/conf.d/inotify.ini \
    && apk del .build-deps \
    && rm -rf /tmp/*

COPY php.ini /etc/php7

EXPOSE 9501

WORKDIR /data/nginx/wwwroot
