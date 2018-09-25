FROM mikescar/heroku-ruby:2.5

ENV APP_HOME /app
ENV USER unprivileged
ENV GROUP inventions
ENV USER_AND_GROUP_ID 1001
ENV PROFILE /home/$USER/.profile
ENV BASHRC /home/$USER/.bashrc

RUN groupadd -g $USER_AND_GROUP_ID $GROUP && \
    useradd -m -r -s /bin/bash -u $USER_AND_GROUP_ID -g $GROUP $USER && \
    echo "export GEM_HOME=~/.gem" >> $PROFILE && \
    echo "export PATH=~/.gem/ruby/2.5.0/bin:$PATH" >> $PROFILE && \
    echo "export PATH=~/.gem/ruby/2.5.0/bin:$PATH" >> $BASHRC && \
    mkdir -p $APP_HOME

WORKDIR $APP_HOME

# Copy the rails app.
COPY . ./

RUN chown -R $USER:$GROUP .

SHELL ["/bin/bash", "--login", "-c"]

USER $USER:$GROUP

RUN echo "gem: --no-document" >> ~/.gemrc && \
    gem install --user bundler && \
    bundle install --jobs=5 --retry 5 --path ./vendor/bundle

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
