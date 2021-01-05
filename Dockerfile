FROM alpine:latest

RUN apk --no-cache add bash mosquitto-clients python3 py3-pip dcron libcap jq coreutils && \
    pip3 install --upgrade pip && \
    pip3 install awscli && \
    rm -rf /var/cache/apk/*

RUN addgroup -S foo && adduser -S foo -G foo && \
    chown foo:foo /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond

ADD ./awsscript.sh /opt/awsscript.sh
ADD ./entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh /opt/awsscript.sh

USER foo

ENTRYPOINT /opt/entrypoint.sh

