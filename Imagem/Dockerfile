FROM ubuntu

MAINTAINER jorgelasquinha27@gmail.com

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    vim 

COPY apache2/ports.conf /etc/apache2/ports.conf
COPY apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY apache2/index.html /var/www/html/index.html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]

