# Replace Ruby version below with your application's Ruby version. Delete this comment.
FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN groupadd -r unpriv && useradd --no-log-init -r -g unpriv unpriv && \
    chmod +x /usr/bin/entrypoint.sh && \
    chown -R unpriv:unpriv /app /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

USER unpriv

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]