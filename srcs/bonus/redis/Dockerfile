FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y redis-server

COPY redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]