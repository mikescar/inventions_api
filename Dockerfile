FROM mikescar/heroku-ruby-2.5

ENV APP_HOME /app
RUN mkdir -p $APP_HOME

#RUN useradd -m unpriv
#RUN chown unpriv $APP_HOME
#USER unpriv

WORKDIR $APP_HOME

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

# Heroku ignores this
EXPOSE 3000

# Run the app. CMD is required to run on Heroku
CMD bundle exec puma -C config/puma.rb
