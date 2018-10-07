FROM ruby:2.5.1-alpine

ARG BRANCH
ARG BUILD_DATE
ARG COMMIT_HASH

ENV APP_HOME /app
#ENV APP_USER unprivileged
ENV APP_USER root
ENV APP_GROUP inventions
ENV USER_AND_GROUP_ID 1001
# ENV PROFILE /home/$APP_USER/.profile
ENV PROFILE /root/.profile

ENV APP_BRANCH=$BRANCH \
    APP_BUILD_DATE=$BUILD_DATE \
    APP_COMMIT_HASH=$COMMIT_HASH

# RUN addgroup -S -g $USER_AND_GROUP_ID $APP_GROUP && \
#     adduser -S -h /home/$APP_USER -u $USER_AND_GROUP_ID -G $APP_GROUP $APP_USER && \
RUN echo "GEM_HOME=~/.gem" >> $PROFILE && \
    echo "PATH=~/.gem/ruby/2.5.0/bin:$PATH" >> $PROFILE && \
    # chown $APP_USER:$APP_GROUP $PROFILE && \
    mkdir -p $APP_HOME

RUN apk add build-base postgresql-dev

WORKDIR $APP_HOME

# Copy the rails app.
COPY . ./

# RUN chown -R $APP_USER:$APP_GROUP .

# Use non-root user to install and run app
# USER $APP_USER:$APP_GROUP

RUN echo "gem: --no-document --use-system-libraries" >> ~/.gemrc && \
    . $PROFILE && \
    gem install --user bundler && \
    bundle install --jobs=5 --retry 5 --path ./vendor/bundle

RUN apk del build-base && rm -rf /var/cache/apk/*

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
