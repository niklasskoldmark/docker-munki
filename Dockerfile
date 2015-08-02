FROM debian:8.1

MAINTAINER Niklas Skoldmark <niklas.skoldmark@gmail.com>

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.3-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

ADD nginx.conf /etc/nginx/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log

RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /etc/nginx/sites-enabled/

ADD munki-repo.conf /etc/nginx/sites-enabled/

RUN mkdir -p /munki_repo

VOLUME /var/cache/nginx /munki_repo

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
