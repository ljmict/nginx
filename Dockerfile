FROM centos:7
LABEL author=ljmict email=ljmict@163.com
ENV NGINX_VERSION=1.16.1
RUN yum -y install gcc pcre pcre-devel openssl-devel make \
    && yum clean all 
RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz \
    && tar xf /tmp/nginx-${NGINX_VERSION}.tar.gz -C /tmp \
    && rm -f /tmp/nginx-${NGINX_VERSION}.tar.gz \
    && useradd nginx -s /sbin/nologin -M
WORKDIR /tmp/nginx-${NGINX_VERSION}
RUN ./configure --prefix=/apps/nginx \
     --conf-path=/etc/nginx/nginx.conf \
     --error-log-path=/var/log/nginx/error.log \
     --http-log-path=/var/log/nginx/access.log \
     --pid-path=/var/run/nginx.pid \
     --lock-path=/var/run/nginx.lock \
     --user=nginx \
     --group=nginx \
     --with-http_ssl_module \
     --with-http_v2_module \
     --with-http_realip_module \
     --with-http_stub_status_module \
     --with-http_gzip_static_module \
     --with-pcre \
     --with-stream \
     --with-stream_ssl_module \
     --with-stream_realip_module \
     && make && make install && make clean \
     && ln -s /apps/nginx/sbin/nginx /usr/local/bin/nginx 
WORKDIR /apps/nginx/html
RUN rm -rf /tmp/nginx-${NGINX_VERSION} \
    && setfacl -Rm u:nginx:rwx /apps/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
