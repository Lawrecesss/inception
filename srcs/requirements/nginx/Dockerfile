FROM alpine:3.14

RUN apk --no-cache add nginx openssl

RUN mkdir -p /etc/nginx/ssl/

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=SG/ST=Singapore/L=Singapore/O=42/CN=localhost"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

