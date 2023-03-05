FROM alpine:latest

RUN apk add curl docker nodejs
RUN npm i -g codedown
RUN adduser -D user
USER user

CMD cat README.md | codedown sh | sh -xe

