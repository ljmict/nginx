FROM centos:7
ENV NGINX_VERSION=nginx-1.14.0
RUN yum -y install gcc pcre pcre-devel wget openssl-devel make
RUN mkdir -p /opt/software \
    && mkdir -p /application/"${NGINX_VERSION}.tar.gz"
WORKDIR /opt/software
RUN wget -q http://nginx.org/download/"${NGINX_VERSION}.tar.gz"
RUN useradd nginx -s /sbin/nologin -M \
    && tar xvf "${NGINX_VERSION}.tar.gz" 
WORKDIR ${NGINX_VERSION}
RUN ./configure --user=nginx --group=nginx \
    --prefix=/application/${NGINX_VERSION} \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    && make && make install
RUN ln -s /application/${NGINX_VERSION}/ /application/nginx 
EXPOSE 80
CMD ["/application/nginx/sbin/nginx", "-g", "daemon off;"]
