#!/usr/bin/env bash

touch /etc/nginx/conf.d/docker.conf
# envsubst '$PROJECT_PATCH, $PHP_HOST, $PROJECT_FOLDER' < /etc/nginx/conf.d/docker.conf.template > /etc/nginx/conf.d/docker.conf
nginx -g "daemon off;"
