FROM alpine:3

#RUN apk update
#RUN apk add chromium chromium-chromedriver curl xvfb-run jq busybox-extras
#RUN echo "xvfb-run chromedriver --disable-dev-shm-usage --disable-gpu --no-sandbox --disable-setuid-sandbox &" > start.sh
#ADD test.sh .

RUN apk add --update busybox-extras
COPY pipeline-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

