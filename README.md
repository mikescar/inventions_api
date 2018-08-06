A sample API implementation that shows some basic style and gem preferences for Ruby on Rails projects.

The API consumer can view a list of parts ("bits"), and specify inventions
based on those parts. A hosted version lives at `inventions-api.herokuapp.com`.

This app has been `docker`-ized, but it is not required if you just want to build and develop the traditional rails way.
Instructions below are provided for a 'local' rails environment, and the docker one. _Don't use both! :)_

## System dependencies
The Ruby on Rails app itself uses `ruby 2.5.1` and `postgres 10.4`.

## Local
`gem install bundler && bundle install`

### Docker
Development environment requires support for `docker-compose` version 2.

To build initial containers: `docker-compose build`. Also run this after changing docker configs
(`Dockerfile`, `docker-compose.yml`).


## Development database creation

### Local
Set your `ENV['DATABASE_URL']` using format: `postgres://#{username}@#{hostname}:#{port}/#{database}`

`rails db:create && rails db:migrate && rails db:migrate RAILS_ENV=test`

### Docker
The default database already exists when we create the postgres container, we just need to add our schema:

`docker-compose run web rails db:migrate`


## Running development environment

### Local
`rails server`

### Docker
`docker-compose up` or `docker-compose up -d` if you want it to run in the background.


## Running tests
Just run `rspec`, or `rspec spec/models` or the like to run a subset of tests. To run only the tests
that failed last time, use `rspec --only-failures`.


## Heroku deployment
Create a heroku app, and after initial deployment plug your APP_NAME into:
```
heroku addons:create heroku-postgresql -a APP_NAME
heroku run rails secrets:setup -a APP_NAME
heroku run rails db:migrate -a APP_NAME
```

## Other notes
I'm keeping old branches around to show I didn't really work on master directly, but on real projects
I do prefer to delete branches after merging to master.
