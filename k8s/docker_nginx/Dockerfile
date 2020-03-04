FROM 192.168.1.16:5000/myos:latest
RUN yum -y install gcc make pcre-devel zlib-devel
ADD nginx-1.12.2.tar.gz /
WORKDIR /nginx-1.12.2
RUN ./configure --with-http_stub_status_module --with-http_ssl_module --without-http_autoindex_module 
RUN make
RUN make install
ADD index.html /usr/local/nginx/html/
EXPOSE 80
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
