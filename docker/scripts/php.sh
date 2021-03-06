#!/usr/bin/env bash

for i in cart order catalog promo
do 
  echo -e "$PROJECT_PATCH/$i";
  
  cd $PROJECT_PATCH/$i \
    && cp .env.example .env \
    && composer install \
    && composer run-script post-create-project-cmd \
    && chmod -R 777 bootstrap/ storage/ vendor/ 
done


cd $PROJECT_PATCH

chown dev:dev -R $PROJECT_PATCH
supervisord
php-fpm

# until [[ $(nc -z $MYSQL_HOST 3306 &> /dev/null; echo $?) == '0' ]]
#   do
#     echo -e "wait: $MYSQL_HOST:3306";
#     sleep 5
#   done

#php artisan migrate
#php artisan db:seed


