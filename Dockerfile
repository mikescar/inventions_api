FROM mikescar/heroku-ruby-2.5

ENV APP_HOME /app
ENV USER unprivileged
ENV USER_AND_GROUP_ID 1001
ENV BASH_PROFILE /home/$USER/.profile

RUN groupadd -g $USER_AND_GROUP_ID $USER && \
    useradd -m -r -s /bin/bash -u $USER_AND_GROUP_ID -g $USER $USER && \
    mkdir -p $APP_HOME

WORKDIR $APP_HOME

# Copy the rails app.
COPY . ./

# TODO do this install as $USER (some fuckery with (GEM_)PATH vars)
RUN echo "gem: --no-document" >> ~/.gemrc && \
    gem install bundler && \
    bundle install --retry 5 --path ./vendor/bundle && \
    chown -R $USER:$USER .

USER $USER

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
