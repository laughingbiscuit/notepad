FROM alpine:latest

RUN apk add curl docker nodejs npm
RUN npm i -g codedown
RUN adduser -D user -G docker
USER user

CMD cat README.md | codedown sh | sh -xe

