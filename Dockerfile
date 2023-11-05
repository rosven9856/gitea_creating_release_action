FROM alpine:3.18.4

RUN apk update
RUN apk add --no-cache curl
RUN apk add --no-cache jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]