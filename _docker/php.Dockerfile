FROM php:7.4.6-apache

LABEL maintainer="alexandre.trindade@uerj.br"

# Ajuste de timezone para Sao_Paulo
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Comandos a ser executados no container
RUN apt update && apt upgrade -y

# Permissões para as extensões
#RUN chmod -R 777 /usr/local/lib/php/extensions/

# Instalação de drivers necessários
RUN docker-php-ext-install pdo

RUN apt-get install -y apt-utils zlib1g-dev libicu-dev g++ \
    && docker-php-ext-install intl

# Para conversão string para outros tipos de encoding
#RUN docker-php-ext-install mbstring

# Xdebug
#RUN yes | pecl install xdebug \
#    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# ----------------------------------------------------------------
# Conexao com o Postgres (PGSQL)
# ----------------------------------------------------------------
RUN apt install -y libpq-dev
RUN docker-php-ext-install pgsql pdo_pgsql
# ================================================================

# ----------------------------------------------------------------
# Conexao com o Sybase
# ----------------------------------------------------------------
RUN apt install -y \
    unixodbc \
    unixodbc-dev \
    freetds-dev \
    freetds-bin \
    tdsodbc \
    && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu
RUN docker-php-ext-install pdo_dblib

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr
RUN docker-php-ext-install pdo_odbc
COPY webserver/odbcinst.ini /etc/odbcinst.ini

# ================================================================

# ----------------------------------------------------------------
# Geração e uso de QR Code
# ----------------------------------------------------------------
#RUN apt update \
#    && apt install -y \
#       libfreetype6-dev \
#       libjpeg62-turbo-dev \
#       libpng-dev
#
#RUN docker-php-ext-configure gd \
#    --with-gd \
#    --with-jpeg-dir \
#    --with-png-dir \
#    --with-zlib-dir
#    #--enable-gd-native-ttf
#RUN docker-php-ext-install gd
# ================================================================

# Instalação e configuração do mod_rewrite
RUN a2enmod rewrite

# Configuração das variáveis de ambiente do APACHE
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV HTDOCS /var/www/html

# Limpeza da pasta
RUN rm -R $HTDOCS

# Cópia inicial para o HTDOCS
WORKDIR $HTDOCS

# Configuracao do Apache e PHP
COPY webserver/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
COPY webserver/apache2.conf /etc/apache2/apache2.conf

# Atenção: será usado o arquivo ".user.ini" para override do php.ini no ambiente da DINFO. Recomendável customizar lá
COPY webserver/php.ini /usr/local/etc/php/php.ini

# Allow
VOLUME $HTDOCS
RUN chmod -R 777 $HTDOCS

# Expose apache.
EXPOSE 80

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND
