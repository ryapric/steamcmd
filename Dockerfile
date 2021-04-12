FROM debian:buster

COPY . .

RUN bash steamcmd.sh init

CMD ["sh", "-c", "bash steamcmd.sh run ${app_name}"]
