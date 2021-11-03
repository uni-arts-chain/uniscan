FROM ruby:2.7.0-alpine AS builder
ARG RAILS_MASTER_KEY
WORKDIR /app
RUN apk add --update --no-cache \
    build-base \
    mariadb-dev \
    git \
    imagemagick \
    ffmpeg \
    icu-dev \
    tzdata \
    nodejs

#Cache bundle install
ADD Gemfile* /app/
RUN bundle config --global frozen 1 \
 && bundle install -j4 --retry 3 \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete
ADD . /app
# RUN  bundle exec rails assets:precompile
# RUN rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec

FROM madnight/docker-alpine-wkhtmltopdf as wkhtmltopdf


FROM ruby:2.7.0-alpine
LABEL maintainer="lixiumiao@gmail.com"
RUN apk add --update --no-cache \
    mariadb-dev \
    imagemagick \
    icu-dev \
    tzdata \
    ffmpeg \
    nodejs
#     libcrypto1.0 libssl1.0 \
#     ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family \
ENV LANG C.UTF-8
ENV APP_ROOT /app
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR $APP_ROOT

COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder $APP_ROOT $APP_ROOT
RUN gem install bundler -v 2.2.3 && gem install rake  -v 12.3.3
RUN date -u > BUILD_TIME

EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
