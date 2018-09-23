FROM mikescar/heroku-ruby-2.5

ENV APP_HOME /app
RUN mkdir -p $APP_HOME

#RUN useradd -m unpriv
#RUN chown unpriv $APP_HOME
#USER unpriv

WORKDIR $APP_HOME

# Copy the rails application.
COPY . ./
RUN echo "gem: --no-document" >> ~/.gemrc && \
  gem install bundler --minimal-deps --no-document && \
  bundle install --jobs 10 --retry 5 --path ./vendor/bundle

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
