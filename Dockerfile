FROM alpine
MAINTAINER Julor <julor@qq.com>

RUN mkdir -p /tmp/gocode/src/github.com/julor/tinygraphs

COPY .  /tmp/gocode/src/github.com/julor/tinygraphs

RUN set -x \
  && echo "https://mirrors.ustc.edu.cn/alpine/v3.3/main" > /etc/apk/repositories \
  && echo "https://mirrors.ustc.edu.cn/alpine/v3.3/community" >> /etc/apk/repositories \
  && apk update \
  && buildDeps='go git bzr' \
  && apk add --update $buildDeps \
  && GOPATH=/tmp/gocode GO15VENDOREXPERIMENT=1 go install github.com/julor/tinygraphs/app-backend \
  && mkdir -p /usr/local/tinygraphs/ \
  && mv /tmp/gocode/bin/app-backend /usr/local/tinygraphs/ \
  && chmod +x /usr/local/tinygraphs/app-backend \
  && apk del $buildDeps \
  && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /usr/local/tinygraphs/

EXPOSE 8080

ENTRYPOINT ["./app-backend"]