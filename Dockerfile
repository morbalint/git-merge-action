FROM alpine

RUN apk add --no-cache git

ADD *.sh /

ENTRYPOINT ["/git-merge-action.sh"]