FROM alpine:edge

RUN apk update && \
    apk add --no-cache ca-certificates curl bash


ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
