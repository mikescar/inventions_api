FROM mikescar/heroku-ruby-2.5

ENV APP_HOME /app
# unprivileged account
ENV USER unpriv

RUN mkdir -p $APP_HOME
RUN useradd -m $USER && chown -R $USER $APP_HOME

WORKDIR $APP_HOME

# Copy the rails application.
COPY . ./

RUN chown -R $USER ./

USER $USER

RUN echo "gem: --no-document" >> ~/.gemrc && \
  gem install bundler --user --minimal-deps --no-document && \
  bundle install --jobs 10 --retry 5 --path ./vendor/bundle

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
