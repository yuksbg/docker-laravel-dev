FROM php:8.0-apache

ENV SUPERVISOR_CONF_DIR=/etc/supervisor.d
ENV SUPERVISOR_CONF_FILE=/etc/supervisord.conf

RUN apt-get update && apt-get install -y \
      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      libzip-dev \
      curl \
      redis \
      supervisor \
      git \
      imagemagick \
      openssh-server \
      default-mysql-client \
      libcurl4-openssl-dev \
      sqlite3 libsqlite3-dev \
      libxml2-dev \
    && pecl install mcrypt \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      intl \
      pcntl \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      zip \
      opcache \
      bcmath \
      curl \
      iconv \
      pdo \
      pdo_sqlite \
      tokenizer \
      xml \
    && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer 

COPY vhost.conf /etc/apache2/sites-available/laravel.conf
RUN a2dissite 000-default.conf && a2ensite laravel.conf && a2enmod rewrite

RUN mkdir -p $SUPERVISOR_CONF_DIR && mkdir -p /run/nginx && mkdir -p /var/www/public
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    && mkdir -p /var/run/sshd \
    && mkdir -p /root/.ssh/ \
    && touch /root/.ssh/authorized_keys \
    && chmod 700 /root/.ssh/ 
COPY supervisor.conf /etc/supervisord.conf
COPY authorized_keys /root/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config

RUN echo "root:root" | chpasswd && chmod 600 /root/.ssh/authorized_keys

WORKDIR /var/www/html
EXPOSE 80
CMD /usr/bin/supervisord -c /etc/supervisord.conf
