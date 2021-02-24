FROM fooz79/php:7.4 as builder

ENV SWOOLE_VER=4.5.11

RUN apk add --no-cache build-base openssl-dev pcre-dev pcre2-dev zlib-dev php7-dev \
    # pecl install
    && pecl channel-update pecl.php.net \
    && pecl install -D 'enable-openssl="yes" enable-sockets="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="yes" enable-swoole-curl="yes"' swoole-${SWOOLE_VER} \
    && echo 'extension=swoole.so' > ./etc/php7/conf.d/swoole.ini \
    && pecl install -D 'enable-xxtea="yes"' xxtea \
    && echo 'extension=xxtea.so' > ./etc/php7/conf.d/xxtea.ini \
    && pecl install ds \
    && echo 'extension=ds.so' > ./etc/php7/conf.d/ds.ini

COPY php.ini /etc/php7

WORKDIR /

RUN tar zcvfp php-extras.tar.gz \
    etc/php7/php.ini \
    etc/php7/conf.d/swoole.ini \
    etc/php7/conf.d/xxtea.ini \
    etc/php7/conf.d/ds.ini \
    usr/lib/php7/modules/swoole.so \
    usr/lib/php7/modules/xxtea.so \
    usr/lib/php7/modules/ds.so

FROM fooz79/php:7.4 as swoole

WORKDIR /

COPY --from=0 /php-extras.tar.gz .

RUN tar zxvfp php-extras.tar.gz \
    && rm php-extras.tar.gz


