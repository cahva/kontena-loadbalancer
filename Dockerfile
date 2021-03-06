FROM haproxy:1.8.3-alpine
MAINTAINER Kontena, Inc. <info@kontena.io>

ENV STATS_PASSWORD=secret \
    PATH="/app/bin:${PATH}"

RUN apk update && apk --update add bash tzdata ruby ruby-irb ruby-bigdecimal \
    ruby-io-console ruby-json ruby-rake ca-certificates libssl1.0 openssl libstdc++

ADD Gemfile Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base openssl-dev && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

ADD . /app
ADD errors/* /etc/haproxy/errors/
EXPOSE 80 443
WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh"]
