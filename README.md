# Docker compose for Laravel

Docker compose configuration for laravel or other popular PHP frameworks.
Includes nginx and mysql for quick development.

## Service versions

**PHP** => 7.4 or 8.1

**Mysql** => 5.7 or latest

## Как развернуть

В корне проекта запустить сборку контейнеров
```
docker-compose up --build -d
```
## php.sh
В скриптах /docker/scripts/php.sh переписываются права на нужные папки и запускается композер

```
for i in cart order catalog promo
do 
  echo -e "$PROJECT_PATCH/$i";
  
  cd $PROJECT_PATCH/$i \
    && cp .env.example .env \
    && composer install \
    && composer run-script post-create-project-cmd \
    && chmod -R 777 bootstrap/ storage/ vendor/ 
done
```
`cart order catalog promo`это список ларавел сервисов в корне проекта.
При добавлении нового сервиса, надо также добавить название папки в список.

## nginx конфиг
Путь /docker/services/nginx/conf.d/nginx.conf.template

Для нового сервиса добавить в конфиг location

```nginx configuration
    location ^~ /${your-service}/ {
        alias /var/www/${your-service}/public/;
        try_files $uri $uri/ @rewrite_${your-service};

        location ~ \.php$ {
            fastcgi_pass backend;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            include fastcgi_params;
        }
    }
    
    location @rewrite_${your-service}{
        rewrite /cart/(.*)$ /cart/index.php?/$1 last;
    }
```
${your-service} = папка нового сервиса.

## upstream
```nginx configuration
upstream backend {
    # имя контейнера:порт
    server proxy_php:9000;
}
```
Если требуется можно поднять еще контейнер с fpm и добавить в upstream
Пример:

```nginx configuration
upstream backend {
    # имя контейнера:порт
    server proxy_php:9000;
    server proxy_php2:9001;
}
```