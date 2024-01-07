# Tiek lejupielādēts PHP docker attēls no ECR izveidotas repozitorijas
FROM 242611965122.dkr.ecr.eu-west-1.amazonaws.com/php-base-image:latest as php

# Vides mainīgie
COPY ./server/php/php.ini /usr/local/etc/php/php.ini
COPY ./server/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./server/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Darba direktorijas konfigurēšana
WORKDIR /app

# Failu kopēšana no pašreizējas mapes uz konteinera mapi
COPY --chown=www-data:www-data . .

# Laravel keša mapju izveidošana
RUN mkdir -p ./storage/framework
RUN mkdir -p ./storage/framework/{cache, testing, sessions, views}
RUN mkdir -p ./storage/framework/bootstrap
RUN mkdir -p ./storage/framework/bootstrap/cache

# Lietotāju un grupu atļauju konfigurēšana
RUN usermod --uid 1000 www-data
RUN groupmod --gid 1000  www-data

# Entrypoint konsoles skripta faila (ar vajadzīgām komandam, tajā skaitā datubāzes migrāciju) palaišana
ENTRYPOINT [ "server/entrypoint.sh" ]
