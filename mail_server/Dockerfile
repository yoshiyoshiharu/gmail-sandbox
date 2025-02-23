FROM ubuntu:20.04

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install postfix -y
RUN apt install -y bsd-mailx

RUN apt install sasl2-bin -y
RUN DEBIAN_FRONTEND=noninteractive apt install cyrus-imapd -y

COPY ./configs/sasl_passwd /etc/postfix/sasl_passwd
COPY ./configs/main.cf /etc/postfix/main.cf

RUN postmap /etc/postfix/sasl_passwd

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
