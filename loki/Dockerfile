FROM alpine:3.13

# use http else apk add not working behind proxy
RUN sed -i 's/https/http/g' /etc/apk/repositories
RUN apk add --no-cache tini

# Configure cron
COPY crontab /var/spool/cron/crontabs/root
COPY cleanup.sh /cleanup.sh
RUN chmod 755 /cleanup.sh

ENV SPACEMONITORING_FOLDER="."
ENV SPACEMONITORING_MAXUSEDPERCENTE=90
ENV SPACEMONITORING_DELETINGITERATION=10

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["crond", "-f",  "-l", "2"]
