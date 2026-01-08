FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-soap php-intl \
    wget unzip curl mariadb-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html && mkdir -p /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm -rf wordpress latest.tar.gz

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html
	
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf && \
    mkdir -p /run/php
	
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
	
RUN ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm

EXPOSE 9000

COPY tools/wp-config.sh /usr/local/bin/wp-config.sh
RUN chmod +x /usr/local/bin/wp-config.sh

CMD ["/usr/local/bin/wp-config.sh"]
