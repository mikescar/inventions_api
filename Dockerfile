FROM mikescar/heroku-ruby:2.5

ARG BRANCH
ARG BUILD_DATE
ARG COMMIT_HASH

ENV APP_HOME /app
ENV APP_USER unprivileged
ENV APP_GROUP inventions
ENV USER_AND_GROUP_ID 1001
ENV PROFILE /home/$APP_USER/.profile
ENV BASHRC /home/$APP_USER/.bashrc

ENV APP_BRANCH=$BRANCH \
    APP_BUILD_DATE=$BUILD_DATE \
    APP_COMMIT_HASH=$COMMIT_HASH

RUN groupadd -g $USER_AND_GROUP_ID $APP_GROUP && \
    useradd -m -r -s /bin/bash -u $USER_AND_GROUP_ID -g $APP_GROUP $APP_USER && \
    echo "export GEM_HOME=~/.gem" >> $PROFILE && \
    echo "export PATH=~/.gem/ruby/2.5.0/bin:$PATH" >> $PROFILE && \
    echo "export PATH=~/.gem/ruby/2.5.0/bin:$PATH" >> $BASHRC && \
    mkdir -p $APP_HOME

WORKDIR $APP_HOME

# Copy the rails app.
COPY . ./

RUN chown -R $APP_USER:$APP_GROUP .

SHELL ["/bin/bash", "--login", "-c"]

USER $APP_USER:$APP_GROUP

RUN echo "gem: --no-document" >> ~/.gemrc && \
    gem install --user bundler && \
    bundle install --jobs=5 --retry 5 --path ./vendor/bundle

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
