FROM nginx:1.15.2

COPY build.sh /build.sh

RUN chmod +x /build.sh && /bin/bash -c "source /build.sh"

COPY nginx.conf /etc/nginx/nginx.conf
COPY crs_includes.conf /etc/nginx/conf/crs_includes.conf
COPY main.conf /etc/nginx/conf/main.conf

