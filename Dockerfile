### Base ###

FROM ruby:2.7.1-alpine as base

# Install requirements to run app
RUN apk add --no-cache --update \
                                mysql-dev \
                                nodejs \
                                tzdata

# Install bundler
RUN gem install bundler

# RDS Certificates
ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem /etc/ssl/certs/rds-combined-ca-bundle.pem


### Build ###

FROM base as builder

# Install requirements to build app
RUN apk add --no-cache --update \
                                git \
                                build-base

# Copy gemfiles into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install \
                   --jobs `expr $(cat /proc/cpuinfo | grep -c 'cpu cores')` \
                   --retry 3


### App ###

FROM base

# App path
ENV APP_PATH=/app

# Create app path
RUN mkdir -p $APP_PATH

# Set app workdir
WORKDIR $APP_PATH

EXPOSE 3000

# Copy gems from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Set entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["bundle", "exec", "bin/rails", "server", "-p", "3000", "-b", "0.0.0.0"]
