# Tiek lejupielādēts PHP docker attēls no ECR izveidotas repozitorijas
FROM 242611965122.dkr.ecr.eu-west-1.amazonaws.com/laravel-api-php-docker:latest as php

# Vides mainīgie
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Darba direktorijas konfigurēšana
WORKDIR /app

# Failu kopēšana no pašreizējas mapes uz konteinera mapi
COPY --chown=web:web . .

# Laravel keša mapju izveidošana
RUN mkdir -p ./storage/framework
RUN mkdir -p ./storage/framework/{cache, testing, sessions, views}
RUN mkdir -p ./storage/framework/bootstrap
RUN mkdir -p ./storage/framework/bootstrap/cache

# Lietotāju un grupu atļauju konfigurēšana
RUN usermod --uid 1000 web
RUN groupmod --gid 1000 web

# Entrypoint konsoles skripta faila (ar vajadzīgām komandam, tajā skaitā datubāzes migrāciju) palaišana
ENTRYPOINT [ "docker/entrypoint.sh" ]
