FROM mikescar/heroku-ruby-2.5

ENV APP_HOME /app
RUN mkdir -p $APP_HOME

#RUN useradd -m unpriv
#RUN chown unpriv $APP_HOME
#USER unpriv

WORKDIR $APP_HOME

# Copy the rails application.
COPY . ./
RUN bundle install --jobs 10 --retry 5

# Heroku ignores this
EXPOSE 3000

# Run the app. CMD is required to run on Heroku
CMD bundle exec puma -C config/puma.rb
